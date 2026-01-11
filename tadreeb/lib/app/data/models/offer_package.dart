class OfferPackage {
  const OfferPackage({
    required this.id,
    required this.trainerName,
    required this.name,
    required this.description,
    required this.numberOfLessons,
    required this.hoursPerLesson,
    required this.totalHours,
    required this.basePrice,
    required this.finalPrice,
    required this.discountPercentage,
    required this.pricePerHour,
    required this.isFeatured,
    required this.perks,
    required this.currency,
    this.customPerks,
    this.trainerRating,
    this.trainerLocation,
  });

  final int id;
  final String trainerName;
  final String name;
  final String description;
  final int? numberOfLessons;
  final double? hoursPerLesson;
  final double? totalHours;
  final double? basePrice;
  final double? finalPrice;
  final double? discountPercentage;
  final double? pricePerHour;
  final bool isFeatured;
  final List<String> perks;
  final String? customPerks;
  final String? currency;
  final double? trainerRating;
  final String? trainerLocation;

  int? get discountPercentRounded => discountPercentage?.round();

  double? get effectiveFinalPrice => finalPrice ?? basePrice;

  double? get effectiveBasePrice => basePrice;
}

OfferPackage offerPackageFromJson(Map<String, dynamic> json) {
  final trainerName = json['trainer'] as String? ?? 'Unknown Trainer';
  final perks = _parsePerks(json['perks'], json['custom_perks']);
  final basePrice = _parseDouble(json['base_price']);
  final finalPrice = _parseDouble(json['final_price']);
  final pricePerHour = _parseDouble(json['price_per_hour']);
  final discountPercentage = _parseDouble(json['discount_percentage']);
  final hoursPerLesson = _parseDouble(json['hours_per_lesson']);
  final totalHours = _parseDouble(json['total_hours']);

  return OfferPackage(
    id: json['id'] as int? ?? 0,
    trainerName: trainerName,
    name: json['name'] as String? ?? 'Package',
    description: json['description'] as String? ?? '',
    numberOfLessons: _parseInt(json['number_of_lessons']),
    hoursPerLesson: hoursPerLesson,
    totalHours: totalHours,
    basePrice: basePrice,
    finalPrice: finalPrice ?? basePrice,
    discountPercentage: discountPercentage,
    pricePerHour: pricePerHour,
    isFeatured: json['is_featured'] as bool? ?? false,
    perks: perks,
    customPerks: json['custom_perks'] as String?,
    currency: json['currency'] as String?,
    trainerRating: _parseDouble(json['trainer_rating']),
    trainerLocation: json['trainer_location'] as String?,
  );
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

List<String> _parsePerks(dynamic perks, dynamic customPerks) {
  final parsed = <String>[];

  if (perks is List) {
    for (final perk in perks) {
      if (perk is String) {
        final trimmed = perk.trim();
        if (trimmed.isNotEmpty) parsed.add(trimmed);
      } else if (perk is Map<String, dynamic>) {
        final name = perk['name'] as String?;
        final description = perk['description'] as String?;
        if (name != null && name.trim().isNotEmpty) {
          parsed.add(name.trim());
        } else if (description != null && description.trim().isNotEmpty) {
          parsed.add(description.trim());
        }
      }
    }
  }

  if (customPerks is String && customPerks.trim().isNotEmpty) {
    parsed.addAll(
      customPerks
          .split(RegExp(r'[\n,;]'))
          .map((perk) => perk.trim())
          .where((perk) => perk.isNotEmpty),
    );
  }

  return parsed;
}
