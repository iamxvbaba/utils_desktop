import 'package:flutter/material.dart';
import 'package:skeleton_desktop/ui/widgets/poker/model.dart';
import 'package:get/get.dart';

import '../../../controllers/pages/poker_table_controller.dart';

class PokerPlayer extends StatelessWidget {
  final String name;
  final bool isSelf;
  final List<Widget>? children;

  final List<BidType> bidTypes; // 展示出价按钮
  final List<AnnounceType> announcesTypes; // 展示出价按钮

  const PokerPlayer(
      {required this.name,
      this.isSelf = false,
      this.children,
      required this.bidTypes,
      required this.announcesTypes,
      super.key});

  bool hasBid(BidType bt) {
    return bidTypes.contains(bt);
  }

  Widget _buildName() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 60,
        width: 60,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: Colors.blueGrey,
        ),
        child: Center(
          child: Text(name),
        ),
      ),
    );
  }

  Widget _buildBidButton(VoidCallback callback, String text, bool enable) {
    if (!enable) {
      return Container();
    }
    return SizedBox(
      height: 50,
      width: 70,
      child: ElevatedButton(
        onPressed: callback,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.lightBlueAccent,
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildAnnounceButton(VoidCallback callback, String text, bool enable) {
    if (!enable) {
      return Container();
    }
    return SizedBox(
      height: 50,
      width: 80,
      child: ElevatedButton(
        onPressed: callback,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.lightBlue,
        ),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PokerTableController controller = Get.find();
    if (isSelf) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildName(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildBidButton(() {
                    if (hasBid(BidType.clubs)) {
                      controller.bid(BidType.clubs);
                    } else if (hasBid(BidType.diamonds)) {
                      controller.bid(BidType.diamonds);
                    } else if (hasBid(BidType.hearts)) {
                      controller.bid(BidType.hearts);
                    } else {
                      controller.bid(BidType.spades);
                    }
                  },
                      "Sun",
                      hasBid(BidType.clubs) ||
                          hasBid(BidType.diamonds) ||
                          hasBid(BidType.hearts) ||
                          hasBid(BidType.spades)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child:
                      _buildBidButton(() {}, "Hokom", hasBid(BidType.noTrumps)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child:
                      _buildBidButton(() {}, "Double", hasBid(BidType.double)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child:
                      _buildBidButton(() {}, "ReD", hasBid(BidType.reDouble)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildAnnounceButton(() {}, "Seq3",
                      announcesTypes.contains(AnnounceType.SequenceOf3)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildAnnounceButton(() {}, "Seq4",
                      announcesTypes.contains(AnnounceType.SequenceOf4)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildAnnounceButton(() {}, "Seq5",
                      announcesTypes.contains(AnnounceType.SequenceOf5)),
                ),
              ],
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
