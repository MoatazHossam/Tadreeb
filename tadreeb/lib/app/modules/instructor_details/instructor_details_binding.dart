import 'package:get/get.dart';

import 'instructor_details_controller.dart';

class InstructorDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InstructorDetailsController>(() => InstructorDetailsController());
  }
}
