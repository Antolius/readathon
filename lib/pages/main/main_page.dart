import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:readathon/app_sections.dart';
import 'package:readathon/pages/books/add_book.dart';
import 'package:readathon/pages/books/books_list.dart';
import 'package:readathon/pages/main/main_page_tabs.dart';
import 'package:readathon/redux/state.dart';

class MainPage extends StatelessWidget {
  const MainPage();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, AppSection>(
      distinct: true,
      converter: (store) => store.state.mainPageState.activeSection,
      builder: (context, activeTab) => new _MainPageContents(activeTab),
    );
  }
}

class _MainPageContents extends StatelessWidget {
  final AppSection activeSection;

  const _MainPageContents(this.activeSection);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Readathon'),
      ),
      body: _buildBody(context),
      bottomNavigationBar: new MainTabs(),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (activeSection) {
      case AppSection.BOOKS:
        return const BooksList();
      case AppSection.GOALS:
        return new Center(
          child: new Text('GOALS'),
        );
      case AppSection.STATS:
        return new Center(
          child: new Text('STATS'),
        );
      default:
        throw new StateError('unknown type of app section: $activeSection');
    }
  }

  Widget _buildFAB(BuildContext context) {
    switch (activeSection) {
      case AppSection.BOOKS:
        return new FloatingActionButton(
          child: new Icon(
            Icons.plus_one,
            color: Colors.white,
          ),
          tooltip: 'Add new book',
          onPressed: () => AddBookModal.visit(context),
        );
      default:
        return null;
    }
  }
}
