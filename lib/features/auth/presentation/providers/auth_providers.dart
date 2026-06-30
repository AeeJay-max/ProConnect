import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/firestore_service.dart';
import '../../data/auth_service.dart';
import '../../domain/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final userModelProvider = StreamProvider<UserModel?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges.asyncMap((user) async {
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  });
});

class AuthUiState {
  const AuthUiState({this.isLoading = false, this.error});

  final bool isLoading;
  final String? error;

  AuthUiState copyWith({bool? isLoading, String? error}) {
    return AuthUiState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthController extends Notifier<AuthUiState> {
  @override
  AuthUiState build() => const AuthUiState();

  AuthService get _authService => ref.read(authServiceProvider);

  Future<bool> loginWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.loginWithEmail(email: email, password: password);
      state = const AuthUiState();
      return true;
    } on FirebaseAuthException catch (e) {
      state = AuthUiState(error: _mapError(e.code));
      return false;
    }
  }

  Future<bool> registerWithEmail(
    String email,
    String password,
    String name,
    String phone,
    String role,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.registerWithEmail(
        email: email,
        password: password,
        name: name,
        phone: phone,
        role: role,
      );
      state = const AuthUiState();
      return true;
    } on FirebaseAuthException catch (e) {
      state = AuthUiState(error: _mapError(e.code));
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.signInWithGoogle();
      state = const AuthUiState();
      return true;
    } on FirebaseAuthException catch (e) {
      state = AuthUiState(error: _mapError(e.code));
      return false;
    } catch (e) {
      state = AuthUiState(
        error: e.toString().contains('cancelled')
            ? 'Google sign-in cancelled'
            : 'Google sign-in failed',
      );
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.sendPasswordResetEmail(email);
      state = const AuthUiState();
      return true;
    } on FirebaseAuthException catch (e) {
      state = AuthUiState(error: _mapError(e.code));
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String city,
    String? surname,
    String? photoUrl,
  }) async {
    final user = _authService.currentUser;

    if (user == null) {
      state = const AuthUiState(error: 'User not found');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref.read(firestoreServiceProvider).updateUserProfile(
            uid: user.uid,
            name: name,
            email: email,
            phone: phone,
            city: city,
            photoUrl: photoUrl,
            surname: surname,
          );

      state = const AuthUiState();
      ref.invalidate(userModelProvider);
      return true;
    } catch (_) {
      state = const AuthUiState(error: 'Failed to update profile');
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    final user = _authService.currentUser;

    if (user == null) {
      state = const AuthUiState(error: 'User not found');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref.read(firestoreServiceProvider).deleteUserData(user.uid);
      await user.delete();

      state = const AuthUiState();
      return true;
    } on FirebaseAuthException catch (e) {
      state = AuthUiState(error: _mapError(e.code));
      return false;
    } catch (_) {
      state = const AuthUiState(error: 'Failed to delete account');
      return false;
    }
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
        return 'Password is too weak (minimum 6 characters)';
      case 'invalid-email':
        return 'Invalid email address';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'network-request-failed':
        return 'Check your internet connection';
      case 'requires-recent-login':
        return 'Please log in again to continue';
      default:
        return 'Something went wrong. Please try again';
    }
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthUiState>(AuthController.new);