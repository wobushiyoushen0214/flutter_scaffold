/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 17:21:54
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:21:56
 * @Description: 
 */
import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type; // 'income' or 'expense'

  @HiveField(3)
  final int iconCode;

  @HiveField(4)
  final int colorValue;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.iconCode,
    required this.colorValue,
  });
}
