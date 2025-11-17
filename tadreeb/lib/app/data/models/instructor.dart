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
  });

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
}
