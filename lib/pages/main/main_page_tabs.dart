import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:readathon/app_sections.dart';
import 'package:readathon/readathon_theme.dart';
import 'package:readathon/redux/actions/actions.dart';
import 'package:readathon/redux/state.dart';
import 'package:redux/redux.dart';

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

class _ViewModel {
  final AppSection activeSection;
  final void Function(AppSection newTab) onTabTuch;

  _ViewModel(this.activeSection, this.onTabTuch);

  static _ViewModel from(Store<AppState> store) =>
      new _ViewModel(store.state.mainPageState.activeSection, (newTab) =>
          store.dispatch(new MainPageTabSelectedAction(newTab)),);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _ViewModel &&
              runtimeType == other.runtimeType &&
              activeSection == other.activeSection;

  @override
  int get hashCode => activeSection.hashCode;
}

class _MainTabsContent extends StatelessWidget {
  final _ViewModel model;

  const _MainTabsContent(this.model);


  @override
  Widget build(BuildContext context) {
    return new BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      currentIndex: model.activeSection.index,
      onTap: (index) => model.onTabTuch(AppSection.values[index]),
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
          icon: new Icon(Icons.book),
          title: new Text('Books'),
          backgroundColor: ReadathonTheme.COLORS[AppSection.BOOKS],
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.flag),
          title: new Text('Goals'),
          backgroundColor: ReadathonTheme.COLORS[AppSection.GOALS],
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.timeline),
          title: new Text('Stats'),
          backgroundColor: ReadathonTheme.COLORS[AppSection.STATS],
        ),
      ],
    );
  }
}
