class Budget {
  Budget({
    required this.status,
    required this.data,
  });
  late final String status;
  late final List<Data> data;

  Budget.fromJson(Map<String, dynamic> json) {
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

class Data {
  Data({
    required this.id,
    required this.title,
    required this.amount,
    required this.totalAmount,
    required this.createdBy,
  });
  late final String id;
  late final String title;
  late final Amount amount;
  late final TotalAmount totalAmount;
  late final String createdBy;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    amount = Amount.fromJson(json['amount']);
    totalAmount = TotalAmount.fromJson(json['total_amount']);
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['title'] = title;
    _data['amount'] = amount.toJson();
    _data['total_amount'] = totalAmount.toJson();
    _data['created_by'] = createdBy;
    return _data;
  }
}

class Amount {
  Amount({
    required this.numberDecimal,
  });
  late final String numberDecimal;

  Amount.fromJson(Map<String, dynamic> json) {
    numberDecimal = json['\$numberDecimal'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['\$numberDecimal'] = numberDecimal;
    return _data;
  }
}

class TotalAmount {
  TotalAmount({
    required this.numberDecimal,
  });
  late final String numberDecimal;

  TotalAmount.fromJson(Map<String, dynamic> json) {
    numberDecimal = json['\$numberDecimal'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['\$numberDecimal'] = numberDecimal;
    return _data;
  }
}
