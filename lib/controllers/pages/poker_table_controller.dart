import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/widgets/poker/model.dart';
import '../../ui/widgets/poker/poker_card.dart';
import '../../ui/widgets/poker/poker_played_card.dart';

class PokerTableController extends GetxController {
  RxString myPosition = 'south'.obs;
  RxList<PlayedCardModel> playedCards = RxList.empty(growable: true); // 已出的牌

  RxList<PlayedCardModel> cards = RxList.from([
    PlayedCardModel('south', Rank.king, Suit.spade),
    PlayedCardModel('south', Rank.jack, Suit.club),
    PlayedCardModel('south', Rank.ace, Suit.heart),
    PlayedCardModel('south', Rank.king, Suit.diamond),
    PlayedCardModel('south', Rank.ace, Suit.spade),
    PlayedCardModel('south', Rank.ten, Suit.club),
    PlayedCardModel('south', Rank.nine, Suit.heart),
    PlayedCardModel('south', Rank.eight, Suit.diamond),
  ]);

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

  RxInt ewTotalPoint = 152.obs; // 整盘东西方游戏积分
  RxInt ewPoint = 11.obs; // 当前轮东西方吃的积分

  RxInt snTotalPoint = 45.obs;
  RxInt snPoint = 43.obs;


  _addPlayedCard(PlayedCardModel cm) {
    if (playedCards.length >= 4) {
      return;
    }
    cards.removeWhere((e) => e.rank == cm.rank && e.suit == cm.suit);
    playedCards.add(cm);

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

      // 5s后清空
      Future.delayed(const Duration(seconds: 5)).then((value) {
        playedCards.clear();
      });
    }

    // 再添加一些牌，用于测试
    if (cards.isEmpty) {
      _initCards();
    }
  }

  List<Widget> buildCards() {
    return List.generate(
        cards.length,
            (index) =>
            Padding(
                padding: const EdgeInsets.only(left: 5),
                child: PokerCard(cards[index].rank, cards[index].suit, () {
                  _addPlayedCard(PlayedCardModel(
                      myPosition.value, cards[index].rank, cards[index].suit));
                })));
  }

  List<Widget> buildPlayedCards() {
    return List.generate(
        playedCards.length,
            (index) =>
            PokerPlayedCard(
                playedCards[index].name,
                PokerCard(
                    playedCards[index].rank, playedCards[index].suit, () {}),
                playedCards[index].win));
  }
}
