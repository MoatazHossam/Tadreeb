import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/models/booking.dart';
import '../../data/providers/api_provider.dart';
import '../../data/repositories/bookings_repository.dart';

class TrainerBookingsController extends GetxController {
  TrainerBookingsController(this._repository);

  final BookingsRepository _repository;

  final bookings = <Booking>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final approvingIds = <int>{}.obs;

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
      final response = await _repository.fetchBookings();
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

  Future<void> approveBooking(Booking booking) async {
    if (!booking.isPending) return;
    if (approvingIds.contains(booking.id)) return;

    try {
      approvingIds.add(booking.id);
      final updatedBooking = await _repository.approveBooking(booking.id);
      final index = bookings.indexWhere((item) => item.id == booking.id);
      if (index != -1) {
        bookings[index] = updatedBooking;
      }
      Get.snackbar(
        'Booking approved',
        'The booking has been approved successfully.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } on ApiException catch (error) {
      Get.snackbar(
        'Approval failed',
        error.message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (_) {
      Get.snackbar( 
        'Approval failed',
        'Something went wrong while approving the booking.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      approvingIds.remove(booking.id);
    }
  }
}
