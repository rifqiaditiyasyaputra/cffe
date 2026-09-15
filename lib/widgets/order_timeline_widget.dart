import 'package:flutter/material.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';

class OrderTimelineWidget extends StatelessWidget {
  final OrderStatusStep currentStatus;

  const OrderTimelineWidget({
    Key? key,
    required this.currentStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final steps = OrderStatusStep.values;
    final currentIndex = currentStatus.index;

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isPassed = index < currentIndex;
        final isCurrent = index == currentIndex;
        final isLast = index == steps.length - 1;

        Color stepColor;
        if (isPassed) {
          stepColor = AppTheme.accentGreen;
        } else if (isCurrent) {
          stepColor = AppTheme.primaryCoffee;
        } else {
          stepColor = Colors.grey.shade300;
        }

        IconData stepIcon;
        switch (step) {
          case OrderStatusStep.diterima:
            stepIcon = Icons.receipt_long;
            break;
          case OrderStatusStep.diproses:
            stepIcon = Icons.coffee_maker;
            break;
          case OrderStatusStep.disiapkan:
            stepIcon = Icons.takeout_dining;
            break;
          case OrderStatusStep.siap:
            stepIcon = Icons.notifications_active;
            break;
          case OrderStatusStep.selesai:
            stepIcon = Icons.check_circle;
            break;
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline Column (Circle + Connector Line)
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isCurrent ? 36 : 28,
                    height: isCurrent ? 36 : 28,
                    decoration: BoxDecoration(
                      color: isPassed
                          ? AppTheme.accentGreen
                          : (isCurrent ? AppTheme.primaryCoffee : Colors.white),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: stepColor,
                        width: 2.5,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: AppTheme.primaryCoffee.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
                    ),
                    child: Center(
                      child: isPassed
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : Icon(
                              stepIcon,
                              size: isCurrent ? 18 : 14,
                              color: isCurrent ? Colors.white : Colors.grey.shade500,
                            ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2.5,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: isPassed ? AppTheme.accentGreen : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Content Text
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            step.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isCurrent || isPassed ? FontWeight.bold : FontWeight.w500,
                              color: isCurrent
                                  ? AppTheme.primaryCoffee
                                  : (isPassed ? AppTheme.textDark : AppTheme.textMuted),
                            ),
                          ),
                          if (isCurrent) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryCoffee.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Proses Aktif',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryCoffee,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        step.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isCurrent ? AppTheme.textDark : AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
