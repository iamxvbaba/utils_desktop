import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_desktop/ui/widgets/poker/poker_icons.dart';

/// An enum that expresses a suit of [Card].
enum Suit {
  club,
  diamond,
  heart,
  spade;

  /// Returns a [Suit] from an integer value. The value must be 0 <= value <= 3.
  factory Suit.fromIndex(int index) {
    assert(index >= 0 && index <= 3);

    switch (index) {
      case 0:
        return Suit.club;
      case 1:
        return Suit.diamond;
      case 2:
        return Suit.heart;
      default:
        return Suit.spade;
    }
  }

  /// Returns 1-char length string.
  ///
  /// ```dart
  /// assert(Suit.heart.toString(), "h");
  /// assert(Suit.diamond.toString(), "d");
  /// ```
  @override
  String toString() {
    switch (this) {
      case Suit.spade:
        return '♠';
      case Suit.heart:
        return '♥';
      case Suit.diamond:
        return '♦';
      default:
        return '♣';
    }
  }
  IconData icon() {
    switch (this) {
      case Suit.spade:
        return PokerIcons.spade;
      case Suit.heart:
        return PokerIcons.heart;
      case Suit.diamond:
        return PokerIcons.diamond;
      default:
        return PokerIcons.club;
    }
  }
  Color color() {
    switch (this) {
      case Suit.spade:
        return Colors.black;
      case Suit.heart:
        return Colors.redAccent;
      case Suit.diamond:
        return Colors.redAccent;
      default:
        return Colors.black;
    }
  }
}

enum Rank {
  seven(0),
  eight(1),
  nine(2),
  ten(3),
  jack(4),
  queen(5),
  king(6),
  ace(7);

  const Rank(this.power);

  /// Returns a [Suit] from an integer value. The value must be 0 <= value <= 12.
  factory Rank.fromIndex(int index) {
    assert(index >= 0 && index <= 7);

    switch (index) {
      case 0:
        return Rank.seven;
      case 1:
        return Rank.eight;
      case 2:
        return Rank.nine;
      case 3:
        return Rank.ten;
      case 4:
        return Rank.jack;
      case 5:
        return Rank.queen;
      case 6:
        return Rank.king;
      case 7:
        return Rank.ace;
      default:
        return Rank.king;
    }
  }

  /// Returns power of the rank.
  final int power;

  /// Returns 1-char length string represents the rank.
  @override
  String toString() {
    switch (this) {
      case Rank.ace:
        return 'A';
      case Rank.seven:
        return '7';
      case Rank.eight:
        return '8';
      case Rank.nine:
        return '9';
      case Rank.ten:
        return '10';
      case Rank.jack:
        return 'J';
      case Rank.queen:
        return 'Q';
      default:
        return 'K';
    }
  }
}

class PlayedCardModel {
  final int position;
  final Rank rank;
  final Suit suit;
  bool win = false;

  PlayedCardModel(this.position, this.rank, this.suit);
}

enum BidType {
  pass,
  clubs,
  diamonds,
  hearts,
  spades,
  confirmHokum, // 确认牌型时 选择为Hokum
  sun,
  ashkal,
  reverseSun, // 被人反转之后 接收反转为Sun
  confirmSun, // // 确认牌型时 选择为Sun
  double,
  triple,
  reDouble,
  gahwa,
  lock,
  open;

  factory BidType.fromIndex(int val) {
    switch (val) {
      case 0:
        return BidType.pass;
      case 1 << 0:
        return BidType.clubs;
      case 1 << 1:
        return BidType.diamonds;
      case 1 << 2:
        return BidType.hearts;
      case 1 << 3:
        return BidType.spades;
      case 1 << 4:
        return BidType.confirmHokum;
      case 1 << 5:
        return BidType.sun;
      case 1 << 6:
        return BidType.ashkal;
      case 1 << 7:
        return BidType.reverseSun;
      case 1 << 8:
        return BidType.confirmSun;
      case 1 << 9:
        return BidType.double;
      case 1 << 10:
        return BidType.triple;
      case 1 << 11:
        return BidType.reDouble;
      case 1 << 12:
        return BidType.gahwa;
      case 1 << 13:
        return BidType.lock;
      case 1 << 14:
        return BidType.open;
      default:
        return BidType.pass;
    }
  }
}

extension BidTypeExtension on BidType {
  String get value {
    switch (this) {
      case BidType.pass:
        return "Pass";
      case BidType.clubs:
        return "Clubs";
      case BidType.diamonds:
        return "Diamonds";
      case BidType.hearts:
        return "Hearts";
      case BidType.spades:
        return "Spades";
      case BidType.confirmHokum:
        return "ConfirmHokum";
      case BidType.sun:
        return "Sun";
      case BidType.ashkal:
        return "Ashkal";
      case BidType.reverseSun:
        return "ReverseSun";
      case BidType.confirmSun:
        return "ConfirmSun";
      case BidType.double:
        return "Double";
      case BidType.triple:
        return "Triple";
      case BidType.reDouble:
        return "ReDouble";
      case BidType.gahwa:
        return "Gahwa";
      case BidType.lock:
        return "Lock";
      case BidType.open:
        return "Open";
      default:
        return "";
    }
  }

  List<BidType> toList() {
    List<BidType> bts = [];
    if (has(BidType.pass)) {
      bts.add(BidType.pass);
    }
    if (has(BidType.clubs)) {
      bts.add(BidType.clubs);
    }
    if (has(BidType.diamonds)) {
      bts.add(BidType.diamonds);
    }
    if (has(BidType.hearts)) {
      bts.add(BidType.hearts);
    }
    if (has(BidType.spades)) {
      bts.add(BidType.spades);
    }
    if (has(BidType.confirmHokum)) {
      bts.add(BidType.confirmHokum);
    }
    if (has(BidType.double)) {
      bts.add(BidType.double);
    }
    if (has(BidType.reDouble)) {
      bts.add(BidType.reDouble);
    }
    return bts;
  }

  bool has(BidType bt2) {
    return (index & bt2.index) == bt2.index;
  }

  int get intValue {
    switch (this) {
      case BidType.pass:
        return 0;
      case BidType.clubs:
        return 1 << 0;
      case BidType.diamonds:
        return 1 << 1;
      case BidType.hearts:
        return 1 << 2;
      case BidType.spades:
        return 1 << 3;
      case BidType.confirmHokum:
        return 1 << 4;
      case BidType.sun:
        return 1 << 5;
      case BidType.ashkal:
        return 1 << 6;
      case BidType.reverseSun:
        return 1 << 7;
      case BidType.confirmSun:
        return 1 << 8;
      case BidType.double:
        return 1 << 9;
      case BidType.triple:
        return 1 << 10;
      case BidType.reDouble:
        return 1 << 11;
      case BidType.gahwa:
        return 1 << 12;
      case BidType.lock:
        return 1 << 13;
      case BidType.open:
        return 1 << 14;
      default:
        return 0;
    }
  }
}

List<BidType> bidTypeList(List list) {
  List<BidType> bts = [];
  for (var element in list) {
    bts.add(BidType.fromIndex(element));
  }
  return bts;
}

// AnnounceType 玩家声明牌型对应可获得积分
enum AnnounceType {
  Baloot,
  SequenceOf3,
  SequenceOf4,
  SequenceOf5,
  SequenceOf6,
  SequenceOf7,
  SequenceOf8,
  FourOfAKind,
  FourNines,
  FourJacks
}

extension AnnounceTypeExtension on AnnounceType {
  String toShortString() {
    switch (this) {
      case AnnounceType.Baloot:
        return "Baloot";
      case AnnounceType.SequenceOf3:
        return "SequenceOf3";
      case AnnounceType.SequenceOf4:
        return "SequenceOf4";
      case AnnounceType.SequenceOf5:
        return "SequenceOf5";
      case AnnounceType.SequenceOf6:
        return "SequenceOf6";
      case AnnounceType.SequenceOf7:
        return "SequenceOf7";
      case AnnounceType.SequenceOf8:
        return "SequenceOf8";
      case AnnounceType.FourOfAKind:
        return "FourOfAKind";
      case AnnounceType.FourNines:
        return "FourNines";
      case AnnounceType.FourJacks:
        return "FourJacks";
      default:
        throw Exception('Invalid announce type');
    }
  }
}

AnnounceType announceTypeFromString(String val) {
  switch (val) {
    case 'Baloot':
      return AnnounceType.Baloot;
    case 'SequenceOf3':
      return AnnounceType.SequenceOf3;
    case 'SequenceOf4':
      return AnnounceType.SequenceOf4;
    case 'SequenceOf5':
      return AnnounceType.SequenceOf5;
    case 'SequenceOf6':
      return AnnounceType.SequenceOf6;
    case 'SequenceOf7':
      return AnnounceType.SequenceOf7;
    case 'SequenceOf8':
      return AnnounceType.SequenceOf8;
    case 'FourOfAKind':
      return AnnounceType.FourOfAKind;
    case 'FourNines':
      return AnnounceType.FourNines;
    case 'FourJacks':
      return AnnounceType.FourJacks;
    default:
      throw Exception('Invalid announce type');
  }
}

List<AnnounceType> announceTypeFromStrings(List<dynamic> val) {
  List<AnnounceType> list = [];
  for (var element in val) {
    list.add(announceTypeFromString(element));
  }
  return list;
}
