import 'package:get/get.dart';

import '../../data/providers/api_provider.dart';
import '../../data/repositories/bookings_repository.dart';
import 'trainer_bookings_controller.dart';

class TrainerBookingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiProvider>(() => ApiProvider());
    Get.lazyPut<BookingsRepository>(() => BookingsRepository(Get.find()));
    Get.lazyPut<TrainerBookingsController>(
      () => TrainerBookingsController(Get.find()),
    );
  }
}
