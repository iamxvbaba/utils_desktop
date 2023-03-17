import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../ui/widgets/poker/model.dart';
import '../../ui/widgets/poker/poker_card.dart';
import '../../ui/widgets/poker/poker_played_card.dart';

class PokerTableController extends GetxController {
  RxString myPosition = 'south'.obs;
  RxList<PlayedCardModel> playedCards = RxList.empty(growable: true); // 已出的牌
  late WebSocketChannel channel;
  RxList<BidType> bids = RxList.empty(growable: false);
  RxList<AnnounceType> announces = RxList.empty(growable: false);

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

      int index =
          playedCards.indexWhere((e) => e.rank == f.rank && e.suit == f.suit);

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
        (index) => Padding(
            padding: const EdgeInsets.only(left: 5),
            child: PokerCard(cards[index].rank, cards[index].suit, () {
              _addPlayedCard(PlayedCardModel(
                  myPosition.value, cards[index].rank, cards[index].suit));
            })));
  }

  List<Widget> buildPlayedCards() {
    return List.generate(
        playedCards.length,
        (index) => PokerPlayedCard(
            playedCards[index].name,
            PokerCard(playedCards[index].rank, playedCards[index].suit, () {}),
            playedCards[index].win));
  }

  connect() {
    String token =
        "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NzkyOTQ4MDMsIlVzZXJJZCI6MjM3NjYsIlN0YXR1cyI6MCwiR2VuZGVyIjowLCJBdXRoS2V5IjowLCJJcCI6IiIsIkRldmljZUlkIjoiIiwiUmVsZWFzZSI6ZmFsc2UsIkF1ZGl0IjpmYWxzZX0.kOVwPKsXk1YVYM4SD1fiRVJ5nr2P_q7ZkkkWr8GlTWV6A8wwqgqEorTo58gQWhfFl57ZkzY4fcM20u-jrSJ3SilWTi7U9JVr7rxC8OCBFbfTUtIThYOAE1bSoFZtpvmyMkkWp7AQZyugCXy2G6KqMrg2KRHqs8NbvplYsXniHEkpErNSj-2g9fLUkhasIKnPPXgdIPPSPuTAn9DuABD72zNP4mW7GzNkkibf5Hi_sVyECvBorZjpPhmSy5guR87B7ThuKqi3B8IM6rvmZwHR4jH3207BrjtKK3OO-0r15wp4O-G11tS7Wqqwvxym7DUevdOdlzk01Mz2f7a9ZhIKRQ";
    String gameId = "123";
    channel = WebSocketChannel.connect(
      Uri.parse('ws://127.0.0.1:8080/baloot?token=$token&game_id=$gameId'),
    );
    channel.stream.listen((message) {
      print('收到ws消息:$message');
      Proto p = Proto.fromJson(json.decode(message));
      switch (p.op) {
        case 1001: // 出价通知
          bids.value = bidTypeFromStrings(p.data!['bid']);
          print("收到出价通知:${bids.obs}");
          break;
        case 1002: // 声明通知
          announces.value = announceTypeFromStrings(p.data!['announces']);
          print("收到声明通知:${announces.value}");
          break;
        case 1003: // 出牌通知
      }
    });
  }

  // 出价操作
  bid(BidType bt) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bid'] = bt.value;
    print('出价:$bt');

    channel.sink
        .add(Proto(op: 1001, seq: 0, ver: 0, os: 0, data: data).toJsonString());

    bids.clear();
  }
}

class Proto {
  int op;
  int seq;
  int ver;
  int os;
  Map<String, dynamic>? data;

  Proto(
      {required this.op,
      required this.seq,
      required this.ver,
      required this.os,
      required this.data});

  factory Proto.fromJson(Map<String, dynamic> data) {
    return Proto(
      op: data['op'] as int,
      seq: data['seq'] as int,
      ver: data['ver'] as int,
      os: data['os'] as int,
      data: data['data'] == null ? null : data['data'] as Map<String, dynamic>,
    );
  }

  String toJsonString() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['op'] = op;
    data['seq'] = seq;
    data['ver'] = ver;
    data['os'] = os;
    data['data'] = this.data;
    return json.encode(data);
  }
}
