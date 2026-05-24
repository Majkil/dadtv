// lib/models/iptv_countries.dart
import 'dart:convert';
import 'package:objectbox/objectbox.dart';

import '../objectbox.g.dart';

@Entity()
class IptvCountry {
  @Id()
  int id;
  final String name;
  final String code;
  final List<String> languages;
  final String flag;

  IptvCountry({
    this.id = 0,
    required this.name,
    required this.code,
    required this.languages,
    required this.flag,
  });

  IptvCountry copyWith({
    int? id,
    String? name,
    String? code,
    List<String>? languages,
    String? flag,
  }) {
    return IptvCountry(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      languages: languages ?? this.languages,
      flag: flag ?? this.flag,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'languages': languages,
      'flag': flag,
    };
  }

  factory IptvCountry.fromMap(Map<String, dynamic> map) {
    return IptvCountry(
      id: map['id'] ?? 0,
      name: map['name'] as String,
      code: map['code'] as String,
      languages: map['languages'] != null
          ? List<String>.from(map['languages'] as Iterable)
          : const <String>[],
      flag: map['flag'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory IptvCountry.fromJson(String source) =>
      IptvCountry.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'IptvCountry(id: $id, name: $name, code: $code, languages: $languages, flag: $flag)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final IptvCountry o = other as IptvCountry;
    if (name != o.name || code != o.code || flag != o.flag) return false;
    if (languages.length != o.languages.length) return false;
    for (var i = 0; i < languages.length; i++) {
      if (languages[i] != o.languages[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ code.hashCode ^ languages.hashCode ^ flag.hashCode;

  // Example instance from your input
  static IptvCountry canada = IptvCountry(
    name: 'Canada',
    code: 'CA',
    languages: ['eng', 'fra'],
    flag: '🇨🇦',
  );
}