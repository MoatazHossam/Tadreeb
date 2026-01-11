import 'package:get/get.dart';

import '../../data/providers/api_provider.dart';
import '../../data/repositories/offers_repository.dart';
import 'offers_controller.dart';

class OffersBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiProvider>()) {
      Get.lazyPut<ApiProvider>(() => ApiProvider());
    }
    Get.lazyPut<OffersRepository>(() => OffersRepository(Get.find()));
    Get.lazyPut<OffersController>(() => OffersController(Get.find()));
  }
}
