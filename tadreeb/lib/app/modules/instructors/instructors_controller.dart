import 'package:get/get.dart';

import '../../data/models/instructor.dart';
import '../../data/providers/api_provider.dart';
import '../../data/repositories/instructors_repository.dart';

class InstructorsController extends GetxController {
  InstructorsController(this._repository);

  final InstructorsRepository _repository;

  final instructors = <Instructor>[].obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInstructors();
  }

  List<Instructor> get filteredInstructors {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return instructors;

    return instructors.where((instructor) {
      final matchesName = instructor.name.toLowerCase().contains(query);
      final matchesCity = instructor.city.toLowerCase().contains(query);
      final matchesSpecialization = instructor.specializations.any(
        (spec) => spec.toLowerCase().contains(query),
      );

      return matchesName || matchesCity || matchesSpecialization;
    }).toList();
  }

  Future<void> fetchInstructors() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.fetchInstructors();
      instructors.assignAll(response.results);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = 'Failed to load instructors. Please try again later.';
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }
}
