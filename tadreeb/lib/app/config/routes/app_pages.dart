import 'package:get/get.dart';

import '../../modules/login/login_binding.dart';
import '../../modules/login/login_controller.dart';
import '../../modules/login/login_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.login;

  static final routes = <GetPage<dynamic>>[
    GetPage<LoginController>(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
  ];
}
