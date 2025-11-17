import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && !isLoading;

    final gradient = isEnabled
        ? AppColors.primaryGradient
        : const LinearGradient(
            colors: [Color(0xFFDADDE2), Color(0xFFDADDE2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    final textColor = isEnabled ? Colors.white : AppColors.textSecondary;

    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                )
            : Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: textColor, fontWeight: FontWeight.w600),
              ),
        ),
      ),
    );
  }
}
