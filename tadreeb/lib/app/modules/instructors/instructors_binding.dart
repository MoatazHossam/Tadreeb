import 'package:get/get.dart';

import '../../data/providers/api_provider.dart';
import '../../data/repositories/instructors_repository.dart';
import 'instructors_controller.dart';

class InstructorsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiProvider>(() => ApiProvider());
    Get.lazyPut<InstructorsRepository>(() => InstructorsRepository(Get.find()));
    Get.lazyPut<InstructorsController>(() => InstructorsController(Get.find()));
  }
}
