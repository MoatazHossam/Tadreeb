import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController(text: '+971 50 123 4567');
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isAgreeToTerms = false.obs;
  final canSubmit = false.obs;

  @override
  void onInit() {
    super.onInit();
    fullNameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    confirmPasswordController.addListener(_validateForm);
    ever<bool>(isAgreeToTerms, (_) => _validateForm());
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.toggle();
  }

  void toggleTermsAgreement(bool? value) {
    isAgreeToTerms.value = value ?? false;
  }

  void register() {
    if (!canSubmit.value) return;
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Passwords do not match',
        'Please ensure both password fields are identical.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    Get.snackbar(
      'Account created',
      'This is a UI-only demo. No data was sent.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void _validateForm() {
    final isFilled =
        fullNameController.text.trim().isNotEmpty &&
            emailController.text.trim().isNotEmpty &&
            phoneController.text.trim().isNotEmpty &&
            passwordController.text.isNotEmpty &&
            confirmPasswordController.text.isNotEmpty;
    canSubmit.value = isFilled && isAgreeToTerms.value;
  }
}
