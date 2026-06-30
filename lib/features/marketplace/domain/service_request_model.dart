import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRequestModel {
  ServiceRequestModel({
    required this.id,
    required this.customerId,
    required this.providerId,
    required this.customerCity,
    required this.category,
    required this.description,
    required this.images,
    required this.status,
    required this.location,
    required this.address,
    required this.priceEstimate,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String customerId;
  final String providerId;
  final String customerCity;
  final String category;
  final String description;
  final List<String> images;
  final String status;
  final Map<String, dynamic> location;
  final String address;
  final double priceEstimate;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  factory ServiceRequestModel.fromMap(Map<String, dynamic> data) {
    return ServiceRequestModel(
      id: data['id'] as String? ?? '',
      customerId: data['customerId'] as String? ?? '',
      providerId: data['providerId'] as String? ?? '',
      category: data['category'] as String? ?? '',
      customerCity: data['customerCity'] as String? ?? '',
      description: data['description'] as String? ?? '',
      images: List<String>.from(data['images'] as List<dynamic>? ?? []),
      status: data['status'] as String? ?? 'pending',
      location: Map<String, dynamic>.from(data['location'] as Map<String, dynamic>? ?? {}),
      address: data['address'] as String? ?? '',
      priceEstimate: (data['priceEstimate'] as num?)?.toDouble() ?? 0.0,
      createdAt: data['createdAt'] as Timestamp?,
      updatedAt: data['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'providerId': providerId,
      'customerCity': customerCity,
      'category': category,
      'description': description,
      'images': images,
      'status': status,
      'location': location,
      'address': address,
      'priceEstimate': priceEstimate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
