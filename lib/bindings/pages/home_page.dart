import 'package:get/get.dart';
import 'package:skeleton_desktop/controllers/pages/home_page_controller.dart';

class HomePageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
          () => HomePageController(),
    );
  }
}