import 'package:get/get.dart';

import '../../data/providers/api_provider.dart';
import '../../data/repositories/bookings_repository.dart';
import '../../data/repositories/instructors_repository.dart';
import 'instructor_details_controller.dart';

class InstructorDetailsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiProvider>()) {
      Get.lazyPut<ApiProvider>(() => ApiProvider());
    }

    if (!Get.isRegistered<InstructorsRepository>()) {
      Get.lazyPut<InstructorsRepository>(() => InstructorsRepository(Get.find()));
    }

    if (!Get.isRegistered<BookingsRepository>()) {
      Get.lazyPut<BookingsRepository>(() => BookingsRepository(Get.find()));
    }

    Get.lazyPut<InstructorDetailsController>(
      () => InstructorDetailsController(
        Get.find(),
        Get.find(),
      ),
    );
  }
}
