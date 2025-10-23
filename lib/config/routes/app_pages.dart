import 'package:get/get.dart';
import 'package:you_app/presentation/profile/bindings/profile_Bindings.dart';
import 'package:you_app/presentation/profile/view/componen/edit_interest_page.dart';

import 'package:you_app/presentation/profile/view/profile_view.dart';
import 'package:you_app/presentation/login/bindings/login_bindings.dart';
import 'package:you_app/presentation/login/view/login.dart';
import 'package:you_app/presentation/register/bindings/register_bindings.dart';
import 'package:you_app/presentation/register/view/register_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(name: _Paths.login, page: () => Login(), binding: LoginBinding()),
    GetPage(
      name: _Paths.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.profile,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(name: _Paths.interest, page: () => EditInterestPage()),
  ];
}
