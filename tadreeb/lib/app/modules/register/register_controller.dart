import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/constants.dart';
import '../../data/providers/api_provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/token_service.dart';

class RegisterController extends GetxController {
  RegisterController(this._repository, this._tokenService);

  final AuthRepository _repository;
  final TokenService _tokenService;

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isAgreeToTerms = false.obs;
  final canSubmit = false.obs;
  final isLoading = false.obs;

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

  Future<void> register() async {
    if (!canSubmit.value || isLoading.value) return;
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Passwords do not match',
        'Please ensure both password fields are identical.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    final nameParts = fullNameController.text
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final username = email.contains('@') ? email.split('@').first : email;

    try {
      isLoading.value = true;
      final response = await _repository.register(
        email: email,
        username: username,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        password: password,
        passwordConfirmation: confirmPasswordController.text,
      );

      await _tokenService.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      Constants.accessToken = response.accessToken;
      Constants.refreshToken = response.refreshToken;

      Get.snackbar(
        'Registration Successful',
        response.message ?? 'Please check your email to verify your account.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } on ApiException catch (error) {
      Get.snackbar(
        'Registration Failed',
        error.message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (_) {
      Get.snackbar(
        'Registration Failed',
        'Something went wrong, please try again later.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
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
