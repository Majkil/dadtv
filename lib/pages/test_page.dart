import 'package:dadtv/components/big_buttons.dart';
import 'package:dadtv/services/db_service.dart';
import 'package:dadtv/services/iptv_git_service.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          ActionButton(
            onPressed: () {
              IptvGitService().refreshData()
            },
            btnText: 'Refresh Database',
          ),
          StreamBuilder(stream:  IptvGitService().refreshData(), builder: (context, snapshot) {
            return Text( "${snapshot.data}");
          },)
                 
          
          
          
        ],
      ),
    );
  }
}
