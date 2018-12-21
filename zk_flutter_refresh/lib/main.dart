import 'package:flutter/material.dart';
import 'dart:math';
import 'package:zk_flutter_refresh/zk_flutter_refresh/zk_flutter_refresh.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  final String _appTitle = 'FlutterRefresh';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _appTitle,
      home: HomePage(
        title: _appTitle,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;
  HomePage({Key key, this.title}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Random _random;
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  ZKRefreshController _refreshController;
  int _page = 0;

  Future<Null> requestData() async {
    _refreshKey.currentState?.show(atTop: true);
    await Future.delayed(Duration(seconds: 2));
    var newDatas =
        List.generate(_random.nextInt(30), (index) => '这是第$_page页的第$index个条目');
    if (_page == 0) {
      _refreshController.dataSource.clear();
    }
    setState(() {
    _refreshController.dataSource.addAll(newDatas);
      _refreshController.needLoadMore = newDatas != null;
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    _random = Random();
    _refreshController = ZKRefreshController();
    _showRefreshLoading();
    requestData();
  }

  void _showRefreshLoading() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _refreshKey.currentState.show().then(((e) {}));
      return true;
    });
  }

  @override
  void didChangeDependencies() {
    if (_refreshController.dataSource.length == 0) {
      _showRefreshLoading();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ZKFlutterRefresh(
        refreshKey: _refreshKey,
        controller: _refreshController,
        pulldownRefreshCallback: () {
          _page = 0;
          return requestData();
        },
        pullupRefreshCallback: () {
          _page++;
          return requestData();
        },
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(_refreshController.dataSource[index]),
            ),
          );
        },
      ),
    );
  }
}
