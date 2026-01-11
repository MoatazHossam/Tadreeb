import 'package:get/get.dart';

import '../../data/models/offer_package.dart';
import '../../data/providers/api_provider.dart';
import '../../data/repositories/offers_repository.dart';

class OffersController extends GetxController {
  OffersController(this._repository);

  final OffersRepository _repository;

  final packages = <OfferPackage>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  int? _offset;
  int? _limit;
  int? _hasPerk;
  bool? _isFeatured;
  int? _maxLessons;
  int? _minLessons;
  double? _maxPrice;
  double? _minPrice;

  int? get offset => _offset;
  int? get limit => _limit;
  int? get hasPerk => _hasPerk;
  bool? get isFeatured => _isFeatured;
  int? get maxLessons => _maxLessons;
  int? get minLessons => _minLessons;
  double? get maxPrice => _maxPrice;
  double? get minPrice => _minPrice;

  @override
  void onInit() {
    super.onInit();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.fetchPackages(
        offset: _offset,
        limit: _limit,
        hasPerk: _hasPerk,
        isFeatured: _isFeatured,
        maxLessons: _maxLessons,
        minLessons: _minLessons,
        maxPrice: _maxPrice,
        minPrice: _minPrice,
      );
      packages.assignAll(response.results);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = 'Failed to load offers. Please try again later.';
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters({
    int? offset,
    int? limit,
    int? hasPerk,
    bool? isFeatured,
    int? maxLessons,
    int? minLessons,
    double? maxPrice,
    double? minPrice,
  }) {
    _offset = offset;
    _limit = limit;
    _hasPerk = hasPerk;
    _isFeatured = isFeatured;
    _maxLessons = maxLessons;
    _minLessons = minLessons;
    _maxPrice = maxPrice;
    _minPrice = minPrice;
    fetchPackages();
  }
}
