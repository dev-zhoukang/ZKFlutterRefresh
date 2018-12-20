import 'package:flutter/material.dart';
import 'dart:math';

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
  Random _random;
  var _refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshData() async {
    _refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _dataSource = List.generate(_random.nextInt(10), (index) => '条目：$index');
    });
  }

  @override
  void initState() {
    super.initState();
    _dataSource = [];
    _random = Random();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    ZKBaseTest test = ZKBaseTest();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: refreshData,
        child: ListView.builder(
          itemCount: _dataSource?.length,
          itemExtent: 50.0,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_dataSource[index]),
            );
          },
        ),
      ),
    );
  }
}

abstract class ZKBaseTest {
  factory ZKBaseTest({String name}) {
    return ZKBaseTest();
  }
  const ZKBaseTest.constructor() : super();
}

class ZKTest extends ZKBaseTest {
  ZKTest() : super.constructor();
}
