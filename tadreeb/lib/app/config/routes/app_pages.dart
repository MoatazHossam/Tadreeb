import 'package:get/get.dart';

import '../../modules/instructors/instructors_binding.dart';
import '../../modules/instructors/instructors_controller.dart';
import '../../modules/instructors/instructors_view.dart';
import '../../modules/login/login_binding.dart';
import '../../modules/login/login_controller.dart';
import '../../modules/login/login_view.dart';
import '../../modules/register/register_binding.dart';
import '../../modules/register/register_controller.dart';
import '../../modules/register/register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.instructors;

  static final routes = <GetPage<dynamic>>[
    GetPage<LoginController>(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage<InstructorsController>(
      name: Routes.instructors,
      page: () => const InstructorsView(),
      binding: InstructorsBinding(),
    ),
    GetPage<RegisterController>(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
  ];
}
