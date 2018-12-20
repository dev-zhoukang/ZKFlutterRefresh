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
  bool _isLoading = false;
  Random _random;
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  ZKRefreshController _refreshController;
  int _page = 0;

  Future<Null> requestData() async {
    if (_isLoading) {
      return null;
    }
    _isLoading = true;
    _refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    var newDatas = List.generate(_random.nextInt(30), (index) => '这是第$_page页的第$index个条目');
    if (_page == 0) {
      _refreshController.dataSource.clear();
    }
    _refreshController.dataSource.addAll(newDatas);

    setState(() {
      _refreshController.needLoadMore = newDatas != null;
    });
    _isLoading = false;
    return null;
  }

  @override
  void initState() {
    super.initState();
    _random = Random();
    _refreshController = ZKRefreshController();
    requestData();
  }

  void _showRefreshLoading() {
    Future.delayed(const Duration(seconds: 0), () {
      _refreshKey.currentState.show().then((e) {});
      return true;
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _refreshController.dataSource =
  //       List.generate(_random.nextInt(20), (index) => '条目: $index');
  //   if (_refreshController.dataSource.length == 0) {
  //     _showRefreshLoading();
  //   }
  // }

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
