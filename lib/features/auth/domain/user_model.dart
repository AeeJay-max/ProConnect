import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants.dart';

enum UserRole {
  customer,
  driver,
  serviceProvider,
  serviceAdmin,
  platformAdmin,
}

enum ProviderStatus {
  none,
  pending,
  verified,
  rejected,
  suspended,
}

class UserModel {
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.photoUrl,
    required this.role,
    required this.providerStatus,
    this.createdAt,
  });

  final String uid;
  final String name;
  final String email;
  final String phone;
  final String city;
  final String photoUrl;
  final UserRole role;
  final ProviderStatus providerStatus;
  final Timestamp? createdAt;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      city: map['city'] as String? ?? AppConstants.defaultCity,
      photoUrl: map['photoUrl'] as String? ?? '',
      role: _roleFromString(map['role'] as String? ?? 'customer'),
      providerStatus: _providerStatusFromString(
        map['providerStatus'] as String? ?? 'none',
      ),
      createdAt: map['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
      'photoUrl': photoUrl,
      'role': role.name,
      'providerStatus': providerStatus.name,
      'createdAt': createdAt,
    };
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
    if (parts.isEmpty) {
      return 'ID';
    }

    return parts
        .take(2)
        .map((part) => part.substring(0, 1).toUpperCase())
        .join();
  }

  bool get isServiceProvider => role == UserRole.serviceProvider;
  bool get isVerifiedProvider => providerStatus == ProviderStatus.verified;

  static UserRole _roleFromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => UserRole.customer,
    );
  }

  static ProviderStatus _providerStatusFromString(String value) {
    return ProviderStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => ProviderStatus.none,
    );
  }
}
