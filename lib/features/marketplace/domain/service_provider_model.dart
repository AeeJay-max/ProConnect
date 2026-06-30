import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProviderModel {
  ServiceProviderModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.photoUrl,
    required this.category,
    required this.bio,
    required this.skills,
    required this.certifications,
    required this.experienceYears,
    required this.hourlyRate,
    required this.rating,
    required this.reviewCount,
    required this.available,
    required this.city,
    required this.address,
    required this.serviceRadiusKm,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String name;
  final String photoUrl;
  final String category;
  final String bio;
  final List<String> skills;
  final List<String> certifications;
  final int experienceYears;
  final double hourlyRate;
  final double rating;
  final int reviewCount;
  final bool available;
  final String city;
  final String address;
  final int serviceRadiusKm;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  factory ServiceProviderModel.fromMap(Map<String, dynamic> data) {
    return ServiceProviderModel(
      id: data['id'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      photoUrl: data['photoUrl'] as String? ?? '',
      category: data['category'] as String? ?? '',
      bio: data['bio'] as String? ?? '',
      skills: List<String>.from(data['skills'] as List<dynamic>? ?? []),
      certifications: List<String>.from(data['certifications'] as List<dynamic>? ?? []),
      experienceYears: data['experienceYears'] as int? ?? 0,
      hourlyRate: (data['hourlyRate'] as num?)?.toDouble() ?? 0.0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: data['reviewCount'] as int? ?? 0,
      available: data['available'] as bool? ?? false,
      city: data['city'] as String? ?? '',
      address: data['address'] as String? ?? '',
      serviceRadiusKm: data['serviceRadiusKm'] as int? ?? 10,
      createdAt: data['createdAt'] as Timestamp?,
      updatedAt: data['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'photoUrl': photoUrl,
      'category': category,
      'bio': bio,
      'skills': skills,
      'certifications': certifications,
      'experienceYears': experienceYears,
      'hourlyRate': hourlyRate,
      'rating': rating,
      'reviewCount': reviewCount,
      'available': available,
      'city': city,
      'address': address,
      'serviceRadiusKm': serviceRadiusKm,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
