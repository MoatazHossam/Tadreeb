import 'package:get/get.dart';

import '../modules/login/bindings/login_binding.dart';
import '../modules/login/controllers/login_controller.dart';
import '../modules/login/views/login_view.dart';

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
