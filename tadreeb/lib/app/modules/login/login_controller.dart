import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/providers/api_provider.dart';
import '../../data/repositories/auth_repository.dart';

class LoginController extends GetxController {
  LoginController(this._repository);

  final AuthRepository _repository;

  final emailController = TextEditingController(text: 'eve.holt@reqres.in');
  final passwordController = TextEditingController(text: 'cityslicka');

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (isLoading.value) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Please enter both email and password';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _repository.login(email: email, password: password);
      if (response.token.isNotEmpty) {
        Get.snackbar(
          'Welcome back!',
          'You have successfully signed in.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      } else {
        errorMessage.value = 'Invalid credentials, please try again.';
      }
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (error) {
      errorMessage.value = 'Something went wrong, please try again later.';
    } finally {
      isLoading.value = false;
    }
  }

  void togglePassword() {
    isPasswordVisible.toggle();
  }
}
