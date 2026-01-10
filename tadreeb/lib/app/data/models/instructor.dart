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
    this.englishName,
    this.arabicName,
  });

  final int? id;
  final String name;
  final String? englishName;
  final String? arabicName;

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

  Instructor copyWith({
    int? id,
    String? name,
    int? experienceYears,
    String? city,
    double? rating,
    List<String>? specializations,
    String? priceLabel,
    String? about,
    List<String>? languages,
    List<String>? availability,
    List<InstructorPackage>? packages,
    int? ratingCount,
    Color? avatarColor,
    bool? isAcceptingStudents,
    double? startingPrice,
    String? currency,
    String? workingLocation,
    String? workingLocationDisplay,
    String? profilePicture,
    int? userId,
    String? englishName,
    String? arabicName,
  }) {
    return Instructor(
      id: id ?? this.id,
      name: name ?? this.name,
      experienceYears: experienceYears ?? this.experienceYears,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      specializations: specializations ?? this.specializations,
      priceLabel: priceLabel ?? this.priceLabel,
      about: about ?? this.about,
      languages: languages ?? this.languages,
      availability: availability ?? this.availability,
      packages: packages ?? this.packages,
      ratingCount: ratingCount ?? this.ratingCount,
      avatarColor: avatarColor ?? this.avatarColor,
      isAcceptingStudents: isAcceptingStudents ?? this.isAcceptingStudents,
      startingPrice: startingPrice ?? this.startingPrice,
      currency: currency ?? this.currency,
      workingLocation: workingLocation ?? this.workingLocation,
      workingLocationDisplay:
          workingLocationDisplay ?? this.workingLocationDisplay,
      profilePicture: profilePicture ?? this.profilePicture,
      userId: userId ?? this.userId,
      englishName: this.englishName,
      arabicName: this.arabicName,
    );
  }

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
    final languages = _parseLanguages(json['languages']);
    final availability = _parseAvailability(
      json['availability'],
      json['availability_weekdays'],
    );
    final packages = _parsePackages(json['packages']);
    final about = json['bio'] as String? ?? json['about'] as String? ?? '';
    final englishName = user?['english_name'] as String?;
    final arabicName = user?['arabic_name'] as String? ?? '';

    return Instructor(
      id: json['id'] as int?,
      name: displayName.isNotEmpty ? displayName : 'Unknown Instructor',
      experienceYears: json['years_of_experience'] as int? ?? 0,
      city: (workingLocationDisplay ?? 'Not specified').toString(),
      rating: rating,
      specializations: _parseSpecializations(json['specializations']),
      priceLabel: _formatPriceLabel(startingPrice, currency),
      about: about,
      languages: languages,
      availability: availability,
      packages: packages,
      ratingCount: json['total_reviews'] as int?,
      avatarColor: null,
      isAcceptingStudents: json['is_accepting_students'] as bool?,
      startingPrice: startingPrice,
      currency: currency,
      workingLocation: json['working_location'] as String?,
      workingLocationDisplay: workingLocationDisplay,
      profilePicture: user?['profile_picture'] as String?,
      userId: user?['id'] as int?,
      englishName: englishName,
      arabicName: arabicName
    );
  }
}

List<InstructorPackage> parseInstructorPackages(dynamic packages) {
  return _parsePackages(packages);
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

List<String> _parseLanguages(dynamic languages) {
  if (languages is List) {
    return languages
        .whereType<Map<String, dynamic>>()
        .map((lang) {
          final display = (lang['language_display'] as String?) ??
              (lang['language'] as String?);
          final proficiency =
              (lang['proficiency_display'] as String?) ??
                  (lang['proficiency'] as String?);

          if (display == null || display.trim().isEmpty) return null;

          final normalizedDisplay = display.trim();
          if (proficiency == null || proficiency.trim().isEmpty) {
            return normalizedDisplay;
          }

          return '$normalizedDisplay (${proficiency.trim()})';
        })
        .whereType<String>()
        .toList();
  }

  if (languages is String) {
    return languages
        .split(',')
        .map((lang) => lang.trim())
        .where((lang) => lang.isNotEmpty)
        .toList();
  }

  return const [];
}

List<String> _parseAvailability(dynamic availability, dynamic availabilityWeekdays) {
  const weekdayNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  int _resolveWeekdayIndex(dynamic weekday, String? label) {
    if (weekday is int && weekday >= 0 && weekday < weekdayNames.length) {
      return weekday;
    }

    if (label != null) {
      final matchIndex = weekdayNames
          .indexWhere((name) => name.toLowerCase() == label.toLowerCase());
      if (matchIndex != -1) return matchIndex;
    }

    return weekdayNames.length + 1;
  }

  String? _resolveWeekdayLabel(dynamic weekday, dynamic display) {
    if (display is String && display.trim().isNotEmpty) {
      return _capitalizeWord(display.trim());
    }

    if (weekday is int && weekday >= 0 && weekday < weekdayNames.length) {
      return weekdayNames[weekday];
    }

    if (weekday is String && weekday.trim().isNotEmpty) {
      return _capitalizeWord(weekday.trim());
    }

    return null;
  }

  List<String> parseFromString(String value) {
    return value
        .split(RegExp(r'[;,]'))
        .expand((part) => part.split(RegExp(r'\s+')))
        .map((day) => day.trim())
        .where((day) => day.isNotEmpty)
        .map(_capitalizeWord)
        .toList();
  }

  if (availabilityWeekdays is List) {
    final parsedDays = availabilityWeekdays
        .whereType<Map<String, dynamic>>()
        .where((day) => day['is_available'] == true)
        .map((day) {
          final label = _resolveWeekdayLabel(day['weekday'], day['weekday_display']);
          final index = _resolveWeekdayIndex(day['weekday'], label);
          if (label == null) return null;
          return MapEntry(index, label);
        })
        .whereType<MapEntry<int, String>>()
        .toList();

    parsedDays.sort((a, b) => a.key.compareTo(b.key));

    final uniqueLabels = <String>[];
    for (final entry in parsedDays) {
      if (!uniqueLabels.contains(entry.value)) {
        uniqueLabels.add(entry.value);
      }
    }

    if (uniqueLabels.isNotEmpty) {
      return uniqueLabels;
    }
  }

  if (availability is List) {
    return availability
        .whereType<String>()
        .map(_capitalizeWord)
        .where((day) => day.isNotEmpty)
        .toList();
  }

  if (availability is String) {
    return parseFromString(availability);
  }

  return const [];
}

List<InstructorPackage> _parsePackages(dynamic packages) {
  if (packages is List) {
    return packages
        .whereType<Map<String, dynamic>>()
        .map((package) {
          final title = package['title'] as String? ??
              package['name'] as String? ??
              package['label'] as String?;
          if (title == null || title.trim().isEmpty) return null;

          final perks = _parsePerks(package['perks'], package['custom_perks']);

          final originalPrice = _parseDouble(package['original_price']) ??
              _parseDouble(package['price']) ??
              _parseDouble(package['amount']) ??
              _parseDouble(package['base_price']);
          final discountedPrice =
              _parseDouble(package['discounted_price']) ??
                  _parseDouble(package['final_price']) ??
                  originalPrice;

          if (originalPrice == null || discountedPrice == null) return null;

          final parsedDiscount =
              _parseDouble(package['discount_percent']) ??
                  _parseDouble(package['discount_percentage']);
          final discountPercent = parsedDiscount?.round();

          return InstructorPackage(
            title: title.trim(),
            subtitle: package['subtitle'] as String? ??
                package['description'] as String? ??
                '',
            perks: perks,
            originalPrice: originalPrice,
            discountedPrice: discountedPrice,
            discountPercent: discountPercent,
          );
        })
        .whereType<InstructorPackage>()
        .toList();
  }

  return const [];
}

String _capitalizeWord(String value) {
  if (value.isEmpty) return value;
  if (value.length == 1) return value.toUpperCase();
  return value[0].toUpperCase() + value.substring(1).toLowerCase();
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
