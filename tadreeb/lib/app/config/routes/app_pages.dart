import 'package:get/get.dart';

import '../../features/auth/login/bindings/login_binding.dart';
import '../../features/auth/login/controllers/login_controller.dart';
import '../../features/auth/login/views/login_view.dart';

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
