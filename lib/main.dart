import 'package:dadtv/app_lifecycle/app_lifecycle.dart';
import 'package:dadtv/helpers/size_helper.dart';
import 'package:dadtv/pages/iptv_git_list_page.dart';

import 'package:dadtv/pages/player.dart';
import 'package:dadtv/pages/select_stream.dart';
import 'package:dadtv/pages/vod_day_page.dart';
import 'package:dadtv/services/db_service.dart';
import 'package:dadtv/services/one_vod.dart';
import 'package:dadtv/services/smashtv.dart';
import 'package:dadtv/services/stream_url_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

late DbService dbService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dbService = await DbService.create();
  runApp(const MyApp());
  // var tempUrl = UpdaterService().checkForNewVersion();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WakelockPlus.enable();
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
          ),
          ChangeNotifierProvider<SmashTvService>(
            create: (context) => SmashTvService(),
            lazy: false,
          ),
        ],
        child: MaterialApp.router(
          title: 'TV malti',
          theme: appTheme(context),
          themeMode: ThemeMode.dark,
          routeInformationParser: appRouter.routeInformationParser,
          routeInformationProvider: appRouter.routeInformationProvider,
          routerDelegate: appRouter.routerDelegate,
        ),
      ),
    );
  }
}

GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ChannelSelection(
        key: GlobalKey(),
        playlistTest: context.watch<StreamUrlService>().streams,
        showExtras: true,
      ),
      routes: [
        GoRoute(
          path: 'onevod',
          builder: (context, state) {
            DateTime date = (state.extra as Map)['day'] as DateTime;
            return OneVodDayPicker(day: date);
          },
        ),
        GoRoute(
          path: 'smashchannels',
          builder: (context, state) => ChannelSelection(
            showExtras: false,
            playlistTest: context.watch<SmashTvService>().smashPlaylist,
          ),
        ),
        GoRoute(
          path: 'play',
          builder: (context, state) {
            String url = (state.extra as Map)['url']; //state.params[':url']!;
            return Player(streamUrl: url);
          },
        ),
        GoRoute(
          path: 'iptv',
          builder: (context, state) {
            return IptvGitListPage();
          },
        ),
      ],
    ),
  ],
);

ThemeData appTheme(context) => ThemeData(
  scaffoldBackgroundColor: Colors.black54,
  elevatedButtonTheme: ElevatedButtonThemeData(style: appButtonStyle(context)),
  filledButtonTheme: FilledButtonThemeData(style: appButtonStyle(context)),
);

ButtonStyle appButtonStyle(context) => ButtonStyle(
  foregroundColor: WidgetStateProperty.all(Colors.black),
  shape: WidgetStateProperty.all<OutlinedBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  ),
  backgroundColor: WidgetStateProperty.all<Color>(Colors.redAccent.shade200),
  overlayColor: WidgetStateProperty.all<Color>(Colors.amber),
  textStyle: WidgetStateProperty.all<TextStyle>(
    GoogleFonts.robotoCondensed().copyWith(
      fontSize: ResponsiveSizer.of(context).fontSize(4),
      fontWeight: FontWeight.bold,
    ),
  ),
);

// TextTheme tt = GoogleFonts.jostTextTheme();
