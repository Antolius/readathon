import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readathon/app_sections.dart';
import 'package:readathon/pages/pages.dart';
import 'package:readathon/readathon_theme.dart';
import 'package:readathon/redux/actions/actions.dart';
import 'package:readathon/redux/middleware.dart';
import 'package:readathon/redux/reducers/reducers.dart';
import 'package:readathon/redux/state.dart';
import 'package:readathon/repositories/file_repository.dart';
import 'package:redux/redux.dart';

void main() => runApp(new ReadathonApp());

class ReadathonApp extends StatelessWidget {
  final _store = new Store<AppState>(
    appStateReducer,
    initialState: new AppState.init(),
    middleware: createStoreMiddleware(
      new FileRepository(getApplicationDocumentsDirectory),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: _store,
      child: new StoreConnector<AppState, AppSection>(
        distinct: true,
        converter: (store) => store.state.mainPageState.activeSection,
        builder: (context, section) => new MaterialApp(
              title: 'Readathon',
              theme: ReadathonTheme.THEMES[section],
              home: new StoreBuilder(
                onInit: (store) => store.dispatch(const BootAppAction()),
                builder: (context, _) => const BootWidget(
                      child: const MainPage(),
                    ),
              ),
            ),
      ),
    );
  }
}

class BootWidget extends StatelessWidget {
  final Widget child;

  const BootWidget({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, bool>(
      converter: (store) => store.state.isBooting,
      builder: (context, isBooting) =>
          isBooting ? _buildBootingScreen(context) : child,
    );
  }

  Widget _buildBootingScreen(BuildContext context) => new Scaffold(
        appBar: new AppBar(
          title: new Text('Readathon'),
        ),
        body: new Center(
          child: new Text('Loading...'),
        ),
      );
}
