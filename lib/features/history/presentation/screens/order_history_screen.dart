import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/widgets/app_button.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                height: 140,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _BuildingBlock(height: 56, width: 36),
                        const SizedBox(width: 8),
                        _BuildingBlock(height: 72, width: 42),
                        const SizedBox(width: 8),
                        _BuildingBlock(height: 48, width: 32),
                      ],
                    ),
                    Positioned(
                      bottom: 8,
                      child: Icon(
                        Icons.directions_car_filled_outlined,
                        size: 64,
                        color: AppColors.primary.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Your completed orders will appear here',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                'Order on your terms — get started now',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              AppButton(
                text: 'Get Started',
                onPressed: () => context.go('/ride'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildingBlock extends StatelessWidget {
  const _BuildingBlock({required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.info,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}