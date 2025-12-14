import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/routes/app_pages.dart';
import '../../core/constants/constants.dart';
import '../../data/providers/api_provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/token_service.dart';

class LoginController extends GetxController {
  LoginController(this._repository, this._tokenService);

  final AuthRepository _repository;
  final TokenService _tokenService;

  final emailController = TextEditingController(text: 'demo@tadreeb.ae');
  final passwordController = TextEditingController(text: 'demo123');

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
    final osType = GetPlatform.isIOS
        ? 'ios'
        : GetPlatform.isAndroid
            ? 'android'
            : GetPlatform.isWeb
                ? 'web'
                : 'unknown';

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Please enter both email and password';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _repository.login(
        email: email,
        password: password,
        deviceId: '',
        osType: osType,
        deviceName: '',
        fcmToken: '',
      );
      if (response.isAuthenticated) {
        await _tokenService.saveTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        );
        Constants.accessToken = response.accessToken;

        final userName = response.user?.fullName?.trim();
        final greetingName =
            (userName?.isNotEmpty ?? false) ? userName! : response.user?.email ?? 'User';
        Get.snackbar(
          'Welcome back!',
          'Hello $greetingName, you have successfully signed in.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        Get.offAndToNamed(Routes.instructors);
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
