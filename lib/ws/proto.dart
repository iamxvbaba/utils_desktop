import 'dart:convert';

class Proto {
  Op op;
  int seq;

  Map<String, dynamic>? data;

  Proto({required this.op, this.seq = 0, required this.data});

  factory Proto.fromJson(Map<String, dynamic> data) {
    return Proto(
      op: Op.fromIndex(data['op'] as int),
      seq: data['seq'] as int,
      data: data['data'] == null ? null : data['data'] as Map<String, dynamic>,
    );
  }

  String toJsonString() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['op'] = op.value;
    data['seq'] = seq;
    data['data'] = this.data;
    return json.encode(data);
  }
}

enum Op {
  ping,
  showCard,
  getCard,
  getShowCard,
  bid,
  bided,
  allPass,
  endGetCard,
  announce,
  announced,
  action,
  actioned,
  trickWinner;

  factory Op.fromIndex(int index) {
    switch (index) {
      case 1:
        return Op.ping;
      case 2:
        return Op.showCard;
      case 3:
        return Op.getCard;
      case 4:
        return Op.getShowCard;
      case 5:
        return Op.bid;
      case 6:
        return Op.bided;
      case 7:
        return Op.allPass;
      case 8:
        return Op.endGetCard;
      case 9:
        return Op.announce;
      case 10:
        return Op.announced;
      case 11:
        return Op.action;
      case 12:
        return Op.actioned;
      case 13:
        return Op.trickWinner;
      default:
        throw Exception("Invalid integer value for Op enum: $index");
    }
  }

}

extension OpValue on Op {
  int get value {
    switch (this) {
      case Op.ping:
        return 1;
      case Op.showCard:
        return 2;
      case Op.getCard:
        return 3;
      case Op.getShowCard:
        return 4;
      case Op.bid:
        return 5;
      case Op.bided:
        return 6;
      case Op.allPass:
        return 7;
      case Op.endGetCard:
        return 8;
      case Op.announce:
        return 9;
      case Op.announced:
        return 10;
      case Op.action:
        return 11;
      case Op.actioned:
        return 12;
      case Op.trickWinner:
        return 13;
      default:
        throw Exception('Invalid PokerOp');
    }
  }
}
