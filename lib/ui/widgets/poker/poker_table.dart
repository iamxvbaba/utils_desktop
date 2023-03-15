import 'package:flutter/material.dart';
import 'package:skeleton_desktop/ui/widgets/poker/poker_card.dart';
import 'package:skeleton_desktop/ui/widgets/poker/model.dart';
import 'package:skeleton_desktop/ui/widgets/poker/poker_ranking.dart';

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
class PokerTableLayout extends StatefulWidget {
  const PokerTableLayout({super.key});

  @override
  State<PokerTableLayout> createState() => _PokerTableLayoutState();
}

class _PokerTableLayoutState extends State<PokerTableLayout> {
  String myPosition = 'south';
  List<PlayedCardModel> playedCards = []; // 已出的牌
  List<PlayedCardModel> cards = [
    PlayedCardModel('south', Rank.king, Suit.spade),
    PlayedCardModel('south', Rank.jack, Suit.club),
    PlayedCardModel('south', Rank.ace, Suit.heart),
    PlayedCardModel('south', Rank.king, Suit.diamond),
    PlayedCardModel('south', Rank.ace, Suit.spade),
    PlayedCardModel('south', Rank.ten, Suit.club),
    PlayedCardModel('south', Rank.nine, Suit.heart),
    PlayedCardModel('south', Rank.eight, Suit.diamond),
  ]; // 手上未出的牌
  _initCards() {
    cards.addAll([
      PlayedCardModel('south', Rank.king, Suit.spade),
      PlayedCardModel('south', Rank.jack, Suit.club),
      PlayedCardModel('south', Rank.ace, Suit.heart),
      PlayedCardModel('south', Rank.king, Suit.diamond),
      PlayedCardModel('south', Rank.ace, Suit.spade),
      PlayedCardModel('south', Rank.ten, Suit.club),
      PlayedCardModel('south', Rank.nine, Suit.heart),
      PlayedCardModel('south', Rank.eight, Suit.diamond),
    ]);
  }

  int ewTotalPoint = 152; // 整盘东西方游戏积分
  int ewPoint = 11; // 当前轮东西方吃的积分

  int snTotalPoint = 45;
  int snPoint = 43;

  List<Widget> _buildCards() {
    return List.generate(
        cards.length,
            (index) =>
            Padding(
                padding: const EdgeInsets.only(left: 5),
                child: PokerCard(cards[index].rank, cards[index].suit, () {
                  _addPlayedCard(PlayedCardModel(
                      myPosition, cards[index].rank, cards[index].suit));
                })));
  }

  List<Widget> _buildPlayedCards() {
    return List.generate(
        playedCards.length,
            (index) =>
            PokerPlayedCard(
                playedCards[index].name,
                PokerCard(
                    playedCards[index].rank, playedCards[index].suit, () {}),
                playedCards[index].win));
  }

  _addPlayedCard(PlayedCardModel cm) {
    if (playedCards.length >= 4) {
      return;
    }
    setState(() {
      cards.removeWhere((e) => e.rank == cm.rank && e.suit == cm.suit);
      playedCards.add(cm);
    });

    // 已经出了4张牌，选出最大的一张牌 并在5s后清空
    if (playedCards.length >= 4) {
      // 不改变原来的排序找出最带的一张
      List<PlayedCardModel> data = List.from(playedCards);
      data.sort((a, b) => a.rank.index - b.rank.index);
      PlayedCardModel f = data.first;
      data.clear();

      int index = playedCards.indexWhere((e) =>
      e.rank == f.rank && e.suit == f.suit);

      playedCards[index].win = true;

      setState(() {});
      // 5s后清空
      Future.delayed(const Duration(seconds: 5)).then((value) {
        playedCards.clear();
        setState(() {});
      });
    }

    // 再添加一些牌，用于测试
    if (cards.isEmpty) {
      setState(() {
        _initCards();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 20,
            right: 20,
            child: PokerRanking(ewTotalPoint, ewPoint, snTotalPoint, snPoint)),
        Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const PokerPlayer(
                  name: "west",
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PokerPlayer(
                      name: "north",
                    ),
                    PokerPlayedCardList(_buildPlayedCards()),
                    PokerPlayer(
                      name: 'south',
                      isSelf: true,
                      isBid: true,
                      isAnnounce: true,
                      children: _buildCards(),
                    )
                  ],
                ),
                const PokerPlayer(
                  name: "east",
                ),
              ],
            ))
      ],
    );
  }
}
