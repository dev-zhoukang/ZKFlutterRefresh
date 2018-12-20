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
  List _dataSource;
  bool _isLoading = false;
  Random _random;
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  ZKRefreshController _refreshController;

  Future<Null> refreshData() async {
    if (_isLoading) {
      return null;
    }
    _isLoading = true;
    _refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    var newDatas = List.generate(_random.nextInt(30), (index) => '条目：$index');
    setState(() {
      _refreshController.needLoadMore = newDatas != null;
    });
    _isLoading = false;
    return null;
  }

  @override
  void initState() {
    super.initState();
    _dataSource = [];
    _random = Random();
    _refreshController = ZKRefreshController();
    refreshData();
  }

  void _showRefreshLoading() {
    Future.delayed(const Duration(seconds: 0), () {
      _refreshKey.currentState.show().then((e) {});
      return true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshController.dataSource =
        List.generate(_random.nextInt(20), (index) => '条目: $index');
    if (_refreshController.dataSource.length == 0) {
      _showRefreshLoading();
    }
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
        pulldownRefreshCallback: refreshData,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_refreshController.dataSource[index]),
          );
        },
      ),
      // body: RefreshIndicator(
      //   key: _refreshKey,
      //   onRefresh: refreshData,
      //   child: ListView.builder(
      //     itemCount: _dataSource?.length,
      //     itemExtent: 50.0,
      //     itemBuilder: (context, index) {
      //       return ListTile(
      //         title: Text(_dataSource[index]),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}
