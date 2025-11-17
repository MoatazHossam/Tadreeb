import 'package:get/get.dart';

import '../../data/models/instructor.dart';

class InstructorsController extends GetxController {
  final instructors = const <Instructor>[
    Instructor(
      name: 'Ahmed Hassan',
      experienceYears: 10,
      city: 'Dubai',
      rating: 4.8,
      specializations: ['Manual', 'Automatic', 'Defensive Driving'],
      priceLabel: 'From AED 1350/package',
      about:
          'Professional driving instructor with 10+ years of experience in Dubai and Abu Dhabi.',
      languages: ['English', 'Arabic', 'Hindi'],
      availability: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Saturday'],
      ratingCount: 156,
      packages: [
        InstructorPackage(
          title: 'Basic Package',
          subtitle: '10 lessons for beginners',
          perks: [
            '10 lessons',
            '2 hours/lesson',
            'Pick up & drop',
            'Theory classes',
            'Mock test',
          ],
          originalPrice: 1500,
          discountedPrice: 1350,
          discountPercent: 10,
        ),
        InstructorPackage(
          title: 'Standard Package',
          subtitle: '20 lessons with road test preparation',
          perks: [
            '20 lessons',
            '2 hours/lesson',
            'Pick up & drop',
            'Theory classes',
            'Mock test',
            'Road test booking',
          ],
          originalPrice: 2800,
          discountedPrice: 2380,
          discountPercent: 15,
        ),
      ],
    ),
    Instructor(
      name: 'Sara Abdullah',
      experienceYears: 8,
      city: 'Abu Dhabi',
      rating: 4.9,
      specializations: ['Automatic', 'Nervous Learners'],
      priceLabel: 'From AED 2090/package',
      about: 'Patient instructor focused on building confidence for nervous learners.',
      languages: ['English', 'Arabic'],
      availability: ['Monday', 'Wednesday', 'Friday', 'Saturday'],
      ratingCount: 98,
      packages: [
        InstructorPackage(
          title: 'Confidence Booster',
          subtitle: '8 sessions tailored for nervous learners',
          perks: [
            'Calm, step-by-step approach',
            'Parking practice',
            'Mock road tests',
            'Progress tracking',
          ],
          originalPrice: 1890,
          discountedPrice: 1790,
        ),
        InstructorPackage(
          title: 'City Pro',
          subtitle: '15 lessons for busy city driving',
          perks: [
            'Rush-hour practice',
            'Roundabout mastery',
            'Highway sessions',
          ],
          originalPrice: 2300,
          discountedPrice: 2090,
          discountPercent: 9,
        ),
      ],
    ),
    Instructor(
      name: 'Mohammed Ali',
      experienceYears: 10,
      city: 'Sharjah',
      rating: 4.7,
      specializations: ['Heavy Vehicle', 'Motorcycle', 'Bus License'],
      priceLabel: 'From AED 1080/package',
      about: 'Expert in heavy vehicle licensing with a focus on safety and discipline.',
      languages: ['English', 'Urdu'],
      availability: ['Sunday', 'Tuesday', 'Wednesday', 'Thursday'],
      ratingCount: 121,
      packages: [
        InstructorPackage(
          title: 'Heavy Vehicle Starter',
          subtitle: 'Learn the fundamentals for heavy vehicles',
          perks: [
            'Safety-first curriculum',
            'Yard practice',
            'Highway drills',
          ],
          originalPrice: 1250,
          discountedPrice: 1080,
          discountPercent: 14,
        ),
        InstructorPackage(
          title: 'Full Commercial Prep',
          subtitle: 'Complete prep for bus and truck licenses',
          perks: [
            'Route planning',
            'Passenger safety',
            'Theory coaching',
          ],
          originalPrice: 1990,
          discountedPrice: 1890,
        ),
      ],
    ),
    Instructor(
      name: 'Fatima Khalid',
      experienceYears: 7,
      city: 'Dubai',
      rating: 4.6,
      specializations: ['Automatic', 'Motorcycle'],
      priceLabel: 'From AED 1490/package',
      about: 'Friendly and supportive instructor with a focus on smooth driving skills.',
      languages: ['English', 'Arabic'],
      availability: ['Monday', 'Tuesday', 'Thursday', 'Saturday'],
      ratingCount: 74,
      packages: [
        InstructorPackage(
          title: 'City Rider',
          subtitle: 'Automatic and motorcycle essentials',
          perks: [
            'Lane discipline',
            'Parking practice',
            'Night driving tips',
          ],
          originalPrice: 1620,
          discountedPrice: 1490,
          discountPercent: 8,
        ),
        InstructorPackage(
          title: 'Advanced Rider',
          subtitle: 'Motorcycle-focused advanced drills',
          perks: [
            'Cornering basics',
            'Defensive riding',
            'Emergency braking',
          ],
          originalPrice: 1750,
          discountedPrice: 1650,
        ),
      ],
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
