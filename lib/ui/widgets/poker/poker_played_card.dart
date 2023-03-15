import 'package:flutter/material.dart';
import 'package:skeleton_desktop/ui/widgets/poker/poker_card.dart';

class PokerPlayedCardList extends StatelessWidget {
  final List<Widget> children;

  const PokerPlayedCardList(this.children, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children,
    );
  }
}

class PokerPlayedCard extends StatelessWidget {
  final String name; // 出牌者
  final PokerCard card; // 出的牌
  final bool win;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        win
            ? const Text(
                'Winner!!!',
                style: TextStyle(color: Colors.redAccent),
              )
            : Container(),
        Text(
          name,
          style: TextStyle(color: win ? Colors.redAccent : Colors.black),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: card,
        )
      ],
    );
  }

  const PokerPlayedCard(this.name, this.card, this.win, {super.key});
}
