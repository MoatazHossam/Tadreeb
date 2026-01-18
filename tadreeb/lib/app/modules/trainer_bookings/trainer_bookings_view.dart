import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/booking.dart';
import 'trainer_bookings_controller.dart';

class TrainerBookingsView extends GetView<TrainerBookingsController> {
  const TrainerBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainer Bookings'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Obx(
            () {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.isNotEmpty) {
                return _StatusMessage(
                  icon: Icons.error_outline,
                  message: controller.errorMessage.value,
                  actionLabel: 'Retry',
                  onAction: controller.fetchBookings,
                );
              }

              if (controller.bookings.isEmpty) {
                return const _EmptyState(
                  title: 'No bookings yet',
                  subtitle: 'Bookings created by trainees will appear here.',
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchBookings,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.bookings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final booking = controller.bookings[index];
                    final isApproving =
                        controller.approvingIds.contains(booking.id);
                    return _TrainerBookingCard(
                      booking: booking,
                      isApproving: isApproving,
                      onApprove: booking.isPending
                          ? () => controller.approveBooking(booking)
                          : null,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TrainerBookingCard extends StatelessWidget {
  const _TrainerBookingCard({
    required this.booking,
    required this.isApproving,
    required this.onApprove,
  });

  final Booking booking;
  final bool isApproving;
  final VoidCallback? onApprove;

  @override
  Widget build(BuildContext context) {
    final statusLabel =
        booking.statusDisplay.isNotEmpty ? booking.statusDisplay : booking.status;
    final statusColor = _resolveStatusColor(booking.status);
    final startDateLabel = _formatDate(booking.startDate);
    final referenceLabel = booking.bookingReference.isNotEmpty
        ? booking.bookingReference
        : 'Reference unavailable';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.traineeName.isNotEmpty
                          ? booking.traineeName
                          : 'Trainee',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      booking.packageName.isNotEmpty
                          ? booking.packageName
                          : 'Package',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              _StatusPill(label: statusLabel, color: statusColor),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Start date',
            value: startDateLabel,
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.payments_outlined,
            label: 'Final price',
            value: _formatPrice(booking.finalPrice),
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.confirmation_number_outlined,
            label: 'Reference',
            value: referenceLabel,
          ),
          if (onApprove != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isApproving ? null : onApprove,
                child: isApproving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Approve booking'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_month_outlined,
              size: 36,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

Color _resolveStatusColor(String status) {
  final normalized = status.toLowerCase();
  switch (normalized) {
    case 'completed':
    case 'done':
    case 'finished':
      return const Color(0xFF2E7D32);
    case 'cancelled':
    case 'canceled':
      return const Color(0xFFC62828);
    case 'active':
    case 'approved':
      return const Color(0xFF0277BD);
    case 'pending':
    default:
      return AppColors.primary;
  }
}

String _formatDate(DateTime? date) {
  if (date == null) return 'Not scheduled';
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  final month = months[date.month - 1];
  return '$month ${date.day}, ${date.year}';
}

String _formatPrice(String price) {
  final trimmed = price.trim();
  if (trimmed.isEmpty) return 'Price unavailable';

  final numericValue = double.tryParse(trimmed);
  if (numericValue != null) {
    final formatted = numericValue % 1 == 0
        ? numericValue.toStringAsFixed(0)
        : numericValue.toStringAsFixed(2);
    return 'AED $formatted';
  }

  return trimmed;
}
