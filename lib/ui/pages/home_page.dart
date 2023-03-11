import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_desktop/controllers/pages/home_page_controller.dart';

import '../widgets/header_widget.dart';


class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      extendBodyBehindAppBar: true, // 延伸body至顶部
      appBar: HeaderWidget(),
      body: const Center(child: Text('home page'),),
    );
  }
}