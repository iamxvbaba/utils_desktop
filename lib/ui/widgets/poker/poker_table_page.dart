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
            // 计分板
            Positioned(
                top: 20,
                right: 20,
                child: PokerRanking(
                    controller.ewTotalPoint.value,
                    controller.ewPoint.value,
                    controller.snTotalPoint.value,
                    controller.snPoint.value)),

            // 连接服务器按钮
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
                PokerPlayer(
                  position: 8,
                  currentTrickWinner: controller.currentTrickWinner.value,
                  contractPlayer: controller.contractPlayer.value,
                  currentBidPlayer: controller.currentBidPlayer.value,
                  trumpOwnerPosition: controller.trumpOwnerPosition.value,
                  currentActionPlayer: controller.currentActionPlayer.value,
                  currentBid: controller.currentBid,
                  trumpCard: controller.trumpCard,
                  bidTypes: [],
                  announcesTypes: [],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PokerPlayer(
                      position: 4,
                      currentTrickWinner: controller.currentTrickWinner.value,
                      contractPlayer: controller.contractPlayer.value,
                      currentBidPlayer: controller.currentBidPlayer.value,
                      trumpOwnerPosition: controller.trumpOwnerPosition.value,
                      currentActionPlayer: controller.currentActionPlayer.value,
                      currentBid: controller.currentBid,
                      trumpCard: controller.trumpCard,
                      bidTypes: [],
                      announcesTypes: [],
                    ),

                    // 出牌列表
                    PokerPlayedCardList(controller.buildPlayedCards()),

                    // TODO: South, 自己的位置
                    PokerPlayer(
                      position: controller.myPosition.value,
                      currentTrickWinner: controller.currentTrickWinner.value,
                      contractPlayer: controller.contractPlayer.value,
                      currentBidPlayer: controller.currentBidPlayer.value,
                      trumpOwnerPosition: controller.trumpOwnerPosition.value,
                      currentActionPlayer: controller.currentActionPlayer.value,
                      currentBid: controller.currentBid,
                      trumpCard: controller.trumpCard,
                      isSelf: true,
                      bidTypes: controller.availableBids,
                      announcesTypes: controller.announces,
                      children: controller.buildCards(),
                    )
                  ],
                ),
                PokerPlayer(
                  position: 2,
                  currentTrickWinner: controller.currentTrickWinner.value,
                  contractPlayer: controller.contractPlayer.value,
                  currentBidPlayer: controller.currentBidPlayer.value,
                  trumpOwnerPosition: controller.trumpOwnerPosition.value,
                  currentActionPlayer: controller.currentActionPlayer.value,
                  currentBid: controller.currentBid,
                  trumpCard: controller.trumpCard,
                  bidTypes: [],
                  announcesTypes: [],
                ),
              ],
            ))
          ],
        ));
  }
}
