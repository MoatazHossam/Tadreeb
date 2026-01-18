import 'package:get/get.dart';

import '../../modules/instructors/instructors_binding.dart';
import '../../modules/instructors/instructors_controller.dart';
import '../../modules/instructors/instructors_view.dart';
import '../../modules/instructor_details/instructor_details_binding.dart';
import '../../modules/instructor_details/instructor_details_controller.dart';
import '../../modules/instructor_details/instructor_details_view.dart';
import '../../modules/login/login_binding.dart';
import '../../modules/login/login_controller.dart';
import '../../modules/login/login_view.dart';
import '../../modules/offers/offers_binding.dart';
import '../../modules/offers/offers_controller.dart';
import '../../modules/offers/offers_view.dart';
import '../../modules/bookings/bookings_binding.dart';
import '../../modules/bookings/bookings_controller.dart';
import '../../modules/bookings/bookings_view.dart';
import '../../modules/profile/profile_binding.dart';
import '../../modules/profile/profile_controller.dart';
import '../../modules/profile/profile_view.dart';
import '../../modules/register/register_binding.dart';
import '../../modules/register/register_controller.dart';
import '../../modules/register/register_view.dart';
import '../../modules/trainer_bookings/trainer_bookings_binding.dart';
import '../../modules/trainer_bookings/trainer_bookings_controller.dart';
import '../../modules/trainer_bookings/trainer_bookings_view.dart';

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
    GetPage<InstructorsController>(
      name: Routes.instructors,
      page: () => const InstructorsView(),
      binding: InstructorsBinding(),
    ),
    GetPage<OffersController>(
      name: Routes.offers,
      page: () => const OffersView(),
      binding: OffersBinding(),
    ),
    GetPage<BookingsController>(
      name: Routes.bookings,
      page: () => const BookingsView(),
      binding: BookingsBinding(),
    ),
    GetPage<ProfileController>(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage<InstructorDetailsController>(
      name: Routes.instructorDetails,
      page: () => const InstructorDetailsView(),
      binding: InstructorDetailsBinding(),
    ),
    GetPage<RegisterController>(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage<TrainerBookingsController>(
      name: Routes.trainerBookings,
      page: () => const TrainerBookingsView(),
      binding: TrainerBookingsBinding(),
    ),
  ];
}
