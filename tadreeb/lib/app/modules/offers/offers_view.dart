import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
import '../../data/models/offer_package.dart';
import 'offers_controller.dart';

class OffersView extends GetView<OffersController> {
  const OffersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(onFilterTap: () => _openFilters(context)),
              const SizedBox(height: 18),
              Expanded(
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
                        onAction: controller.fetchPackages,
                      );
                    }

                    if (controller.packages.isEmpty) {
                      return const _StatusMessage(
                        icon: Icons.local_offer_outlined,
                        message: 'No offers available right now.',
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: controller.fetchPackages,
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.packages.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final offer = controller.packages[index];
                          return _OfferCard(package: offer);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }

  Future<void> _openFilters(BuildContext context) async {
    final hasPerkController = TextEditingController(
      text: controller.hasPerk?.toString() ?? '',
    );
    final limitController = TextEditingController(
      text: controller.limit?.toString() ?? '',
    );
    final maxLessonsController = TextEditingController(
      text: controller.maxLessons?.toString() ?? '',
    );
    final minLessonsController = TextEditingController(
      text: controller.minLessons?.toString() ?? '',
    );
    final maxPriceController = TextEditingController(
      text: controller.maxPrice?.toString() ?? '',
    );
    final minPriceController = TextEditingController(
      text: controller.minPrice?.toString() ?? '',
    );
    final offsetController = TextEditingController(
      text: controller.offset?.toString() ?? '',
    );

    bool? selectedFeatured = controller.isFeatured;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Filter offers',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _FilterField(
                      controller: hasPerkController,
                      label: 'Perk ID',
                      hintText: 'has_perk',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<bool?>(
                      value: selectedFeatured,
                      decoration: const InputDecoration(
                        labelText: 'Featured packages',
                      ),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Any')),
                        DropdownMenuItem(value: true, child: Text('Featured')),
                        DropdownMenuItem(value: false, child: Text('Not featured')),
                      ],
                      onChanged: (value) => setState(() => selectedFeatured = value),
                    ),
                    const SizedBox(height: 12),
                    _FilterField(
                      controller: limitController,
                      label: 'Limit',
                      hintText: 'limit',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    _FilterField(
                      controller: maxLessonsController,
                      label: 'Max lessons',
                      hintText: 'max_lessons',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    _FilterField(
                      controller: minLessonsController,
                      label: 'Min lessons',
                      hintText: 'min_lessons',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    _FilterField(
                      controller: maxPriceController,
                      label: 'Max price (AED)',
                      hintText: 'max_price',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 12),
                    _FilterField(
                      controller: minPriceController,
                      label: 'Min price (AED)',
                      hintText: 'min_price',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 12),
                    _FilterField(
                      controller: offsetController,
                      label: 'Offset',
                      hintText: 'offset',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        controller.applyFilters(
                          hasPerk: _parseInt(hasPerkController.text),
                          limit: _parseInt(limitController.text),
                          maxLessons: _parseInt(maxLessonsController.text),
                          minLessons: _parseInt(minLessonsController.text),
                          maxPrice: _parseDouble(maxPriceController.text),
                          minPrice: _parseDouble(minPriceController.text),
                          offset: _parseInt(offsetController.text),
                          isFeatured: selectedFeatured,
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text('Apply filters'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    hasPerkController.dispose();
    limitController.dispose();
    maxLessonsController.dispose();
    minLessonsController.dispose();
    maxPriceController.dispose();
    minPriceController.dispose();
    offsetController.dispose();
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onFilterTap});

  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: IconButton(
            onPressed: onFilterTap,
            padding: const EdgeInsets.all(10),
            icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
          ),
        ),
        Text(
          'Offers',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            padding: const EdgeInsets.all(10),
            icon: const Icon(Icons.notifications_none, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.package});

  final OfferPackage package;

  @override
  Widget build(BuildContext context) {
    final currency = (package.currency ?? 'AED').trim().isEmpty
        ? 'AED'
        : package.currency!.trim();
    final finalPrice = package.effectiveFinalPrice;
    final basePrice = package.effectiveBasePrice;
    final showBasePrice = basePrice != null &&
        finalPrice != null &&
        basePrice.toStringAsFixed(2) != finalPrice.toStringAsFixed(2);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    colors: [Color(0xFF616161), Color(0xFFBDBDBD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              if (package.discountPercentRounded != null)
                Positioned(
                  right: 16,
                  top: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${package.discountPercentRounded}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              Positioned(
                left: 16,
                bottom: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.trainerName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 6),
                    _TrainerMeta(
                      rating: package.trainerRating,
                      location: package.trainerLocation,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  package.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _MetaIcon(
                      icon: Icons.calendar_today_outlined,
                      label: package.numberOfLessons != null
                          ? '${package.numberOfLessons} lessons'
                          : 'Lesson count varies',
                    ),
                    const SizedBox(width: 16),
                    _MetaIcon(
                      icon: Icons.access_time,
                      label: package.hoursPerLesson != null
                          ? '${package.hoursPerLesson}h/lesson'
                          : 'Flexible hours',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          finalPrice != null
                              ? '$currency ${finalPrice.toStringAsFixed(0)}'
                              : 'Pricing on request',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                        ),
                        if (showBasePrice)
                          Text(
                            '$currency ${basePrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Book Now'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainerMeta extends StatelessWidget {
  const _TrainerMeta({required this.rating, required this.location});

  final double? rating;
  final String? location;

  @override
  Widget build(BuildContext context) {
    if (rating == null && (location == null || location!.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        if (rating != null) ...[
          const Icon(Icons.star, color: AppColors.primary, size: 18),
          const SizedBox(width: 6),
          Text(
            rating!.toStringAsFixed(1),
            style: const TextStyle(color: Colors.white),
          ),
        ],
        if (rating != null && location != null && location!.isNotEmpty)
          const SizedBox(width: 12),
        if (location != null && location!.isNotEmpty) ...[
          const Icon(Icons.location_on, color: Colors.white70, size: 18),
          const SizedBox(width: 4),
          Text(
            location!,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ],
    );
  }
}

class _MetaIcon extends StatelessWidget {
  const _MetaIcon({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _FilterField extends StatelessWidget {
  const _FilterField({
    required this.controller,
    required this.label,
    required this.hintText,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

int? _parseInt(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return int.tryParse(trimmed);
}

double? _parseDouble(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return double.tryParse(trimmed);
}
