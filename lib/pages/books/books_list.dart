import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:readathon/models/models.dart';
import 'package:readathon/pages/books/empty_books_list.dart';
import 'package:readathon/redux/state.dart';
import 'package:redux/redux.dart';

class BooksList extends StatelessWidget {
  const BooksList();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: _ViewModel.from,
      builder: (context, model) {
        if (model.books.isEmpty) {
          return const EmptyBooksList();
        } else {
          return new _FullBooksList(model.books);
        }
      },
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

class _FullBooksList extends StatelessWidget {
  final List<Book> _books;

  const _FullBooksList(this._books);

  @override
  Widget build(BuildContext context) {
    String _listAuthorsOf(Book book) =>
        'By ${book.authors.map((a) => a.name).join(', ')}';

    return new Scrollbar(
      child: new ListView.builder(
        itemCount: _books.length,
        itemBuilder: (context, index) {
          var book = _books[index];
          return new ListTile(
            leading: new Image.network(book.coverImageUrl),
            title: new Text(book.title),
            subtitle: new Text(_listAuthorsOf(book)),
            //TODO: navigate to book details
            onTap: () => {},
          );
        },
      ),
    );
  }
}
