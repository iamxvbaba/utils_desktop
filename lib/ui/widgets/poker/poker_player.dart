import 'package:flutter/material.dart';
import 'package:skeleton_desktop/ui/widgets/poker/model.dart';
import 'package:get/get.dart';
import 'package:skeleton_desktop/ui/widgets/poker/poker_card.dart';

import '../../../controllers/pages/poker_table_controller.dart';

class PokerPlayer extends StatelessWidget {
  final int position;
  final bool isSelf;
  final List<Widget>? children;

  final List<BidType> bidTypes; // 可用出价列表
  final List<AnnounceType> announcesTypes; // 展示出价按钮

  const PokerPlayer(
      {required this.position,
      this.isSelf = false,
      this.children,
      required this.bidTypes,
      required this.announcesTypes,
      super.key});

  bool hasBid(BidType bt) {
    return bidTypes.contains(bt);
  }

  Widget _buildName() {
    final PokerTableController controller = Get.find();

    return Row(
      children: [
        controller.trumpOwnerPosition.value == position
            // 收了公共牌标识
            ? PokerCard(
                rank: controller.trumpCard.rank,
                suit: controller.trumpCard.suit,
                height: 50,
                width: 40,
              )
            : Container(),
        //TODO: 当前出牌标识

        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              color: controller.currentActionPlayer.value == position
                  ? Colors.lightGreenAccent
                  : Colors.blueGrey,
            ),
            child: Center(
              child: Text(position.toString()),
            ),
          ),
        )
      ],
    );
  }

  // 出价列表
  List<Widget> _buildBtnList() {
    final PokerTableController controller = Get.find();
    var widgets = <Widget>[];

    widgets.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: _buildName(),
    ));

    for (var element in bidTypes) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: SizedBox(
          child: TextButton(
            onPressed: () {
              controller.bid(element);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              backgroundColor: Colors.black12,
            ),
            child: Text(element.value),
          ),
        ),
      ));
    }
    return widgets;
  }

  // Widget _buildAnnounceButton(VoidCallback callback, String text, bool enable) {
  //    Colors.lightBlue
  // }

  @override
  Widget build(BuildContext context) {
    if (isSelf) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildBtnList(),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: children!,
            )
          ],
        ),
      );
    }
    return _buildName();
  }
}
