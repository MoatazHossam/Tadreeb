import 'package:get/get.dart';

import '../../data/providers/api_provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/token_service.dart';
import 'register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiProvider>(() => ApiProvider());
    Get.lazyPut<AuthRepository>(() => AuthRepository(Get.find()));
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<RegisterController>(() => RegisterController(Get.find(), Get.find()));
  }
}
