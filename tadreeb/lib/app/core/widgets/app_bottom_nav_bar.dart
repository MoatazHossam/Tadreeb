import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/routes/app_pages.dart';
import '../theme/app_theme.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key, required this.currentIndex});

  final int currentIndex;

  void _handleTap(int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Get.offNamed(Routes.instructors);
        break;
      case 1:
        Get.offNamed(Routes.offers);
        break;
      case 2:
        Get.offNamed(Routes.bookings);
        break;
      case 3:
        Get.offNamed(Routes.profile);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _handleTap,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.school_outlined),
          label: 'Instructors',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer_outlined),
          label: 'Offers',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
