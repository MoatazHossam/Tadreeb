import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/auth_text_field.dart';
import '../../core/widgets/primary_button.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
                    const SizedBox(height: 12),
                    const _LogoHeader(),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AuthTextField(
                            label: 'Email',
                            hint: 'Enter your email',
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            prefix: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 18),
                          Obx(
                            () => AuthTextField(
                              label: 'Password',
                              hint: 'Enter your password',
                              controller: controller.passwordController,
                              obscureText: !controller.isPasswordVisible.value,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => controller.login(),
                              prefix: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                              suffix: IconButton(
                                onPressed: controller.togglePassword,
                                icon: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                foregroundColor: AppColors.primary,
                                textStyle: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              child: const Text('Forgot Password?'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: controller.errorMessage.value.isEmpty
                                  ? const SizedBox.shrink()
                                  : Container(
                                      key: ValueKey(controller.errorMessage.value),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        controller.errorMessage.value,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Obx(
                            () => PrimaryButton(
                              label: 'Login',
                              isLoading: controller.isLoading.value,
                              onPressed: controller.login,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  foregroundColor: AppColors.primary,
                                  textStyle: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                                child: const Text('Register'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    const _DemoAccountCard(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LogoHeader extends StatelessWidget {
  const _LogoHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 96,
          width: 96,
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.directions_car_filled,
              color: Colors.white,
              size: 44,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Tadreeb',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Welcome back!',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _DemoAccountCard extends StatelessWidget {
  const _DemoAccountCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFD9B0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Demo Account',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: 10),
          const Text('Email: demo@tadreeb.ae'),
          const SizedBox(height: 6),
          const Text('Password: demo123'),
        ],
      ),
    );
  }
}
