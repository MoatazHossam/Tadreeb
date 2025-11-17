import 'package:get/get.dart';

import 'instructors_controller.dart';

class InstructorsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InstructorsController>(() => InstructorsController());
  }
}
