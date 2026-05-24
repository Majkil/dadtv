// /lib/models/iptv_model.dart
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:objectbox/objectbox.dart';

import '../objectbox.g.dart';

@Entity()
class IptvChannelModel {
  @Id()
  int id; // ObjectBox id
  
  final String uid; // original string id from source
  
  final String name;
  final List<String> altNames;
  final String? network;
  final List<String> owners;
  final String? country;
  final List<String> categories;
  final bool isNsfw;
  // @Property(type: PropertyType.date)
  // final DateTime? launched;
  // @Property(type: PropertyType.date)
  // final DateTime? closed;
  final String? replacedBy;
  final String? website;

  IptvChannelModel({
    this.id = 0,
    required this.uid,
    required this.name,
    this.altNames = const [],
    this.network,
    this.owners = const [],
    this.country,
    this.categories = const [],
    this.isNsfw = false,
    // this.launched,
    // this.closed,
    this.replacedBy,
    this.website,
  });

  factory IptvChannelModel.fromMap(Map<String, dynamic> map) {
    List<String> toStringList(dynamic v) {
      if (v == null) return [];
      if (v is List) return v.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
      return [v.toString()];
    }

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      try {
        return DateTime.tryParse(v.toString());
      } catch (_) {
        return null;
      }
    }

    return IptvChannelModel(
      uid: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      altNames: toStringList(map['alt_names'] ?? map['altNames']),
      network: map['network']?.toString(),
      owners: toStringList(map['owners']),
      country: map['country']?.toString(),
      categories: toStringList(map['categories']),
      isNsfw: map['is_nsfw'] is bool ? map['is_nsfw'] : (map['isNsfw'] == null ? false : (map['is_nsfw'] ?? map['isNsfw']).toString().toLowerCase() == 'true'),
      // launched: _parseDate(map['launched']),
      // closed: _parseDate(map['closed']),
      replacedBy: map['replaced_by']?.toString() ?? map['replacedBy']?.toString(),
      website: map['website']?.toString(),
    );
  }

  factory IptvChannelModel.fromJson(String source) => IptvChannelModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'name': name,
      'alt_names': altNames,
      'network': network,
      'owners': owners,
      'country': country,
      'categories': categories,
      'is_nsfw': isNsfw,
      // 'launched': launched?.toIso8601String(),
      // 'closed': closed?.toIso8601String(),
      'replaced_by': replacedBy,
      'website': website,
    };
  }

  String toJson() => json.encode(toMap());

  IptvChannelModel copyWith({
    int? id,
    String? uid,
    String? name,
    List<String>? altNames,
    String? network,
    List<String>? owners,
    String? country,
    List<String>? categories,
    bool? isNsfw,
    DateTime? launched,
    DateTime? closed,
    String? replacedBy,
    String? website,
  }) {
    return IptvChannelModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      altNames: altNames ?? this.altNames,
      network: network ?? this.network,
      owners: owners ?? this.owners,
      country: country ?? this.country,
      categories: categories ?? this.categories,
      isNsfw: isNsfw ?? this.isNsfw,
      // launched: launched ?? this.launched,
      // closed: closed ?? this.closed,
      replacedBy: replacedBy ?? this.replacedBy,
      website: website ?? this.website,
    );
  }

  @override
  String toString() => 'IptvModel(id: $id, name: $name, country: $country, website: $website)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! IptvChannelModel) return false;
    final listEq = const DeepCollectionEquality().equals;
    return other.uid == uid &&
        other.name == name &&
        listEq(other.altNames, altNames) &&
        other.network == network &&
        listEq(other.owners, owners) &&
        other.country == country &&
        listEq(other.categories, categories) &&
        other.isNsfw == isNsfw &&
        // other.launched == launched &&
        // other.closed == closed &&
        other.replacedBy == replacedBy &&
        other.website == website;
  }

  @override
  int get hashCode {
    final listHash = const DeepCollectionEquality().hash;
    return Object.hashAll([
      uid,
      name,
      listHash(altNames),
      network,
      listHash(owners),
      country,
      listHash(categories),
      isNsfw,
      // launched,
      // closed,
      replacedBy,
      website,
    ]);
  }
}