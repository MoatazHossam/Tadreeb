import 'package:get/get.dart';

import '../../data/providers/api_provider.dart';
import '../../data/repositories/bookings_repository.dart';
import 'bookings_controller.dart';

class BookingsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiProvider>()) {
      Get.lazyPut<ApiProvider>(() => ApiProvider());
    }
    if (!Get.isRegistered<BookingsRepository>()) {
      Get.lazyPut<BookingsRepository>(() => BookingsRepository(Get.find()));
    }
    Get.lazyPut<BookingsController>(() => BookingsController(Get.find()));
  }
}
