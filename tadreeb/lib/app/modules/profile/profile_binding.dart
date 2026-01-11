import 'package:get/get.dart';

import '../../data/providers/api_provider.dart';
import '../../data/repositories/bookings_repository.dart';
import '../../data/repositories/profile_repository.dart';
import 'profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiProvider>()) {
      Get.lazyPut<ApiProvider>(() => ApiProvider());
    }
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepository(Get.find<ApiProvider>()),
    );
    Get.lazyPut<BookingsRepository>(
      () => BookingsRepository(Get.find<ApiProvider>()),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        Get.find<ProfileRepository>(),
        Get.find<BookingsRepository>(),
      ),
    );
  }
}
