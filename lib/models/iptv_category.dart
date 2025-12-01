import 'dart:convert';
import 'package:objectbox/objectbox.dart';

import '../objectbox.g.dart';

@Entity()
class IptvCategoryModel {
  @Id()
  int id;
  final String sId;
  final String name;
  final String? description;

  IptvCategoryModel({
    this.id = 0,
    required this.sId,
    required this.name,
    this.description,
  });

  factory IptvCategoryModel.fromMap(Map<String, dynamic> map) {
    return IptvCategoryModel(
      sId: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
    );
  }

  factory IptvCategoryModel.fromJson(String source) =>
      IptvCategoryModel.fromMap(json.decode(source));
}
