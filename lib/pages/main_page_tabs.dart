import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:readathon/redux/actions/actions.dart';
import 'package:readathon/redux/state.dart';
import 'package:redux/redux.dart';

enum MainPageTab { BOOKS, GOALS, STATS }

class MainTabs extends StatelessWidget {
  const MainTabs();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: _ViewModel.from,
      builder: (context, model) => new _MainTabsContent(model),
    );
  }
}

class _MainTabsContent extends StatelessWidget {
  final _ViewModel model;

  const _MainTabsContent(this.model);


  @override
  Widget build(BuildContext context) {
    return new BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: model.activeTab.index,
      onTap: (index) => model.onTabTuch(MainPageTab.values[index]),
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
          icon: new Icon(Icons.book),
          title: new Text('Books'),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.flag),
          title: new Text('Goals'),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.timeline),
          title: new Text('Stats'),
        ),
      ],
    );
  }
}

class _ViewModel {
  final MainPageTab activeTab;
  final void Function(MainPageTab newTab) onTabTuch;

  _ViewModel(this.activeTab, this.onTabTuch);

  static _ViewModel from(Store<AppState> store) =>
      new _ViewModel(store.state.mainPageState.activeTab, (newTab) =>
          store.dispatch(new MainPageTabSelectedAction(newTab)),);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _ViewModel &&
              runtimeType == other.runtimeType &&
              activeTab == other.activeTab;

  @override
  int get hashCode => activeTab.hashCode;
}
