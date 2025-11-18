import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/routes/app_pages.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/auth_text_field.dart';
import '../../core/widgets/primary_button.dart';
import 'register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final minHeight = constraints.maxHeight.isFinite
                ? (constraints.maxHeight - 48).clamp(0, double.infinity).toDouble()
                : 0.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: Get.back,
                          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                        ),
                        const Spacer(),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Start your driving journey with Tadreeb',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 26),
                    _buildFields(context),
                    const SizedBox(height: 26),
                    _buildAgreement(),
                    const SizedBox(height: 20),
                    Obx(
                      () => PrimaryButton(
                        label: 'Create Account',
                        onPressed: controller.register,
                        enabled: controller.canSubmit.value,
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        TextButton(
                          onPressed: () => Get.offAllNamed(Routes.login),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            foregroundColor: AppColors.primary,
                            textStyle: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          label: 'Full Name',
          hint: 'Enter your full name',
          controller: controller.fullNameController,
          textInputAction: TextInputAction.next,
          prefix: const Icon(Icons.person_outline, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 18),
        AuthTextField(
          label: 'Email',
          hint: 'Enter your email',
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          prefix: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 18),
        AuthTextField(
          label: 'Phone Number',
          hint: '+971 50 123 4567',
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          prefix: const Icon(Icons.phone_android_outlined, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 18),
        Obx(
          () => AuthTextField(
            label: 'Password',
            hint: 'Create a password',
            controller: controller.passwordController,
            obscureText: !controller.isPasswordVisible.value,
            textInputAction: TextInputAction.next,
            prefix: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
            suffix: IconButton(
              onPressed: controller.togglePasswordVisibility,
              icon: Icon(
                controller.isPasswordVisible.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Obx(
          () => AuthTextField(
            label: 'Confirm Password',
            hint: 'Confirm your password',
            controller: controller.confirmPasswordController,
            obscureText: !controller.isConfirmPasswordVisible.value,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => controller.register(),
            prefix: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
            suffix: IconButton(
              onPressed: controller.toggleConfirmPasswordVisibility,
              icon: Icon(
                controller.isConfirmPasswordVisible.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgreement() {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: controller.isAgreeToTerms.value,
            onChanged: controller.toggleTermsAgreement,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Get.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                children: const [
                  TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms and Conditions',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
