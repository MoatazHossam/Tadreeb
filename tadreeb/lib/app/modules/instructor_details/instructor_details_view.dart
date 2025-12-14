import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/instructor.dart';
import '../../core/theme/app_theme.dart';
import 'instructor_details_controller.dart';

class InstructorDetailsView extends GetView<InstructorDetailsController> {
  const InstructorDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: Obx(
        () {
          final instructor = controller.instructor.value;
          if (instructor == null) return const SizedBox.shrink();
          return _BottomBar(priceLabel: controller.bestPriceLabel);
        },
      ),
      body: SafeArea(
        child: Obx(
          () {
            if (controller.isLoading.value && controller.instructor.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.isNotEmpty && controller.instructor.value == null) {
              return _StatusMessage(
                icon: Icons.error_outline,
                message: controller.errorMessage.value,
                actionLabel: 'Retry',
                onAction: controller.retry,
              );
            }

            final instructor = controller.instructor.value;
            if (instructor == null) {
              return const _StatusMessage(
                icon: Icons.error_outline,
                message: 'Unable to load instructor details.',
              );
            }

            return Stack(
              children: [
                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE8EAEE), Color(0xFFD9DDE5)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                RefreshIndicator(
                  onRefresh: controller.retry,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            _HeaderIconButton(icon: Icons.arrow_back_ios_new, onPressed: Get.back),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _OverviewCard(instructor: instructor),
                        const SizedBox(height: 18),
                        _SectionTitle('About'),
                        _AboutCard(instructor: instructor),
                        const SizedBox(height: 16),
                        _SectionTitle('Specializations'),
                        const SizedBox(height: 8),
                        if (instructor.specializations.isEmpty)
                          const Text(
                            'Specializations not provided',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        else
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: instructor.specializations
                                .map((spec) => Chip(
                                      label: Text(
                                        spec,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(color: Color(0xFFE4E7ED)),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ))
                                .toList(),
                          ),
                        const SizedBox(height: 16),
                        _SectionTitle('Availability'),
                        const SizedBox(height: 10),
                        if (instructor.availability.isEmpty)
                          const Text(
                            'Availability not specified',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        else
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: instructor.availability
                                .map(
                                  (day) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFFE4E7ED)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.03),
                                          blurRadius: 8,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      day,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        const SizedBox(height: 16),
                        _SectionTitle('Choose Package'),
                        const SizedBox(height: 12),
                        if (instructor.packages.isEmpty)
                          const Text(
                            'Packages will be available soon.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        else
                          ...instructor.packages
                              .map(
                                (package) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _PackageCard(package: package),
                                ),
                              )
                              .toList(),
                        const SizedBox(height: 90),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.instructor});

  final Instructor instructor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 88,
            width: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: instructor.avatarColor != null
                  ? LinearGradient(colors: [instructor.avatarColor!, AppColors.primary])
                  : const LinearGradient(colors: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)]),
              image: instructor.profilePicture != null
                  ? DecorationImage(
                      image: NetworkImage(instructor.profilePicture!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: instructor.profilePicture == null
                ? Center(
                    child: Text(
                      instructor.name.substring(0, 1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 14),
          Text(
            instructor.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, size: 18, color: Color(0xFFFFB300)),
              const SizedBox(width: 6),
              Text(
                '${instructor.rating.toStringAsFixed(1)} (${instructor.ratingCount ?? 0})',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_outlined, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  instructor.city,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.instructor});

  final Instructor instructor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            instructor.about,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 10,
            children: [
              _IconRow(
                icon: Icons.workspace_premium,
                label: '${instructor.experienceYears} years experience',
              ),
              _IconRow(
                icon: Icons.language,
                label: instructor.languages.isEmpty
                    ? 'Language preferences not specified'
                    : instructor.languages.join(', '),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package});

  final InstructorPackage package;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          package.subtitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (package.discountPercent != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF2D8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFDEB8)),
                      ),
                      child: Text(
                        '${package.discountPercent}% OFF',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: package.perks
                    .map(
                      (perk) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F8FB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              perk,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AED ${package.discountedPrice.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                      ),
                      Text(
                        'AED ${package.originalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Book Now'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconRow extends StatelessWidget {
  const _IconRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        onPressed: onPressed,
        padding: const EdgeInsets.all(10),
        icon: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.priceLabel});

  final String priceLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  priceLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                ),
                const Text(
                  'Limited time offer',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Book Now'),
              ),
            ),
          ],
        ),
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
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
