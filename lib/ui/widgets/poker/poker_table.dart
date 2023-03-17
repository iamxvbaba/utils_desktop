import 'package:flutter/material.dart';
import 'package:skeleton_desktop/controllers/pages/poker_table_controller.dart';
import 'package:skeleton_desktop/ui/widgets/poker/model.dart';
import 'package:skeleton_desktop/ui/widgets/poker/poker_ranking.dart';
import 'package:get/get.dart';
import 'poker_played_card.dart';
import 'poker_player.dart';

class PlayedCardModel {
  final String name;
  final Rank rank;
  final Suit suit;
  bool win = false;

  PlayedCardModel(this.name, this.rank, this.suit);
}

// 牌局桌面
class PokerTableLayout extends GetView<PokerTableController> {
  const PokerTableLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: [
            Positioned(
                top: 20,
                right: 20,
                child: PokerRanking(
                    controller.ewTotalPoint.value,
                    controller.ewPoint.value,
                    controller.snTotalPoint.value,
                    controller.snPoint.value)),
            Positioned(
                bottom: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: controller.connect,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: Colors.lightBlue,
                  ),
                  child: Text('连接服务器'),
                )),
            Positioned(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const PokerPlayer(
                  name: "west",
                  bidTypes: [],
                  announcesTypes: [],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PokerPlayer(
                      name: "north",
                      bidTypes: [],
                      announcesTypes: [],
                    ),
                    PokerPlayedCardList(controller.buildPlayedCards()),
                    PokerPlayer(
                      name: controller.myPosition.value,
                      isSelf: true,
                      bidTypes: controller.bids.value,
                      announcesTypes: controller.announces.value,
                      children: controller.buildCards(),
                    )
                  ],
                ),
                const PokerPlayer(
                  name: "east",
                  bidTypes: [],
                  announcesTypes: [],
                ),
              ],
            ))
          ],
        ));
  }
}
