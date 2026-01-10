import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/models/instructor.dart';
import '../../data/providers/api_provider.dart';
import '../../data/repositories/bookings_repository.dart';
import '../../data/repositories/instructors_repository.dart';

class InstructorDetailsController extends GetxController {
  InstructorDetailsController(this._repository, this._bookingsRepository);

  final InstructorsRepository _repository;
  final BookingsRepository _bookingsRepository;

  final instructor = Rxn<Instructor>();
  final isLoading = false.obs;
  final isPackagesLoading = false.obs;
  final isBooking = false.obs;
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
    print('FETCHING INSTRUCTOR DETAILS FOR ID: $id');
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final details = await _repository.fetchInstructorById(id);
      print(details);
      instructor.value = details;
      await _fetchInstructorPackages(id);
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

  Future<void> bookNow(int packageId) async {
    if (isBooking.value) return;

    print(formattedDate(DateTime.now().add(Duration(days: 1)).toString()));

    try {
      isBooking.value = true;
      final response = await _bookingsRepository.createBooking(body: {
        'trainee_notes': '',
        'package_id': packageId,
        'start_date': formattedDate(DateTime.now().add(Duration(days: 1)).toString()),
      });
      final bookingReference = response['booking_reference']?.toString();
      final statusDisplay = response['status_display']?.toString();
      var message = 'Your booking request has been created.';
      if (bookingReference != null && bookingReference.isNotEmpty) {
        message = 'Booking $bookingReference created.';
      }
      if (statusDisplay != null && statusDisplay.isNotEmpty) {
        message = '$message Status: $statusDisplay.';
      }

      Get.snackbar(
        'Booking requested',
        message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } on ApiException catch (error) {
      Get.snackbar(
        'Booking failed',
        error.message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (_) {
      Get.snackbar(
        'Booking failed',
        'Something went wrong while creating your booking.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isBooking.value = false;
    }
  }

  //format date
  String formattedDate(String dateStr) {
    final dateTime = DateTime.parse(dateStr);
    final formatted = '${dateTime.year.toString().padLeft(4, '0')}-'
        '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')}';
    return formatted;
  }

  Future<void> _fetchInstructorPackages(int id) async {
    try {
      isPackagesLoading.value = true;
      final packages = await _repository.fetchInstructorPackages(id);
      final currentInstructor = instructor.value;
      if (currentInstructor != null) {
        instructor.value = currentInstructor.copyWith(packages: packages);
      }
    } catch (_) {
      // Packages are optional; errors should not block instructor details.
    } finally {
      isPackagesLoading.value = false;
    }
  }
}
