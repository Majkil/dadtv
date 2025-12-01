// lib/models/iptv_countries.dart
import 'dart:convert';
import 'package:objectbox/objectbox.dart';


class IptvCountry {
  final String name;
  final String code;
  final List<String> languages;
  final String flag;

  const IptvCountry({
    required this.name,
    required this.code,
    required this.languages,
    required this.flag,
  });

  IptvCountry copyWith({
    String? name,
    String? code,
    List<String>? languages,
    String? flag,
  }) {
    return IptvCountry(
      name: name ?? this.name,
      code: code ?? this.code,
      languages: languages ?? this.languages,
      flag: flag ?? this.flag,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'languages': languages,
      'flag': flag,
    };
  }

  factory IptvCountry.fromMap(Map<String, dynamic> map) {
    return IptvCountry(
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
      'IptvCountry(name: $name, code: $code, languages: $languages, flag: $flag)';

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
      name.hashCode ^ code.hashCode ^ languages.hashCode ^ flag.hashCode;

  // Example instance from your input
  static const IptvCountry canada = IptvCountry(
    name: 'Canada',
    code: 'CA',
    languages: const ['eng', 'fra'],
    flag: '🇨🇦',
  );
}