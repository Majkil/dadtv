// import 'package:dio/dio.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UpdaterService {
//   final Future<SharedPreferences> instanceFuture =
//       SharedPreferences.getInstance();
//   String prefsKey = 'current_version';
//   String url = 'https://majkil.github.io/test.json';
//   setVersion(version) async {
//     final prefs = await instanceFuture;
//     prefs.setString(prefsKey, version);
//   }

//   Future<String> getVersion() async {
//     // final packageInfo = await PackageInfo.fromPlatform();
//     // print(packageInfo);
//     // return packageInfo.version;
//     final prefs = await instanceFuture;
//     return prefs.getString(prefsKey)!;
//   }

//   Future<String?> checkForNewVersion() async {
//     var current = await getVersion();
//     Dio dio = Dio();

//     return dio.get<String>(url).then((value) {
//       print(value.data);
//       return (value.data as Map<String, dynamic>)["releaseUrl"];
//     });
//     //return null;
//   }
// }
