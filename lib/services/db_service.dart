// /lib/services/db_service.dart

import 'package:dadtv/models/iptv_category.dart';
import 'package:dadtv/models/iptv_countries.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/iptv_channel_model.dart';
import '../models/iptv_streams_model.dart';
import '../objectbox.g.dart';

// NOTE: This file expects ObjectBox code generation.
// After adding entities, run:
//   dart run build_runner build
// This generates `objectbox.g.dart` used to open the store.

class DbService {
  DbService._internal();

  late final Store _store;
  static final DbService instance = DbService._internal();

  DbService._create(this._store) {
    _channelsBox = Box<IptvChannelModel>(_store);
    _streamsBox = Box<IptvStreamModel>(_store);
    _countriesBox = Box<IptvCountry>(_store);
    _categoryBox = Box<IptvCategoryModel>(_store);
    _favoritesBox = Box<IptvStreamModel>(_store);
  }

  static Future<DbService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "obx-tv"));

    return DbService._create(store);
  }

  // Add any additional
  late final Box<IptvChannelModel> _channelsBox;
  late final Box<IptvStreamModel> _streamsBox;
  late final Box<IptvStreamModel> _favoritesBox;
  late final Box<IptvCategoryModel> _categoryBox;
  late final Box<IptvCountry> _countriesBox;

  // Channels
  List<IptvChannelModel> getAllChannels() => _channelsBox.getAll();

  Future<List<IptvChannelModel>> getChannelsByCountry(String country) async {
    QueryBuilder<IptvChannelModel> query = _channelsBox.query(
      IptvChannelModel_.country.equals(country),
    );
    var channels = query.build().find();
  
    return channels;
  }

  void addAllChannels(List<IptvChannelModel> items) {
    _channelsBox.putMany(items);
  }

  void addAllCountries(List<IptvCountry> items) {
    _countriesBox.putMany(items);
  }

  void addAllCategories(List<IptvCategoryModel> items) {
    _categoryBox.putMany(items);
  }

  void deleteAllChannels() {
    final ids = _channelsBox.getAll().map((e) => e.id).toList();
    _channelsBox.removeMany(ids);
  }

  // Streams
  List<IptvStreamModel> getAllStreams() => _streamsBox.getAll();

  void addAllStreams(List<IptvStreamModel> items) {
    _streamsBox.putMany(items);
  }

  void deleteAllStreams() {
    final ids = _streamsBox.getAll().map((e) => e.id).toList();
    _streamsBox.removeMany(ids);
  }

  // Favorites
  List<IptvStreamModel> getFavorites() => _favoritesBox.getAll();

  void addFavourites(List<IptvStreamModel> items) {
    _favoritesBox.putMany(items);
  }

  void deleteAllFavourites() {
    final ids = _favoritesBox.getAll().map((e) => e.id).toList();
    _favoritesBox.removeMany(ids);
  }
}
