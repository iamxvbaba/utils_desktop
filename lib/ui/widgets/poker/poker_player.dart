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

  final int currentTrickWinner;
  final int contractPlayer;
  final int currentBidPlayer;
  final int trumpOwnerPosition;
  final int currentActionPlayer;
  BidType? currentBid;
  PlayedCardModel? trumpCard;

  PokerPlayer(
      {required this.position,
      required this.currentTrickWinner,
      required this.contractPlayer,
      required this.currentBidPlayer,
      required this.trumpOwnerPosition,
      required this.currentActionPlayer,
      this.isSelf = false,
      this.children,
      this.currentBid,
      this.trumpCard,
      required this.bidTypes,
      required this.announcesTypes,
      super.key});

  bool hasBid(BidType bt) {
    return bidTypes.contains(bt);
  }

  Widget _buildName() {
    return Row(
      children: [
        // trick胜利标志
        currentTrickWinner == position
            ? TextButton(
                onPressed: () {
                  Get.snackbar('提示', '用户为此trick赢家');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text(
                  ' trick赢家',
                ))
            : Container(),
        //  买牌人标识
        contractPlayer == position
            ? TextButton(
                onPressed: () {
                  Get.snackbar('提示', '用户为买牌者');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: Colors.lightGreenAccent,
                ),
                child: const Text(
                  '买牌者',
                ))
            : Container(),
        // 出价信息
        currentBidPlayer == position
            ? TextButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: Colors.blueGrey,
                ),
                child: Text(
                  '出价 ${currentBid?.value}',
                ))
            : Container(),
        trumpOwnerPosition == position
            // 收了公共牌标识
            ? PokerCard(
                rank: trumpCard!.rank,
                suit: trumpCard!.suit,
                height: 50,
                width: 40,
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              color: currentActionPlayer == position
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
      final PokerTableController controller = Get.find();
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            controller.sun.value
                ? const Text(
                    'Sun A > 10 > K > Q > J > 9 > 8 > 7',
                  )
                : const Text(
                    'Hokum J > 9 > A > 10 > K > Q > 8 > 7 ',
                  ),
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
