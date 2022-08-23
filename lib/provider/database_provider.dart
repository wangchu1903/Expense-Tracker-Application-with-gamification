import 'package:expense_manager/dao/transaction_dao.dart';
import 'package:riverpod/riverpod.dart';

/// A state provider for database dao
final databaseProvider = StateProvider<TransactionDao?>((ref) {
  return null;
});
