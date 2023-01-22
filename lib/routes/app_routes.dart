import 'package:animes/pages/home_page.dart';
import 'package:animes/pages/status_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String home = '/';
  static String statusPage = '/status';
  static String getHome() => home;
  static String getStatus() => statusPage;

  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => HomePage(),
      transition: Transition.cupertino,
    ),
    GetPage(
        name: statusPage,
        page: () => StatusPage(),
        transition: Transition.cupertino)
  ];
}
