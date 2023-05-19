import 'package:dadtv/app_lifecycle/app_lifecycle.dart';
import 'package:dadtv/pages/player.dart';
import 'package:dadtv/pages/select_stream.dart';
import 'package:dadtv/services/stream_url_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
        child: MultiProvider(
            providers: [
          ChangeNotifierProvider<StreamUrlService>(
            create: (context) => StreamUrlService(),
            lazy: false,
          ),
        ],
            child: MaterialApp.router(
              title: 'TV malti',
              themeMode: ThemeMode.system,
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
            path: 'play',
            builder: (context, state) {
              String url = (state.extra as Map)['url']; //state.params[':url']!;
              return Player(
                streamUrl: url,
              );
            })
      ])
]);
