import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  ReviewModel({
    required this.id,
    required this.providerId,
    required this.authorId,
    required this.authorName,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  final String id;
  final String providerId;
  final String authorId;
  final String authorName;
  final double rating;
  final String comment;
  final Timestamp? createdAt;

  factory ReviewModel.fromMap(Map<String, dynamic> data) {
    return ReviewModel(
      id: data['id'] as String? ?? '',
      providerId: data['providerId'] as String? ?? '',
      authorId: data['authorId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      comment: data['comment'] as String? ?? '',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'providerId': providerId,
      'authorId': authorId,
      'authorName': authorName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }
}
