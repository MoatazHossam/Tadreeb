import 'package:get/get.dart';

import '../../data/models/instructor.dart';

class InstructorDetailsController extends GetxController {
  late final Instructor instructor;

  @override
  void onInit() {
    super.onInit();
    instructor = Get.arguments as Instructor;
  }

  String get bestPriceLabel {
    if (instructor.packages.isEmpty) return instructor.priceLabel;
    final lowest = instructor.packages.reduce((a, b) =>
        a.discountedPrice < b.discountedPrice ? a : b);
    return 'AED ${lowest.discountedPrice.toStringAsFixed(0)}';
  }
}
