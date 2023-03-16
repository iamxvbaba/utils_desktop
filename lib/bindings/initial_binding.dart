import 'package:get/get.dart';
import 'package:skeleton_desktop/controllers/navigation_controller.dart';
import 'package:skeleton_desktop/controllers/pages/poker_table_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<PokerTableController>(() => PokerTableController());
  }
}
