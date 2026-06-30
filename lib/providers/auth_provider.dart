import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../features/auth/data/auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _authService.authStateChanges.listen((user) {
      _user = user;

      if (user != null) {
        _fetchUserModel(user.uid);
      } else {
        _userModel = null;
      }

      notifyListeners();
    });
  }

  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String? get error => _error;

  Future<void> _fetchUserModel(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists && doc.data() != null) {
      _userModel = UserModel.fromMap(doc.data()!);
    } else {
      _userModel = null;
    }

    notifyListeners();
  }

  Future<bool> loginWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.loginWithEmail(email: email, password: password);
      _error = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapError(e.code);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> registerWithEmail(
    String email,
    String password,
    String name,
    String phone,
    String role,
  ) async {
    _setLoading(true);
    try {
      await _authService.registerWithEmail(
        email: email,
        password: password,
        name: name,
        phone: phone,
        role: role,
      );

      _error = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapError(e.code);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    try {
      await _authService.signInWithGoogle();
      _error = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapError(e.code);
      return false;
    } catch (e) {
      _error = e.toString().contains('cancelled')
          ? 'Google sign-in was cancelled'
          : 'Google sign-in failed';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    try {
      await _authService.sendPasswordResetEmail(email);
      _error = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapError(e.code);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String city,
    String? surname,
  }) async {
    if (_user == null) {
      _error = 'User not found';
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      await _firestoreService.updateUserProfile(
        uid: _user!.uid,
        name: name,
        email: email,
        phone: phone,
        city: city,
        photoUrl: _userModel?.photoUrl,
        surname: surname,
      );

      await _fetchUserModel(_user!.uid);
      _error = null;
      return true;
    } catch (_) {
      _error = 'Failed to update profile';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteAccount() async {
    if (_user == null) {
      _error = 'User not found';
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      await _firestoreService.deleteUserData(_user!.uid);
      await _authService.deleteCurrentUser();
      _error = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapError(e.code);
      return false;
    } catch (_) {
      _error = 'Failed to delete account';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _mapError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'User not found';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password too weak (minimum 6 characters)';
      case 'invalid-email':
        return 'Invalid email address';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'network-request-failed':
        return 'Check your internet connection';
      case 'requires-recent-login':
        return 'Please sign in again and retry';
      default:
        return 'An error occurred. Please try again';
    }
  }
}