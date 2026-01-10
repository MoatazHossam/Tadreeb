import '../providers/api_provider.dart';
import '../../core/constants/constants.dart';

class BookingsRepository {
  BookingsRepository(this._apiProvider);

  final ApiProvider _apiProvider;

  Future<Map<String, dynamic>> createBooking({
    Map<String, dynamic>? body,
  }) {
    return _apiProvider.post(Constants.bookings, body: body);
  }
}
