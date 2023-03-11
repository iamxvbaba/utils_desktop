import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_desktop/controllers/pages/search_page_controller.dart';

import '../widgets/header_widget.dart';

class SearchPage extends GetView<SearchPageController> {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      extendBodyBehindAppBar: true,
      appBar: HeaderWidget(),
      body: const Center(child: Text('search page'),),
    );
  }
}