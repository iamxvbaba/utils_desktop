import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_desktop/ws/proto.dart';
import 'package:skeleton_desktop/ws/websocket.dart';

import '../../ui/widgets/poker/model.dart';
import '../../ui/widgets/poker/poker_card.dart';
import '../../ui/widgets/poker/poker_played_card.dart';

class PokerTableController extends GetxController {
  RxInt myPosition = 1.obs;

  RxList<PlayedCardModel> trumpCards = RxList.from([]); // 王牌,只会有一张
  RxList<PlayedCardModel> cards = RxList.from([]); // 手中的牌
  RxList<PlayedCardModel> playedCards = RxList.empty(growable: true); // 已出的牌

  PlayedCardModel? trumpCard; // 王牌
  RxInt trumpOwnerPosition = 0.obs; // 王牌所属用户

  RxList<BidType> availableBids = RxList.empty(growable: false);
  RxList<AnnounceType> announces = RxList.empty(growable: false);

  RxInt currentBidPlayer = 0.obs; // 当前出价的用户
  BidType? currentBid; // 当前出价

  RxInt currentActionPlayer = 0.obs; // 当前出牌者
  RxInt currentTrickWinner = 0.obs; // 回合赢的人

  RxInt contractPlayer = 0.obs; // 最终出价人
  RxBool sun = false.obs; // sun 玩法
  late WebSocket _ws;

  connect() {
    _ws.connect();
  }

  @override
  void onInit() {
    super.onInit();
    _ws = WebSocket(
        baseUrl: "ws://127.0.0.1:8080/baloot",
        gameId: "123",
        token:
            "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MTEwNzY3OTMsIlVzZXJJZCI6MjM3NjYsIlN0YXR1cyI6MCwiR2VuZGVyIjowLCJBdXRoS2V5IjowLCJJcCI6IiIsIkRldmljZUlkIjoiIiwiUmVsZWFzZSI6ZmFsc2UsIkF1ZGl0IjpmYWxzZX0.EDBE_ICRoNiKkiMSR9t5cgm-gRruMFlDBJ6F1QiDy51SqgUvTO4ZhIP7oLOgo80h1mNmSnfDUGfC9JlFHicy18_UpKoe3giWVo4qV9j6-yVKLvRWYCx_2CmIfQ8a1MEc8V85U_61GH7fEKn54WnUlN4ok4z5psjjDIEiEcxpKMy8WmqJOwhbijJP92PH8IMzJDYloLfTHEUGtUbOrzMWrkX5p0efdqxGo73PuSVsDV6lO_RB1YEqNxigds9C4Cwzu32XRSh1RIx3jJ5Qw9DRlYnjMW3HXjnl9yAeiIMHZbCWMpDY0qba-lonQYsXuneYqY-HtKS5OFMjhl9gTf9x9Q",
        handler: _handleProto);
  }

  RxInt ewTotalPoint = 152.obs; // 整盘东西方游戏积分
  RxInt ewPoint = 11.obs; // 当前轮东西方吃的积分

  RxInt snTotalPoint = 45.obs;
  RxInt snPoint = 43.obs;

  // 开始下一轮全部清空
  _nextRound() {
    availableBids.clear();
    announces.clear();
    trumpCards.clear();
    cards.clear();
    playedCards.clear();
    ewPoint.value = 0;
    snPoint.value = 0;
    trumpOwnerPosition.value = 0;
    currentBidPlayer.value = 0;
  }

  List<Widget> buildCards() {
    return List.generate(
        cards.length,
        (index) => Padding(
            padding: const EdgeInsets.only(left: 5),
            child: PokerCard(
                rank: cards[index].rank,
                suit: cards[index].suit,
                available: cards[index].available,
                callback: () {
                  if (!cards[index].available) {
                    Get.snackbar('error', '这张牌不能出');
                    return;
                  }
                  action(cards[index].hashCode);
                })));
  }

  List<Widget> buildPlayedCards() {
    // 优先展示王牌
    if (trumpCards.isNotEmpty) {
      return [
        Padding(
            padding: const EdgeInsets.only(left: 5),
            child: PokerPlayedCard('王牌',
                PokerCard(rank: trumpCards[0].rank, suit: trumpCards[0].suit))),
      ];
    }

    return List.generate(
        playedCards.length,
        (index) => PokerPlayedCard(
            playedCards[index].position.toString(),
            PokerCard(
                rank: playedCards[index].rank, suit: playedCards[index].suit)));
  }

  void _handleProto(Proto p) {
    switch (p.op) {
      case Op.getCard:
        List jsonList = p.data!['cards'];
        cards.value = jsonList
            .map((card) => PlayedCardModel(
                myPosition.value,
                Rank.fromIndex(card['type']),
                Suit.fromIndex(card['suit']),
                card['hashCode']))
            .toList();
        break;
      case Op.endGetCard:
        List jsonList = p.data!['cards'];
        cards.value = jsonList
            .map((card) => PlayedCardModel(
                myPosition.value,
                Rank.fromIndex(card['type']),
                Suit.fromIndex(card['suit']),
                card['hashCode']))
            .toList();
        sun.value = p.data!['sun'];
        availableBids.clear();
        currentBidPlayer.value = 0;
        break;
      case Op.getShowCard: // 确认收下公共牌
        var player = p.data!['player'];
        print('用户$player将公共牌收入');
        trumpCard = trumpCards[0];
        trumpOwnerPosition.value = player;
        trumpCards.clear();
        break;
      case Op.showCard:
        var card = p.data!['card'];
        trumpCards.add(PlayedCardModel(0, Rank.fromIndex(card['type']),
            Suit.fromIndex(card['suit']), card['hashCode']));
        break;
      case Op.bid: // 出价通知
        availableBids.value = bidTypeList(p.data!['bid']);
        break;
      case Op.bided: // 用户出价信息
        var bid = BidType.fromIndex(p.data!['bid']);
        contractPlayer.value = p.data!['contract_player']; // 买牌者
        currentBid = bid;
        currentBidPlayer.value = p.data!['player'];
        print('当前出价用户:${currentBidPlayer.value}');
        break;
      case Op.announce: // 声明通知
        announces.value = announceTypeFromStrings(p.data!['announces']);
        print("收到声明通知:${announces}");
        break;
      case Op.allPass:
        print('此轮轮空');
        _nextRound();
        break;
      case Op.action: // 要出牌了
        List jsonList = p.data!['cards'];
        // 出牌者
        currentActionPlayer.value = p.data!['player'];
        List<PlayedCardModel> newCards = [];
        // 可出的牌
        for (var card in cards) {
          var available = false;
          for (var availableCard in jsonList) {
            if (card.hashCode == availableCard['hashCode']) {
              available = true;
              print('可用出牌{${card.suit} ${card.rank}');
            }
          }
          card.available = available;
          newCards.add(card);
        }
        cards.value = newCards;
        break;
      case Op.actioned: // 有人出牌了
        List jsonList = p.data!['actions'];
        playedCards.value = jsonList
            .map((action) => PlayedCardModel(
                action['player'],
                Rank.fromIndex(action['card']['type']),
                Suit.fromIndex(action['card']['suit']),
                action['card']['hashCode']))
            .toList();
        break;
      case Op.trickWinner:
        currentTrickWinner.value = p.data!['winner'];
        print('${p.data!['winner']} 牌最大');
        // 5s延迟后，将currentTrickWinner清空
        5.delay(() {
          currentTrickWinner.value = 0;
        });
    }
  }

  // 出价操作
  bid(BidType bt) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bid'] = bt.intValue;
    _ws.send(Proto(op: Op.bid, data: data));
    availableBids.clear();
  }

  // 出牌操作
  action(int hashCode) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hashCode'] = hashCode;
    _ws.send(Proto(op: Op.action, data: data));
    cards.removeWhere((e) => e.hashCode == hashCode);
    availableBids.clear();
  }
}
