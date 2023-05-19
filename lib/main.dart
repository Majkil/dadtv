import 'package:dadtv/app_lifecycle/app_lifecycle.dart';
import 'package:dadtv/helpers/size_helper.dart';

import 'package:dadtv/pages/player.dart';
import 'package:dadtv/pages/select_stream.dart';
import 'package:dadtv/pages/vod_day_page.dart';
import 'package:dadtv/services/one_vod.dart';
import 'package:dadtv/services/stream_url_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return AppLifecycleObserver(
        child: MultiProvider(
            providers: [
          ChangeNotifierProvider<StreamUrlService>(
            create: (context) => StreamUrlService(),
            lazy: false,
          ),
          ChangeNotifierProvider<OneVoDService>(
            create: (context) => OneVoDService(),
            lazy: false,
          )
        ],
            child: MaterialApp.router(
              title: 'TV malti',
              theme: appTheme(context),
              themeMode: ThemeMode.dark,
              routeInformationParser: appRouter.routeInformationParser,
              routeInformationProvider: appRouter.routeInformationProvider,
              routerDelegate: appRouter.routerDelegate,
            )));
  }
}

GoRouter appRouter = GoRouter(routes: [
  GoRoute(
      path: '/',
      builder: (context, state) => const ChannelSelection(),
      routes: [
        GoRoute(
          path: 'vod',
          builder: (context, state) => const VoDDayPage(),
        ),
        GoRoute(
            path: 'play',
            builder: (context, state) {
              String url = (state.extra as Map)['url']; //state.params[':url']!;
              return Player(
                streamUrl: url,
              );
            })
      ])
]);

ThemeData appTheme(context) => ThemeData(
    scaffoldBackgroundColor: Colors.black54,
    elevatedButtonTheme:
        ElevatedButtonThemeData(style: appButtonStyle(context)),
    filledButtonTheme: FilledButtonThemeData(style: appButtonStyle(context)),
    buttonTheme: ButtonThemeData(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))));

ButtonStyle appButtonStyle(context) => ButtonStyle(
    foregroundColor: MaterialStateProperty.all(Colors.black),
    shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
    backgroundColor:
        MaterialStateProperty.all<Color>(Colors.redAccent.shade200),
    overlayColor: MaterialStateProperty.all<Color>(Colors.amber),
    textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
        fontSize: ResponsiveSizer.of(context).fontSize(4),
        fontWeight: FontWeight.bold)));
