import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceBookingModel {
  ServiceBookingModel({
    required this.id,
    required this.requestId,
    required this.quoteId,
    required this.providerId,
    required this.customerId,
    required this.status,
    required this.scheduleAt,
    required this.totalAmount,
    required this.escrowStatus,
    required this.platformFee,
    required this.providerPayout,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String requestId;
  final String quoteId;
  final String providerId;
  final String customerId;
  final String status;
  final Timestamp scheduleAt;
  final double totalAmount;
  final String escrowStatus;
  final double platformFee;
  final double providerPayout;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  factory ServiceBookingModel.fromMap(Map<String, dynamic> data) {
    return ServiceBookingModel(
      id: data['id'] as String? ?? '',
      requestId: data['requestId'] as String? ?? '',
      quoteId: data['quoteId'] as String? ?? '',
      providerId: data['providerId'] as String? ?? '',
      customerId: data['customerId'] as String? ?? '',
      status: data['status'] as String? ?? 'pending',
      scheduleAt: data['scheduleAt'] as Timestamp? ?? Timestamp.now(),
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      escrowStatus: data['escrowStatus'] as String? ?? 'held',
      platformFee: (data['platformFee'] as num?)?.toDouble() ?? 0.0,
      providerPayout: (data['providerPayout'] as num?)?.toDouble() ?? 0.0,
      createdAt: data['createdAt'] as Timestamp?,
      updatedAt: data['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requestId': requestId,
      'quoteId': quoteId,
      'providerId': providerId,
      'customerId': customerId,
      'status': status,
      'scheduleAt': scheduleAt,
      'totalAmount': totalAmount,
      'escrowStatus': escrowStatus,
      'platformFee': platformFee,
      'providerPayout': providerPayout,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
