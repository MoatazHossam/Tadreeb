import '../../core/constants/constants.dart';
import '../models/offer_package.dart';
import '../providers/api_provider.dart';
import 'instructors_repository.dart';

class OffersRepository {
  OffersRepository(this._apiProvider);

  final ApiProvider _apiProvider;

  Future<PaginatedResponse<OfferPackage>> fetchPackages({
    int? offset,
    int? limit,
    int? hasPerk,
    bool? isFeatured,
    int? maxLessons,
    int? minLessons,
    double? maxPrice,
    double? minPrice,
  }) async {
    final response = await _apiProvider.get(
      Constants.packages,
      queryParameters: {
        if (offset != null) 'offset': offset,
        if (limit != null) 'limit': limit,
        if (hasPerk != null) 'has_perk': hasPerk,
        if (isFeatured != null) 'is_featured': isFeatured,
        if (maxLessons != null) 'max_lessons': maxLessons,
        if (minLessons != null) 'min_lessons': minLessons,
        if (maxPrice != null) 'max_price': maxPrice,
        if (minPrice != null) 'min_price': minPrice,
      },
    );

    return PaginatedResponse.fromJson(response, offerPackageFromJson);
  }
}
