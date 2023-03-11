import 'package:get/get.dart';

import '../bindings/pages/home_page.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/search_page.dart';


part 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const HomePage(),
      participatesInRootNavigator: true,
      fullscreenDialog: true,
      binding: HomePageBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      participatesInRootNavigator: true,
      fullscreenDialog: true,
      binding: HomePageBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchPage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.library,
      page: () => const SearchPage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.favorites,
      page: () => const SearchPage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.seeMore,
      page: () => SearchPage(),
      transition: Transition.fade,
      preventDuplicates: true,
      fullscreenDialog: true,
      transitionDuration: const Duration(milliseconds: 200),
    ),
  ];
}
