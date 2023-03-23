import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_desktop/controllers/pages/home_page_controller.dart';

import '../widgets/poker/poker_table_page.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true, // 延伸body至顶部
      // appBar: HeaderWidget(),
      body: Center(
        child: PokerTableLayout(),
      ),
    );
  }
}
