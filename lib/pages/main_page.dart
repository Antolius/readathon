import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:readathon/pages/main_page_tabs.dart';
import 'package:readathon/redux/state.dart';

class MainPage extends StatelessWidget {
  const MainPage();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, MainPageTab>(
      distinct: true,
      converter: (store) => store.state.mainPageState.activeTab,
      builder: (context, activeTab) => new _MainPageContents(activeTab),
    );
  }
}

class _MainPageContents extends StatelessWidget {
  final MainPageTab activeTab;

  const _MainPageContents(this.activeTab);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Readathon'),
      ),
      body: _buildBody(context),
      bottomNavigationBar: new MainTabs(),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (activeTab) {
      case MainPageTab.BOOKS:
        return new Center(
          child: new Text('BOOKS'),
        );
      case MainPageTab.GOALS:
        return new Center(
          child: new Text('GOALS'),
        );
      case MainPageTab.STATS:
        return new Center(
          child: new Text('STATS'),
        );
    }
  }
}
