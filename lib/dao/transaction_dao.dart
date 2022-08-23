// dao/person_dao.dart

import 'package:expense_manager/model/transaction_model.dart';
import 'package:floor/floor.dart';

@dao
abstract class TransactionDao {
  @Query('SELECT * FROM Data')
  Future<List<Data>> findAllTransaction();

  @Query('SELECT * FROM Data WHERE date = :date')
  Future<List<Data>> findTransactionByDate(String date);

  @insert
  Future<void> insertData(Data data);

  @delete
  Future<void> deleteAll(List<Data> data);
}
