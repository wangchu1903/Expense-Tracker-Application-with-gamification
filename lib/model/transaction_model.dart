import 'package:floor/floor.dart';

class Transaction {
  Transaction({
    required this.status,
    required this.data,
  });
  late final String status;
  late final List<Data> data;

  Transaction.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

@entity
class Data {
  Data({
    required this.id,
    required this.payeeName,
    required this.type,
    required this.amount,
    required this.date,
    required this.createdBy,
  });
  @primaryKey
  late final String id;
  late final String payeeName;
  late final String type;
  late final String amount;
  late final String date;
  late final String createdBy;
  late final String file;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    payeeName = json['payee_name'];
    type = json['type'];
    amount = json['amount'];
    date = json['date'];
    createdBy = json['created_by'];
    file = json['file'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['payee_name'] = payeeName;
    _data['type'] = type;
    _data['amount'] = amount;
    _data['date'] = date;
    _data['created_by'] = createdBy;
    return _data;
  }
}
