import 'package:flutter/material.dart';

class InstructorPackage {
  const InstructorPackage({
    required this.title,
    required this.subtitle,
    required this.perks,
    required this.originalPrice,
    required this.discountedPrice,
    this.discountPercent,
  });

  final String title;
  final String subtitle;
  final List<String> perks;
  final double originalPrice;
  final double discountedPrice;
  final int? discountPercent;
}

class Instructor {
  const Instructor({
    this.id,
    required this.name,
    required this.experienceYears,
    required this.city,
    required this.rating,
    required this.specializations,
    required this.priceLabel,
    required this.about,
    required this.languages,
    required this.availability,
    required this.packages,
    this.ratingCount,
    this.avatarColor,
    this.isAcceptingStudents,
    this.startingPrice,
    this.currency,
    this.workingLocation,
    this.workingLocationDisplay,
    this.profilePicture,
    this.userId,
  });

  final int? id;
  final String name;
  final int experienceYears;
  final String city;
  final double rating;
  final List<String> specializations;
  final String priceLabel;
  final String about;
  final List<String> languages;
  final List<String> availability;
  final List<InstructorPackage> packages;
  final int? ratingCount;
  final Color? avatarColor;
  final bool? isAcceptingStudents;
  final double? startingPrice;
  final String? currency;
  final String? workingLocation;
  final String? workingLocationDisplay;
  final String? profilePicture;
  final int? userId;

  factory Instructor.fromApiJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final rawFullName = user?['full_name'] as String?;
    final firstName = user?['first_name'] as String?;
    final lastName = user?['last_name'] as String?;
    final combinedName = [firstName, lastName]
        .where((part) => part != null && part!.trim().isNotEmpty)
        .map((part) => part!.trim())
        .join(' ');
    final displayName = (rawFullName?.trim().isNotEmpty ?? false)
        ? rawFullName!.trim()
        : (combinedName.isNotEmpty ? combinedName : 'Unknown Instructor');

    final averageRating = json['average_rating'];
    final rating = _parseDouble(averageRating) ?? 0;

    final workingLocationDisplay =
        json['working_location_display'] as String? ?? json['working_location'] as String?;
    final startingPrice = _parseDouble(json['starting_price']);
    final currency = json['currency'] as String?;

    return Instructor(
      id: json['id'] as int?,
      name: displayName.isNotEmpty ? displayName : 'Unknown Instructor',
      experienceYears: json['years_of_experience'] as int? ?? 0,
      city: (workingLocationDisplay ?? 'Not specified').toString(),
      rating: rating,
      specializations: _parseSpecializations(json['specializations']),
      priceLabel: _formatPriceLabel(startingPrice, currency),
      about: json['about'] as String? ?? '',
      languages: const [],
      availability: const [],
      packages: const [],
      ratingCount: json['total_reviews'] as int?,
      avatarColor: null,
      isAcceptingStudents: json['is_accepting_students'] as bool?,
      startingPrice: startingPrice,
      currency: currency,
      workingLocation: json['working_location'] as String?,
      workingLocationDisplay: workingLocationDisplay,
      profilePicture: user?['profile_picture'] as String?,
      userId: user?['id'] as int?,
    );
  }
}

List<String> _parseSpecializations(dynamic specializations) {
  if (specializations is List) {
    return specializations
        .whereType<String>()
        .map((spec) => spec.trim())
        .where((spec) => spec.isNotEmpty)
        .toList();
  }
  if (specializations is String) {
    return specializations
        .split(',')
        .map((spec) => spec.trim())
        .where((spec) => spec.isNotEmpty)
        .toList();
  }
  return const [];
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

String _formatPriceLabel(double? startingPrice, String? currency) {
  if (startingPrice == null) return 'Pricing not available';

  final formattedPrice = startingPrice % 1 == 0
      ? startingPrice.toStringAsFixed(0)
      : startingPrice.toStringAsFixed(2);

  if (currency != null && currency.trim().isNotEmpty) {
    return 'From $currency $formattedPrice';
  }

  return 'From $formattedPrice';
}
