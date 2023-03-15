import 'package:flutter/material.dart';

class PokerPlayer extends StatelessWidget {
  final String name;
  final bool isSelf;
  final List<Widget>? children;

  final bool isBid; // 展示出价按钮
  final bool isAnnounce; // 展示声明

  const PokerPlayer(
      {required this.name,
      this.isSelf = false,
      this.children,
      this.isBid = false,
      this.isAnnounce = false,
      super.key});

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
                  child: _buildBidButton(() {}, "Sun", isBid),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildBidButton(() {}, "Hokom", isBid),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildBidButton(() {}, "Double", isBid),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildBidButton(() {}, "ReD", isBid),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildAnnounceButton(() {}, "Seq3", isAnnounce),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildAnnounceButton(() {}, "Seq4", isAnnounce),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildAnnounceButton(() {}, "Seq5", isAnnounce),
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
