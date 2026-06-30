import 'package:cloud_firestore/cloud_firestore.dart';

import '../features/auth/domain/user_model.dart';
import '../models/order_model.dart';
import '../features/marketplace/domain/review_model.dart';
import '../features/marketplace/domain/service_booking_model.dart';
import '../features/marketplace/domain/service_provider_model.dart';
import '../features/marketplace/domain/service_quote_model.dart';
import '../features/marketplace/domain/service_request_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users => _db.collection('users');
  CollectionReference<Map<String, dynamic>> get _orders => _db.collection('orders');
  CollectionReference<Map<String, dynamic>> get _serviceProviders =>
      _db.collection('service_providers');
  CollectionReference<Map<String, dynamic>> get _serviceRequests =>
      _db.collection('service_requests');
  CollectionReference<Map<String, dynamic>> get _serviceBookings =>
      _db.collection('service_bookings');
  CollectionReference<Map<String, dynamic>> get _serviceQuotes =>
      _db.collection('service_quotes');
  CollectionReference<Map<String, dynamic>> get _reviews =>
      _db.collection('reviews');
  CollectionReference<Map<String, dynamic>> get _notifications =>
      _db.collection('notifications');
  CollectionReference<Map<String, dynamic>> get _disputes =>
      _db.collection('disputes');
  CollectionReference<Map<String, dynamic>> get _platformSettings =>
      _db.collection('platform_settings');

  Stream<List<OrderModel>> streamUserOrders(String uid) {
    return _orders.where('uid', isEqualTo: uid).snapshots().map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data()))
          .where((order) => order.status != 'completed')
          .toList();
      orders.sort(_sortOrders);
      return orders;
    });
  }

  Stream<List<OrderModel>> streamCompletedOrders(String uid) {
    return _orders.where('uid', isEqualTo: uid).snapshots().map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data()))
          .where((order) => order.status == 'completed')
          .toList();
      orders.sort(_sortOrders);
      return orders;
    });
  }

  Stream<List<OrderModel>> streamIntercityOrders() {
    return _orders.where('type', isEqualTo: 'intercity').snapshots().map((
      snapshot,
    ) {
      final orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data()))
          .where((order) => order.status == 'active')
          .toList();
      orders.sort(_sortOrders);
      return orders;
    });
  }

  Stream<List<ServiceProviderModel>> streamServiceProviders() {
    return _serviceProviders.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ServiceProviderModel.fromMap(doc.data()))
          .toList();
    });
  }

  Future<ServiceProviderModel> getServiceProvider(String providerId) async {
    final doc = await _serviceProviders.doc(providerId).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Provider not found');
    }
    return ServiceProviderModel.fromMap(doc.data()!);
  }

  Future<void> createServiceProviderProfile(ServiceProviderModel profile) async {
    await _serviceProviders.doc(profile.id).set(profile.toMap());
    await _users.doc(profile.userId).set({
      'role': 'serviceProvider',
      'providerStatus': 'pending',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<List<ServiceRequestModel>> streamServiceRequestsForProvider(
      String providerId) {
    return _serviceRequests
        .where('providerId', isEqualTo: providerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ServiceRequestModel.fromMap(doc.data()))
          .toList();
    });
  }

  Stream<List<ServiceRequestModel>> streamServiceRequestsForUser(
      String userId) {
    return _serviceRequests
        .where('providerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ServiceRequestModel.fromMap(doc.data()))
          .toList();
    });
  }

  Stream<List<ServiceRequestModel>> streamServiceRequestsForCustomer(
      String customerId) {
    return _serviceRequests
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ServiceRequestModel.fromMap(doc.data()))
          .toList();
    });
  }

  Stream<List<ServiceQuoteModel>> streamServiceQuotesForProvider(
      String providerId) {
    return _serviceQuotes
        .where('providerId', isEqualTo: providerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ServiceQuoteModel.fromMap(doc.data()))
          .toList();
    });
  }

  Stream<List<ServiceQuoteModel>> streamServiceQuotesForCustomer(
      String customerId) {
    return _serviceQuotes
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ServiceQuoteModel.fromMap(doc.data()))
          .toList();
    });
  }

  Stream<List<ServiceQuoteModel>> streamServiceQuotesForRequest(
      String requestId) {
    return _serviceQuotes
        .where('requestId', isEqualTo: requestId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ServiceQuoteModel.fromMap(doc.data()))
          .toList();
    });
  }

  Stream<List<ServiceBookingModel>> streamServiceBookingsForCustomer(
      String customerId) {
    return _serviceBookings
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ServiceBookingModel.fromMap(doc.data()))
          .toList();
    });
  }

  Stream<List<ServiceBookingModel>> streamServiceBookingsForProvider(
      String providerId) {
    return _serviceBookings
        .where('providerId', isEqualTo: providerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ServiceBookingModel.fromMap(doc.data()))
          .toList();
    });
  }

  Stream<List<ReviewModel>> streamReviewsForProvider(String providerId) {
    return _reviews
        .where('providerId', isEqualTo: providerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ReviewModel.fromMap(doc.data()))
          .toList();
    });
  }

  Stream<List<Map<String, dynamic>>> streamNotificationsForUser(
      String userId) {
    return _notifications
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<UserModel>> streamPendingProviders() {
    return _users
        .where('role', isEqualTo: 'serviceProvider')
        .where('providerStatus', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> createOrder(OrderModel order) async {
    await _orders.doc(order.id).set(order.toMap());
  }

  Future<void> updateQuoteStatus({
    required String quoteId,
    required String status,
  }) async {
    await _serviceQuotes.doc(quoteId).update({'status': status});
  }

  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
    String? escrowStatus,
  }) async {
    final data = {
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (escrowStatus != null) {
      data['escrowStatus'] = escrowStatus;
    }
    await _serviceBookings.doc(bookingId).update(data);
  }

  Future<void> updateProviderRating({
    required String providerId,
    required double rating,
    required int reviewCount,
  }) async {
    await _serviceProviders.doc(providerId).update({
      'rating': rating,
      'reviewCount': reviewCount,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateProviderStatus({
    required String uid,
    required String status,
  }) async {
    await _users.doc(uid).update({
      'providerStatus': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> assignServiceRequest({
    required String requestId,
    required String providerId,
  }) async {
    await _serviceRequests.doc(requestId).update({
      'providerId': providerId,
      'status': 'assigned',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateProviderAvailability({
    required String providerId,
    required bool available,
  }) async {
    await _serviceProviders.doc(providerId).update({
      'available': available,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<double> getCommissionPercentage() async {
    final doc = await _platformSettings.doc('fees').get();
    if (!doc.exists || doc.data() == null) {
      return 0.1;
    }
    return (doc.data()!['commissionPercentage'] as num?)?.toDouble() ?? 0.1;
  }

  Future<void> setCommissionPercentage(double commissionPercentage) async {
    await _platformSettings.doc('fees').set({
      'commissionPercentage': commissionPercentage,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> createSOSAlert({
    required String userId,
    required String message,
  }) async {
    final ref = _notifications.doc();
    await ref.set({
      'id': ref.id,
      'userId': userId,
      'title': 'SOS Alert',
      'body': message,
      'createdAt': FieldValue.serverTimestamp(),
      'read': false,
      'type': 'sos',
    });
  }

  Future<void> createServiceRequest({
    required String customerId,
    String providerId = '',
    required String customerCity,
    required String category,
    required String description,
    required String address,
    required double priceEstimate,
  }) async {
    final ref = _serviceRequests.doc();
    final request = ServiceRequestModel(
      id: ref.id,
      customerId: customerId,
      providerId: providerId,
      customerCity: customerCity,
      category: category,
      description: description,
      images: [],
      status: 'pending',
      location: {'city': customerCity},
      address: address,
      priceEstimate: priceEstimate,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );
    await ref.set(request.toMap());
  }

  Future<ServiceRequestModel> getServiceRequest(String requestId) async {
    final doc = await _serviceRequests.doc(requestId).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Request not found');
    }
    return ServiceRequestModel.fromMap(doc.data()!);
  }

  Future<void> updateServiceRequestStatus({
    required String requestId,
    required String status,
  }) async {
    await _serviceRequests.doc(requestId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createServiceQuote({
    required String requestId,
    required String providerId,
    required String customerId,
    required double amount,
    required String message,
  }) async {
    final ref = _serviceQuotes.doc();
    final quote = ServiceQuoteModel(
      id: ref.id,
      requestId: requestId,
      providerId: providerId,
      customerId: customerId,
      amount: amount,
      message: message,
      status: 'pending',
      createdAt: Timestamp.now(),
    );
    await ref.set(quote.toMap());
  }

  Future<void> createServiceBooking({
    required String requestId,
    required String quoteId,
    required String providerId,
    required String customerId,
    required DateTime scheduleAt,
    required double totalAmount,
  }) async {
    final commission = await getCommissionPercentage();
    final ref = _serviceBookings.doc();
    final platformFee = double.parse((totalAmount * commission).toStringAsFixed(2));
    final providerPayout = double.parse((totalAmount - platformFee).toStringAsFixed(2));
    final booking = ServiceBookingModel(
      id: ref.id,
      requestId: requestId,
      quoteId: quoteId,
      providerId: providerId,
      customerId: customerId,
      status: 'pending',
      scheduleAt: Timestamp.fromDate(scheduleAt),
      totalAmount: totalAmount,
      escrowStatus: 'held',
      platformFee: platformFee,
      providerPayout: providerPayout,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );
    await ref.set(booking.toMap());
  }

  Future<void> createReview(ReviewModel review) async {
    final ref = _reviews.doc();
    final data = review.toMap();
    data['id'] = ref.id;
    await ref.set(data);
  }

  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    final ref = _notifications.doc();
    await ref.set({
      'id': ref.id,
      'userId': userId,
      'title': title,
      'body': body,
      'createdAt': FieldValue.serverTimestamp(),
      'read': false,
    });
  }

  Future<void> createDispute({
    required String bookingId,
    required String userId,
    required String reason,
  }) async {
    final ref = _disputes.doc();
    await ref.set({
      'id': ref.id,
      'bookingId': bookingId,
      'userId': userId,
      'reason': reason,
      'status': 'open',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    await _orders.doc(orderId).update({'status': status});
  }

  Future<void> updateUserProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String city,
    String? photoUrl,
    String? surname,
    String? role,
    String? providerStatus,
  }) async {
    final data = {
      'uid': uid,
      'name': name,
      'surname': surname ?? '',
      'email': email,
      'phone': phone,
      'city': city,
      'photoUrl': photoUrl ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (role != null) {
      data['role'] = role;
    }
    if (providerStatus != null) {
      data['providerStatus'] = providerStatus;
    }
    await _users.doc(uid).set(data, SetOptions(merge: true));
  }

  Future<void> saveAddress({
    required String uid,
    required String label,
    required String address,
  }) async {
    await _users.doc(uid).collection('addresses').doc(label).set({
      'label': label,
      'address': address,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<List<Map<String, dynamic>>> streamAddresses(String uid) {
    return _users
        .doc(uid)
        .collection('addresses')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> deleteUserData(String uid) async {
    final addresses = await _users.doc(uid).collection('addresses').get();
    for (final doc in addresses.docs) {
      await doc.reference.delete();
    }

    final orders = await _orders.where('uid', isEqualTo: uid).get();
    for (final doc in orders.docs) {
      await doc.reference.delete();
    }

    final providers = await _serviceProviders.where('userId', isEqualTo: uid).get();
    for (final doc in providers.docs) {
      await doc.reference.delete();
    }

    final requests = await _serviceRequests.where('customerId', isEqualTo: uid).get();
    for (final doc in requests.docs) {
      await doc.reference.delete();
    }

    final quotes = await _serviceQuotes.where('customerId', isEqualTo: uid).get();
    for (final doc in quotes.docs) {
      await doc.reference.delete();
    }

    final bookings = await _serviceBookings.where('customerId', isEqualTo: uid).get();
    for (final doc in bookings.docs) {
      await doc.reference.delete();
    }

    await _users.doc(uid).delete();
  }

  int _sortOrders(OrderModel a, OrderModel b) {
    final aMillis = a.createdAt?.millisecondsSinceEpoch ?? 0;
    final bMillis = b.createdAt?.millisecondsSinceEpoch ?? 0;
    return bMillis.compareTo(aMillis);
  }
}
