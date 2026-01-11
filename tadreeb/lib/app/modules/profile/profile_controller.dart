import 'package:get/get.dart';

import '../../data/models/profile.dart';
import '../../data/providers/api_provider.dart';
import '../../data/repositories/bookings_repository.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  ProfileController(this._profileRepository, this._bookingsRepository);

  final ProfileRepository _profileRepository;
  final BookingsRepository _bookingsRepository;

  final profile = Rxn<Profile>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final totalBookings = 0.obs;
  final completedBookings = 0.obs;
  final successRate = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final profileResponse = await _profileRepository.fetchProfile();
      final bookingsResponse = await _bookingsRepository.fetchBookings();
      final completedResponse = await _bookingsRepository.fetchBookings(
        status: 'completed',
      );

      profile.value = profileResponse;
      totalBookings.value = bookingsResponse.count;
      completedBookings.value = completedResponse.count;
      successRate.value = _calculateSuccessRate(
        totalBookings.value,
        completedBookings.value,
      );
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value =
          'Failed to load profile information. Please try again later.';
    } finally {
      isLoading.value = false;
    }
  }

  double _calculateSuccessRate(int total, int completed) {
    if (total <= 0) return 0;
    final rate = (completed / total) * 100;
    if (rate.isNaN || rate.isInfinite) return 0;
    return rate.clamp(0, 100);
  }
}
