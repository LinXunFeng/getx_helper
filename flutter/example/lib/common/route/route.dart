import 'package:example/page/home/page/home_page.dart';
import 'package:example/page/profile/page/profile_page.dart';
import 'package:get/get.dart';

abstract class AppRoute {
  static const String home = '/home';
  static const String profile = '/profile';
}

class AppPage {
  static final routes = [
    GetPage(
      name: AppRoute.home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: AppRoute.profile,
      page: () => const ProfilePage(),
    ),
  ];
}
