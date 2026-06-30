import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/firestore_service.dart';
import '../../domain/review_model.dart';
import '../../domain/service_provider_model.dart';
import '../../domain/service_quote_model.dart';
import '../../domain/service_request_model.dart';

final marketplaceServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final serviceProvidersStreamProvider = StreamProvider.autoDispose<
    List<ServiceProviderModel>>((ref) {
  return ref.watch(marketplaceServiceProvider).streamServiceProviders();
});

final providerDetailsProvider = FutureProvider.family<
    ServiceProviderModel, String>((ref, providerId) {
  return ref.watch(marketplaceServiceProvider).getServiceProvider(providerId);
});

final serviceRequestProvider = FutureProvider.family<
    ServiceRequestModel, String>((ref, requestId) {
  return ref.watch(marketplaceServiceProvider).getServiceRequest(requestId);
});

final serviceRequestsStreamProvider = StreamProvider.family<
    List<ServiceRequestModel>, String>((ref, userId) {
  return ref.watch(marketplaceServiceProvider).streamServiceRequestsForProvider(userId);
});

final serviceRequestsForCustomerStreamProvider = StreamProvider.family<
    List<ServiceRequestModel>, String>((ref, customerId) {
  return ref.watch(marketplaceServiceProvider).streamServiceRequestsForCustomer(customerId);
});

final serviceQuotesForRequestStreamProvider = StreamProvider.family<
    List<ServiceQuoteModel>, String>((ref, requestId) {
  return ref.watch(marketplaceServiceProvider).streamServiceQuotesForRequest(requestId);
});

final serviceQuotesForCustomerStreamProvider = StreamProvider.family<
    List<ServiceQuoteModel>, String>((ref, customerId) {
  return ref.watch(marketplaceServiceProvider).streamServiceQuotesForCustomer(customerId);
});

class MarketplaceController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  FirestoreService get _firestore => ref.read(marketplaceServiceProvider);

  Future<bool> createServiceRequest({
    required String customerId,
    required String customerCity,
    required String category,
    required String description,
    required String address,
    required double priceEstimate,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _firestore.createServiceRequest(
        customerId: customerId,
        customerCity: customerCity,
        category: category,
        description: description,
        address: address,
        priceEstimate: priceEstimate,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> assignServiceRequest({
    required String requestId,
    required String providerId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _firestore.assignServiceRequest(
        requestId: requestId,
        providerId: providerId,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> updateProviderAvailability({
    required String providerId,
    required bool available,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _firestore.updateProviderAvailability(
        providerId: providerId,
        available: available,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> setCommissionPercentage(double commissionPercentage) async {
    state = const AsyncValue.loading();
    try {
      await _firestore.setCommissionPercentage(commissionPercentage);
      state = const AsyncValue.data(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<double> getCommissionPercentage() async {
    return _firestore.getCommissionPercentage();
  }

  Future<bool> submitServiceQuote({
    required String requestId,
    required String providerId,
    required String customerId,
    required double amount,
    required String message,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _firestore.createServiceQuote(
        requestId: requestId,
        providerId: providerId,
        customerId: customerId,
        amount: amount,
        message: message,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> updateQuoteStatus({
    required String quoteId,
    required String status,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _firestore.updateQuoteStatus(quoteId: quoteId, status: status);
      state = const AsyncValue.data(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> updateServiceRequestStatus({
    required String requestId,
    required String status,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _firestore.updateServiceRequestStatus(
        requestId: requestId,
        status: status,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> createServiceBooking({
    required String requestId,
    required String quoteId,
    required String providerId,
    required String customerId,
    required DateTime scheduleAt,
    required double totalAmount,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _firestore.createServiceBooking(
        requestId: requestId,
        quoteId: quoteId,
        providerId: providerId,
        customerId: customerId,
        scheduleAt: scheduleAt,
        totalAmount: totalAmount,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> publishProviderProfile({
    required ServiceProviderModel profile,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _firestore.createServiceProviderProfile(profile);
      state = const AsyncValue.data(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<bool> leaveReview({
    required ReviewModel review,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _firestore.createReview(review);
      state = const AsyncValue.data(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }
}

final marketplaceControllerProvider =
    NotifierProvider<MarketplaceController, AsyncValue<void>>(MarketplaceController.new);
