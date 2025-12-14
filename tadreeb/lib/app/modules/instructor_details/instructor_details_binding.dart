import 'package:get/get.dart';

import '../../data/providers/api_provider.dart';
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

    Get.lazyPut<InstructorDetailsController>(() => InstructorDetailsController(Get.find()));
  }
}
