import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_desktop/controllers/pages/home_page_controller.dart';

import '../widgets/header_widget.dart';
import '../widgets/poker/model.dart';
import '../widgets/poker/poker_card.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // 延伸body至顶部
      appBar: HeaderWidget(),
      body: Center(
        child: Row(
          children: const [
            PokerCard(Rank.ace, Suit.spade),
            PokerCard(Rank.jack, Suit.heart),
            PokerCard(Rank.king, Suit.diamond),
            PokerCard(Rank.queen, Suit.club),
            PokerCard(Rank.four, Suit.heart),
            PokerCard(Rank.nine, Suit.diamond),
            PokerCard(Rank.ten, Suit.spade),
            PokerCard(Rank.ten, Suit.heart),
          ],
        ),
      ),
    );
  }
}
