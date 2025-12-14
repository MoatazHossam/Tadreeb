import 'package:get/get.dart';

import '../../data/models/instructor.dart';
import '../../data/providers/api_provider.dart';
import '../../data/repositories/instructors_repository.dart';

class InstructorDetailsController extends GetxController {
  InstructorDetailsController(this._repository);

  final InstructorsRepository _repository;

  final instructor = Rxn<Instructor>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  int? _instructorId;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is Instructor) {
      instructor.value = args;
      _instructorId = args.id;
    } else if (args is int) {
      _instructorId = args;
    }

    if (_instructorId != null) {
      fetchInstructorDetails(_instructorId!);
    } else {
      errorMessage.value = 'Instructor details are unavailable.';
    }
  }

  String get bestPriceLabel {
    final currentInstructor = instructor.value;
    if (currentInstructor == null) return 'Pricing not available';

    if (currentInstructor.packages.isEmpty) {
      return currentInstructor.priceLabel;
    }

    final lowest = currentInstructor.packages.reduce(
      (a, b) => a.discountedPrice < b.discountedPrice ? a : b,
    );
    final currencyPrefix = currentInstructor.currency ?? 'AED';
    return '$currencyPrefix ${lowest.discountedPrice.toStringAsFixed(0)}';
  }

  Future<void> fetchInstructorDetails(int id) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final details = await _repository.fetchInstructorById(id);
      instructor.value = details;
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = 'Failed to load instructor details. Please try again later.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retry() {
    if (_instructorId != null) {
      return fetchInstructorDetails(_instructorId!);
    }

    return Future.value();
  }
}
