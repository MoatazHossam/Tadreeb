import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/ui/theme/app_theme.dart';

void main() {
  runApp(const TadreebApp());
}

class TadreebApp extends StatelessWidget {
  const TadreebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tadreeb',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
