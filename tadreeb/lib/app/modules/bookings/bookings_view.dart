import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/app_bottom_nav_bar.dart';
import 'bookings_controller.dart';

class BookingsView extends GetView<BookingsController> {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: SizedBox.shrink()),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 2),
    );
  }
}
