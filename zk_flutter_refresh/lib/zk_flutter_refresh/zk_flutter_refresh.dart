import 'package:flutter/material.dart';

class ZKFlutterRefresh extends StatefulWidget {
  ZKFlutterRefresh({
    this.controller,
    this.itemBuilder,
    this.pulldownRefreshCallback,
    this.pullupRefreshCallback,
    this.refreshKey,
  });
  final ZKRefreshController controller;
  final IndexedWidgetBuilder itemBuilder;
  final RefreshCallback pulldownRefreshCallback;
  final RefreshCallback pullupRefreshCallback;
  final Key refreshKey;

  @override
  _ZKFlutterRefreshState createState() => _ZKFlutterRefreshState(
        controller: controller,
        itemBuilder: itemBuilder,
        pulldownRefreshCallback: pulldownRefreshCallback,
        pullupRefreshCallback: pullupRefreshCallback,
        refreshKey: key,
      );
}

class _ZKFlutterRefreshState extends State<ZKFlutterRefresh> {
  _ZKFlutterRefreshState({
    this.controller,
    this.itemBuilder,
    this.pulldownRefreshCallback,
    this.pullupRefreshCallback,
    this.refreshKey,
  });
  final ZKRefreshController controller;
  final IndexedWidgetBuilder itemBuilder;
  final RefreshCallback pulldownRefreshCallback;
  final RefreshCallback pullupRefreshCallback;
  final Key refreshKey;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      bool reachBottom = _scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent;
      if (reachBottom && controller.needLoadMore) {
        pullupRefreshCallback?.call();
      }
    });
  }

  int _calcCountOfItems() {
    return controller.dataSource.length + 2;
  }

  Widget _buildRefreshFooter() {
    return Container(
      color: Colors.red,
      constraints: BoxConstraints.expand(height: 70),
      child: Text('正在刷新...'),
    );
  }

  Widget _buildCell(int index) {
    int countOfModels = controller.dataSource.length;
    if (countOfModels == 0) {
      return null;
    }
    // Refresh footer
    if (index == _calcCountOfItems() - 1) {
      return _buildRefreshFooter();
    } else {
      return itemBuilder(context, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: pulldownRefreshCallback,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildCell(index);
        },
        itemCount: _calcCountOfItems(),
        controller: _scrollController,
      ),
    );
  }
}

/// Controls some state of refresh
class ZKRefreshController {
  List<dynamic> dataSource = List();
  bool needLoadMore = true;
}
