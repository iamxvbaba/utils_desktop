import 'dart:convert';

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