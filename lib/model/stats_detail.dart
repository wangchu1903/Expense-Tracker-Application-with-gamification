import 'package:expense_manager/model/transaction_model.dart';

class StatsDetail {
  final List<Data> transaction;
  final String title;
  final double total;
  StatsDetail(this.transaction, this.title, this.total);
}
