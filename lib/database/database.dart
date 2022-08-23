import 'dart:async';
import 'package:expense_manager/dao/transaction_dao.dart';
import 'package:expense_manager/model/transaction_model.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Data])
abstract class AppDatabase extends FloorDatabase {
  TransactionDao get transactionDao;
}
