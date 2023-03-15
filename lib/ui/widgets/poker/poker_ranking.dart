import 'package:flutter/material.dart';

// 积分榜
class PokerRanking extends StatelessWidget {
  final int ewTotalPoint; // 整盘东西方游戏积分
  final int ewPoint; // 当前轮东西方吃的积分

  final int snTotalPoint;

  final int snPoint;

  const PokerRanking(
      this.ewTotalPoint, this.ewPoint, this.snTotalPoint, this.snPoint,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('EW'),
              Text(ewTotalPoint.toString()),
              const Text('  :  '),
              Text(snTotalPoint.toString()),
              const Text('SN'),
            ],
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[300],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(ewPoint.toString()),
              const Text(' | '),
              Text(snPoint.toString()),
            ],
          )
        ],
      ),
    );
  }
}
