import 'package:flutter/material.dart';

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

class SuitParseFailureException implements Exception {
  SuitParseFailureException({required this.value});

  final String value;

  String get message => '$value is not a valid string as a rank.';
}

enum Rank {
  ace(12),
  deuce(0),
  trey(1),
  four(2),
  five(3),
  six(4),
  seven(5),
  eight(6),
  nine(7),
  ten(8),
  jack(9),
  queen(10),
  king(11);

  const Rank(this.power);

  /// Returns a [Suit] from an integer value. The value must be 0 <= value <= 12.
  factory Rank.fromIndex(int index) {
    assert(index >= 0 && index <= 12);

    switch (index) {
      case 0:
        return Rank.ace;
      case 1:
        return Rank.deuce;
      case 2:
        return Rank.trey;
      case 3:
        return Rank.four;
      case 4:
        return Rank.five;
      case 5:
        return Rank.six;
      case 6:
        return Rank.seven;
      case 7:
        return Rank.eight;
      case 8:
        return Rank.nine;
      case 9:
        return Rank.ten;
      case 10:
        return Rank.jack;
      case 11:
        return Rank.queen;
      default:
        return Rank.king;
    }
  }

  /// Parses a char (1-charactor-length string) and returns a [Rank]. The value must be one of `"A"`, `"2"`, `"3"`, `"4"`, `"5"`, `"6"`, `"7"`, `"8"`, `"9"`, `"T"`, `"J"`, `"Q"` or `"K"`.
  ///
  /// ```dart
  /// assert(Rank.parse("A") == Rank.ace);
  /// assert(Rank.parse("8") == Rank.eight);
  /// ```
  ///
  /// If any string else is given, this throws a [RankParseFailureException].
  ///
  /// ```dart
  /// Rank.parse("a");      // throws RankParseFailureException
  /// Rank.parse("eight");  // throws RankParseFailureException
  /// ```
  factory Rank.parse(String value) {
    switch (value) {
      case 'A':
        return Rank.ace;
      case '2':
        return Rank.deuce;
      case '3':
        return Rank.trey;
      case '4':
        return Rank.four;
      case '5':
        return Rank.five;
      case '6':
        return Rank.six;
      case '7':
        return Rank.seven;
      case '8':
        return Rank.eight;
      case '9':
        return Rank.nine;
      case '10':
        return Rank.ten;
      case 'J':
        return Rank.jack;
      case 'Q':
        return Rank.queen;
      case 'K':
        return Rank.king;
      default:
        throw RankParseFailureException(value);
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
      case Rank.deuce:
        return '2';
      case Rank.trey:
        return '3';
      case Rank.four:
        return '4';
      case Rank.five:
        return '5';
      case Rank.six:
        return '6';
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

class RankParseFailureException implements Exception {
  RankParseFailureException(this.value);

  final String value;

  String get message => '$value is not a valid string as a rank.';
}

class PlayedCardModel {
  final String name;
  final Rank rank;
  final Suit suit;
  bool win = false;

  PlayedCardModel(this.name, this.rank, this.suit);
}

enum BidType {
  pass,
  clubs,
  diamonds,
  hearts,
  spades,
  noTrumps,
  double,
  reDouble
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
      case BidType.noTrumps:
        return "NoTrumps";
      case BidType.double:
        return "Double";
      case BidType.reDouble:
        return "ReDouble";
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
    if (has(BidType.noTrumps)) {
      bts.add(BidType.noTrumps);
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

  int get index {
    switch (this) {
      case BidType.pass:
        return 0;
      case BidType.clubs:
        return 1 << 0; // ♣️
      case BidType.diamonds:
        return 1 << 1; // ♦️
      case BidType.hearts:
        return 1 << 2; // ♥️
      case BidType.spades:
        return 1 << 3; // ♠️
      case BidType.noTrumps:
        return 1 << 4;
      case BidType.double:
        return 1 << 5;
      case BidType.reDouble:
        return 1 << 6;
      default:
        return -1;
    }
  }
}

BidType bidTypeFromString(String val) {
  switch (val) {
    case 'Pass':
      return BidType.pass;
    case 'Clubs':
      return BidType.clubs;
    case 'Diamonds':
      return BidType.diamonds;
    case 'Hearts':
      return BidType.hearts;
    case 'Spades':
      return BidType.spades;
    case 'NoTrumps':
      return BidType.noTrumps;
    case 'Double':
      return BidType.double;
    case 'ReDouble':
      return BidType.reDouble;
  }
  return BidType.pass;
}

List<BidType> bidTypeFromStrings(List<dynamic> vals) {
  List<BidType> bts = [];
  for (var element in vals) {
    bts.add(bidTypeFromString(element));
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
