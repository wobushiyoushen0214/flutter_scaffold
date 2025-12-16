/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 17:22:03
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:22:09
 * @Description: 
 */
import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String categoryId;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String note;

  @HiveField(5)
  final String type; // 'income' or 'expense'

  TransactionModel({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.note,
    required this.type,
  });
}
