import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:readathon/models/models.dart';
import 'package:readathon/redux/state.dart';
import 'package:redux/redux.dart';

class BooksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: _ViewModel.from,
      builder: (context, model) => null,
    );
  }
}

class _ViewModel {
  final List<Book> books;

  _ViewModel(this.books);

  static _ViewModel from(Store<AppState> store) =>
      new _ViewModel(store.state.domainState.books);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _ViewModel &&
              runtimeType == other.runtimeType &&
              new IterableEquality().equals(books, other.books);

  @override
  int get hashCode => new IterableEquality().hash(books);



}
