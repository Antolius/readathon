import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:readathon/models/models.dart';
import 'package:readathon/redux/actions/actions.dart';
import 'package:readathon/redux/state.dart';
import 'package:redux/redux.dart';

class AddBookModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: _ViewModel.from,
      builder: (context, model) {
        return new _AddBookForm(model);
      },
    );
  }
}

class _ViewModel {
  Book newBook;
  Set<Tag> existingTags;
  Set<Author> existingAuthors;
  final void Function() onSave;

  _ViewModel(
    this.newBook,
    this.existingTags,
    this.existingAuthors,
    this.onSave,
  );

  static _ViewModel from(Store<AppState> store) => new _ViewModel(
        _extractNewBook(store),
        _extractTags(store),
        _extractAuthors(store),
        () => store.dispatch(new AddBookAction(_extractNewBook(store))),
      );

  static Book _extractNewBook(Store<AppState> store) =>
      store.state.addBookPageState.book;

  static Set<Tag> _extractTags(Store<AppState> store) =>
      store.state.domainState.books
          .expand((book) => book.tags)
          .map((tagValue) => tagValue.tag)
          .toSet()
            ..addAll(Tag.DEFAULTS);

  static Set<Author> _extractAuthors(Store<AppState> store) =>
      store.state.domainState.books.expand((book) => book.authors).toSet();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          newBook == other.newBook &&
          const SetEquality().equals(existingTags, other.existingTags) &&
          const SetEquality().equals(existingAuthors, other.existingAuthors);

  @override
  int get hashCode =>
      newBook.hashCode ^
      const SetEquality().hash(existingTags) ^
      const SetEquality().hash(existingAuthors);
}

class _AddBookForm extends StatelessWidget {
  final _ViewModel _model;

  _AddBookForm(this._model);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add book'),
        actions: <Widget>[
          new FlatButton(
            onPressed: _model.onSave,
            child: new Text('SAVE'),
          ),
        ],
      ),
      body: new Form(
        child: new Column(
          children: <Widget>[
            new TextFormField(
              decoration: new InputDecoration(
                icon: const Icon(Icons.title),
                labelText: 'Title',
              ),
              initialValue: _model.newBook.title ?? '',
              validator: (val) =>
                  val?.isNotEmpty ?? false ? null : 'Title is required',
              onSaved: (val) =>
                  _model.newBook = _model.newBook.copyWith(title: val),
            ),
          ],
        ),
      ),
    );
  }
}
