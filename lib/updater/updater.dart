// IMPORT PACKAGE

import 'package:flutter/material.dart';
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Updater extends StatefulWidget {
  const Updater({super.key});

  @override
  State<Updater> createState() => _UpdaterState();
}

class _UpdaterState extends State<Updater> {
  late OtaEvent currentEvent;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    // tryOtaUpdate();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> tryOtaUpdate() async {
    // UpdaterService us = UpdaterService();

    // var url = await us.checkForNewVersion();
    // RUN OTA UPDATE
    // START LISTENING FOR DOWNLOAD PROGRESS REPORTING EVENTS
    try {
      print('ABI Platform: ${await OtaUpdate().getAbi()}');
      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
      OtaUpdate()
          .execute(
        "https://github.com/Majkil/dadtv/releases/download/first/app-release.apk",
        // OPTIONAL
        destinationFilename: 'app-release.apk',
        //OPTIONAL, ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
        // sha256checksum:
        //     "d6da28451a1e15cf7a75f2c3f151befad3b80ad0bb232ab15c20897e54f21478",
      )
          .listen(
        (OtaEvent event) {
          setState(() => currentEvent = event);
        },
      );
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update app'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(_packageInfo.toString()),
            // Text(
            //     'OTA status: ${currentEvent.status} : ${currentEvent.value} \n'),
          ],
        ),
      ),
    );
  }
}
