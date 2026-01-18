import '../../core/constants/constants.dart';
import '../models/booking.dart';
import '../providers/api_provider.dart';
import 'instructors_repository.dart';

class BookingsRepository {
  BookingsRepository(this._apiProvider);

  final ApiProvider _apiProvider;

  Future<Map<String, dynamic>> createBooking({
    Map<String, dynamic>? body,
  }) {
    return _apiProvider.post(Constants.bookings, body: body);
  }

  Future<PaginatedResponse<Booking>> fetchBookings({
    int? offset,
    int? limit,
    String? status,
  }) async {
    final response = await _apiProvider.get(
      Constants.bookingsList,
      queryParameters: {
        if (offset != null) 'offset': offset,
        if (limit != null) 'limit': limit,
        if (status != null && status.isNotEmpty) 'status': status,
      },
    );

    return PaginatedResponse.fromJson(response, Booking.fromJson);
  }

  Future<Booking> approveBooking(int bookingId) async {
    final response = await _apiProvider.post(
      Constants.bookingApprove(bookingId),
    );

    return Booking.fromJson(response);
  }
}
