import 'package:get/get.dart';

import '../../data/models/booking.dart';
import '../../data/providers/api_provider.dart';
import '../../data/repositories/bookings_repository.dart';

class BookingsController extends GetxController {
  BookingsController(this._repository);

  final BookingsRepository _repository;

  final bookings = <Booking>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  int? _offset;
  int? _limit;

  int? get offset => _offset;
  int? get limit => _limit;

  List<Booking> get activeBookings =>
      bookings.where((booking) => !booking.isCompleted).toList();

  List<Booking> get completedBookings =>
      bookings.where((booking) => booking.isCompleted).toList();

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.fetchBookings(
        offset: _offset,
        limit: _limit,
      );
      bookings.assignAll(response.results);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value =
          'Failed to load bookings. Please try again later.';
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters({
    int? offset,
    int? limit,
  }) {
    _offset = offset;
    _limit = limit;
    fetchBookings();
  }
}
