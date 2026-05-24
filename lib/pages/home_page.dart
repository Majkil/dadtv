import 'dart:ffi';

import 'package:dadtv/models/iptv_category.dart';
import 'package:dadtv/services/db_service.dart';
import 'package:dadtv/services/iptv_git_service.dart';
import 'package:flutter/material.dart';

class StreamsCategories extends StatefulWidget {
  const StreamsCategories({super.key});

  @override
  State<StreamsCategories> createState() => _StreamsCategoriesState();
}

class _StreamsCategoriesState extends State<StreamsCategories> {
  late List<IptvCategoryModel> _data;

  @override
  initState() {
    super.initState();

    _data = [];
  }

  sync() async {
    var temp = await IptvGitService().fetchCategories();
    var db = await DbService.instance;
    db.addAllCategories(temp);
  }

  fetch() async {
    var db = await DbService.instance;
    setState(() {
      _data = db.getAllCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            MaterialButton(
              onPressed: fetch,
              color: Colors.amber,
              child: Text('get'),
            ),
            MaterialButton(
              onPressed: sync,
              color: Colors.amber,
              child: Text('sync'),
            ),

            Container(color: Colors.white, child: Text('${_data}')),
          ],
        ),
      ),
    );
  }
}
