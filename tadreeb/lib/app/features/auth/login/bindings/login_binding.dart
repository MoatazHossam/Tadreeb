import 'package:get/get.dart';

import '../../../../data/providers/api_provider.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiProvider>(() => ApiProvider());
    Get.lazyPut<AuthRepository>(() => AuthRepository(Get.find()));
    Get.lazyPut<LoginController>(() => LoginController(Get.find()));
  }
}
