import 'package:get/get.dart';

class Instructor {
  const Instructor({
    required this.name,
    required this.experienceYears,
    required this.city,
    required this.rating,
    required this.specializations,
    required this.priceLabel,
  });

  final String name;
  final int experienceYears;
  final String city;
  final double rating;
  final List<String> specializations;
  final String priceLabel;
}

class InstructorsController extends GetxController {
  final instructors = const <Instructor>[
    Instructor(
      name: 'Ahmed Hassan',
      experienceYears: 10,
      city: 'Dubai',
      rating: 4.8,
      specializations: ['Manual', 'Automatic', 'Defensive Driving'],
      priceLabel: 'From AED 1350/package',
    ),
    Instructor(
      name: 'Sara Abdullah',
      experienceYears: 8,
      city: 'Abu Dhabi',
      rating: 4.9,
      specializations: ['Automatic', 'Nervous Learners'],
      priceLabel: 'From AED 2090/package',
    ),
    Instructor(
      name: 'Mohammed Ali',
      experienceYears: 10,
      city: 'Sharjah',
      rating: 4.7,
      specializations: ['Heavy Vehicle', 'Motorcycle', 'Bus License'],
      priceLabel: 'From AED 1080/package',
    ),
    Instructor(
      name: 'Fatima Khalid',
      experienceYears: 7,
      city: 'Dubai',
      rating: 4.6,
      specializations: ['Automatic', 'Motorcycle'],
      priceLabel: 'From AED 1490/package',
    ),
  ];

  final searchQuery = ''.obs;

  List<Instructor> get filteredInstructors {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return instructors;

    return instructors.where((instructor) {
      final matchesName = instructor.name.toLowerCase().contains(query);
      final matchesCity = instructor.city.toLowerCase().contains(query);
      final matchesSpecialization = instructor.specializations.any(
        (spec) => spec.toLowerCase().contains(query),
      );

      return matchesName || matchesCity || matchesSpecialization;
    }).toList();
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }
}
