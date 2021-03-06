import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:readathon/models/models.dart';
import 'package:readathon/pages/books/authors_picker_form_field.dart';
import 'package:readathon/pages/books/tags_form_field.dart';
import 'package:readathon/redux/actions/actions.dart';
import 'package:readathon/redux/state.dart';
import 'package:redux/redux.dart';

class AddBookModal extends StatelessWidget {
  static void visit(BuildContext context) => Navigator.of(context).push(
        new MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => new AddBookModal(),
        ),
      );

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
  Set<Tag> existingTags;
  Set<Author> existingAuthors;
  final void Function(Book newBook) onSave;

  _ViewModel(
    this.existingTags,
    this.existingAuthors,
    this.onSave,
  );

  static _ViewModel from(Store<AppState> store) => new _ViewModel(
        _extractTags(store),
        _extractAuthors(store),
        (Book newBook) => store.dispatch(new AddBookAction(newBook)),
      );

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
          const SetEquality().equals(existingTags, other.existingTags) &&
          const SetEquality().equals(existingAuthors, other.existingAuthors);

  @override
  int get hashCode =>
      const SetEquality().hash(existingTags) ^
      const SetEquality().hash(existingAuthors);
}

class _AddBookForm extends StatelessWidget {
  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static final GlobalKey<FormFieldState<String>> _titleKey =
      new GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> _numberOfPagesKey =
      new GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<List<Author>>> _authorsKey =
      new GlobalKey<FormFieldState<List<Author>>>();
  static final GlobalKey<FormFieldState<List<TagValue>>> _tagsKey =
      new GlobalKey<FormFieldState<List<TagValue>>>();
  final _ViewModel _model;

  _AddBookForm(this._model);

  _onSave(BuildContext context) {
    var form = _formKey.currentState;
    if (form.validate()) {
      var newBook = _readFormFields();
      _model.onSave(newBook);
      Navigator.pop(context);
    }
  }

  _readFormFields() {
    var tags = _tagsKey.currentState.value;
    var authors = _authorsKey.currentState.value;
    var numberOfPages = int.parse(_numberOfPagesKey.currentState.value);
    return new Book(
      _titleKey.currentState.value,
      numberOfPages,
      authors,
      tags: <TagValue>[]
        ..addAll(
            authors.map((author) => new StringTagValue(Tag.AUTHOR, author.id)))
        ..add(new NumTagValue(Tag.NUMBER_OF_PAGES, numberOfPages))
        ..addAll(tags),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add book'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => _onSave(context),
            child: new Text('SAVE'),
          ),
        ],
      ),
      body: new Form(
        key: _formKey,
        child: new ListView(
          padding: new EdgeInsets.all(16.0),
          children: <Widget>[
            _buildTitleField(),
            _buildNumberOfPagesField(),
            _buildAuthorsField(),
            new Divider(height: 32.0,),
            _buildTagsField(),
          ],
        ),
      ),
    );
  }

  TextFormField _buildTitleField() => new TextFormField(
        key: _titleKey,
        autofocus: false,
        decoration: new InputDecoration(
          icon: const Icon(Icons.title),
          labelText: 'Title',
        ),
        validator: (val) =>
            val?.isNotEmpty ?? false ? null : 'Title is required',
      );

  TextFormField _buildNumberOfPagesField() => new TextFormField(
        key: _numberOfPagesKey,
        autofocus: false,
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
            icon: const Icon(Icons.library_books),
            labelText: 'Number of pages'),
        validator: (val) {
          if (val?.isEmpty ?? true) return 'Number of pages is required';
          int num = int.parse(val, onError: (_) => null);
          if (num == null) return 'Must be a whole number';
          if (num < 1) return 'Number of pages must be positive';
          return null;
        },
      );

  AuthorsPickerFormField _buildAuthorsField() => new AuthorsPickerFormField(
        key: _authorsKey,
        existingAuthors: _model.existingAuthors,
        validator: (val) =>
            val?.isNotEmpty ?? false ? null : 'At least one author is required',
      );

  _buildTagsField() => new TagsFormField(
        key: _tagsKey,
        existingTags:
            _model.existingTags.where((tag) => tag.isUserEditable).toSet(),
        initialValue: [
          new StringTagValue(Tag.LANGUAGE, 'English'),
          new BoolTagValue(Tag.FAVORITE, false),
          new NumTagValue(Tag.NUMBER_OF_TIMES_READ, 2)
        ],
      );
}
