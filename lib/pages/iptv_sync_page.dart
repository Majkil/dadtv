import 'package:dadtv/models/iptv_channel_model.dart';
import 'package:dadtv/models/iptv_streams_model.dart';
import 'package:dadtv/services/db_service.dart';
import 'package:dadtv/services/iptv_git_service.dart';
import 'package:flutter/material.dart';

class IptvSyncPage extends StatefulWidget {
  const IptvSyncPage({super.key});

  @override
  State<IptvSyncPage> createState() => _IptvSyncPageState();
}

class _IptvSyncPageState extends State<IptvSyncPage> {
  bool _loading = true;
  Future<int>? _channelCountFuture;
  Future<int>? _streamsCountFuture;
  Stream<int>? _syncing;
  @override
  void initState() {
    super.initState();
    _channelCountFuture = _getChannelCount();
  }

  Future<int> _getChannelCount() async {
    final db = await DbService.instance;
    return db.getAllChannels().length;
  }

  Future<int> _getSteamCount() async {
    final db = await DbService.instance;
    return db.getAllStreams().length;
  }

  Future<void> _startSync() {
    return IptvGitService().refreshData();
  }

  Future<void> _loadItems() async {
    setState(() => _loading = true);
    try {
      // Adjust method name if your service uses a different API.
      final service = IptvGitService();
      service.refreshData();
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
        ),
        children: [
          MaterialButton(
            color: Colors.white,

            onPressed: () async {
              await _loadItems();
            },
            child: Text('Refresh iptv channels'),
          ),
          // StreamBuilder(
          //   stream: _syncing,
          //   builder: (context, snapshot) {
          //     return Container(
          //       color: Colors.blue,
          //       child: Text('refreshing status: ${snapshot.data}'),
          //     );
          //   },
          // ),
          Container(
            color: Colors.yellow,
            child: FutureBuilder<int>(
              future: _streamsCountFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('streams: ${snapshot.data}');
                }
              },
            ),
          ),
          Container(
            color: Colors.pink,
            child: FutureBuilder<int>(
              future: _channelCountFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('Channels: ${snapshot.data}');
                }
              },
            ),
          ),
          MaterialButton(
            color: Colors.white,
            onPressed: () {
              setState(() {
                _channelCountFuture = _getChannelCount();
                _streamsCountFuture = _getSteamCount();
              });
            },
            child: Text('Refresh iptv channels counts'),
          ),

          MaterialButton(
            color: Colors.white,
            onPressed: () async {
              (await DbService.instance).clear();
            },
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }
}
