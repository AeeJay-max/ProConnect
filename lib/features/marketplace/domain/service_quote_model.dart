import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceQuoteModel {
  ServiceQuoteModel({
    required this.id,
    required this.requestId,
    required this.providerId,
    required this.customerId,
    required this.amount,
    required this.message,
    required this.status,
    this.createdAt,
  });

  final String id;
  final String requestId;
  final String providerId;
  final String customerId;
  final double amount;
  final String message;
  final String status;
  final Timestamp? createdAt;

  factory ServiceQuoteModel.fromMap(Map<String, dynamic> data) {
    return ServiceQuoteModel(
      id: data['id'] as String? ?? '',
      requestId: data['requestId'] as String? ?? '',
      providerId: data['providerId'] as String? ?? '',
      customerId: data['customerId'] as String? ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      message: data['message'] as String? ?? '',
      status: data['status'] as String? ?? 'pending',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requestId': requestId,
      'providerId': providerId,
      'customerId': customerId,
      'amount': amount,
      'message': message,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
