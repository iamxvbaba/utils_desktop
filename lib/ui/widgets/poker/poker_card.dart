import 'package:flutter/material.dart';
import 'package:skeleton_desktop/ui/widgets/poker/model.dart';

import '../../theme/app_theme_extensions.dart';
import 'poker_icons.dart';

class PokerCard extends StatelessWidget {
  final Rank rank;
  final Suit suit;

  const PokerCard(this.rank, this.suit, {super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 100, width: 80),
      child: AspectRatio(
        aspectRatio: 2.25 / 3.5,
        child: LayoutBuilder(
          builder: (_, constraints) => DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(constraints.maxWidth * 0.1),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    rank.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: suit.color(),
                      fontSize: constraints.maxHeight * 0.475,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: constraints.maxHeight * 0.05,
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Icon(
                        PokerIcons.heart,
                        color: suit.color(),
                        size: constraints.maxHeight * 0.475,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
