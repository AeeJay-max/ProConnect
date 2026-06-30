import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/service_quote_model.dart';
import '../providers/marketplace_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class CustomerRequestsScreen extends ConsumerStatefulWidget {
  const CustomerRequestsScreen({super.key});

  @override
  ConsumerState<CustomerRequestsScreen> createState() => _CustomerRequestsScreenState();

}

class _CustomerRequestsScreenState extends ConsumerState<CustomerRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(authStateProvider).valueOrNull;
    if (authUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My service requests')),
        body: const Center(child: Text('Please log in to see your requests.')),
      );
    }

    final requestsAsync = ref.watch(serviceRequestsForCustomerStreamProvider(authUser.uid));
    final quotesAsync = ref.watch(serviceQuotesForCustomerStreamProvider(authUser.uid));

    return Scaffold(
      appBar: AppBar(title: const Text('My service requests')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: ListView(
          children: [
            Text('Your requests', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            requestsAsync.when(
              data: (requests) {
                if (requests.isEmpty) {
                  return const Text('No requests have been made yet.');
                }
                return Column(
                  children: requests.map((request) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(request.category),
                        subtitle: Text(request.description),
                        trailing: Text(request.status),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => const Text('Failed to load requests.'),
            ),
            const SizedBox(height: 24),
            Text('Quotes received', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            quotesAsync.when(
              data: (quotes) {
                if (quotes.isEmpty) {
                  return const Text('No quotes available yet.');
                }
                return Column(
                  children: quotes.map((quote) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Provider: ${quote.providerId}'),
                            const SizedBox(height: 6),
                            Text('Offer: \$${quote.amount.toStringAsFixed(2)}'),
                            const SizedBox(height: 6),
                            Text(quote.message),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Status: ${quote.status}'),
                                if (quote.status == 'pending')
                                  TextButton(
                                    onPressed: () => _acceptQuote(context, ref, authUser.uid, quote),
                                    child: const Text('Accept quote'),
                                  )
                                else
                                  const SizedBox.shrink(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => const Text('Failed to load quotes.'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _acceptQuote(
    BuildContext context,
    WidgetRef ref,
    String customerId,
    ServiceQuoteModel quote,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (time == null || !context.mounted) return;

    final scheduleAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    final messenger = ScaffoldMessenger.of(context);
    final bookingCreated = await ref.read(marketplaceControllerProvider.notifier).createServiceBooking(
          requestId: quote.requestId,
          quoteId: quote.id,
          providerId: quote.providerId,
          customerId: customerId,
          scheduleAt: scheduleAt,
          totalAmount: quote.amount,
        );

    if (!context.mounted) {
      return;
    }

    if (bookingCreated) {
      await ref.read(marketplaceControllerProvider.notifier).updateQuoteStatus(
            quoteId: quote.id,
            status: 'accepted',
          );
      await ref.read(marketplaceControllerProvider.notifier).updateServiceRequestStatus(
            requestId: quote.requestId,
            status: 'booked',
          );
      messenger.showSnackBar(
        const SnackBar(content: Text('Booking confirmed successfully.')),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text('Failed to confirm booking.')),
      );
    }
  }
}
