import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:readathon/models/models.dart';
import 'package:readathon/pages/books/add_author.dart';
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

  _readFormFields() => new Book(
        title: _titleKey.currentState.value,
        numberOfPages: 0,
        authors: [],
        tags: [],
      );

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
      body: new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new Column(
            children: <Widget>[
              new TextFormField(
                key: _titleKey,
                decoration: new InputDecoration(
                  icon: const Icon(Icons.title),
                  labelText: 'Title',
                ),
                validator: (val) =>
                    val?.isNotEmpty ?? false ? null : 'Title is required',
              ),
              new AuthorsPicker(_model.existingAuthors),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthorsPicker extends StatefulWidget {
  final Set<Author> existingAuthors;

  const AuthorsPicker(this.existingAuthors);

  @override
  AuthorsPickerState createState() => new AuthorsPickerState();
}

class AuthorsPickerState extends State<AuthorsPicker> {
  Set<Author> availableAuthors;
  Set<Author> pickedAuthors;

  @override
  void initState() {
    super.initState();
    pickedAuthors = [].toSet();
    availableAuthors = new Set.from(widget.existingAuthors);
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.only(top: 8.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: new Icon(Icons.person),
          ),
          new Column(children: _buildAuthorFields()),
        ],
      ),
    );
  }

  List<Widget> _buildAuthorFields() {
    var fields = [];
    if (availableAuthors.isNotEmpty) {
      fields.addAll(_renderPickedAuthors());
      if (availableAuthors.length > pickedAuthors.length) {
        fields.add(_renderDropdown(null));
      }
    }
    fields.add(new FlatButton(
      onPressed: () => _onAddNewAuthor(context),
      child: new Text('ADD NEW AUTHOR'),
    ));

    return fields;
  }

  _onAddNewAuthor(BuildContext context) async {
    Author author = await showDialog(
      context: context,
      child: new AddAuthorModal(),
    );
    if (author != null) {
      setState(() => availableAuthors.add(author));
    }
  }

  List<Widget> _renderPickedAuthors() =>
      pickedAuthors.map(_renderDropdown).toList(growable: true);

  Widget _renderDropdown(Author author) => new DropdownButton(
        value: author,
        items: availableAuthors.map(_renderOptions).toList(),
        onChanged: (picked) => setState(() {
              pickedAuthors.add(picked);
            }),
      );

  DropdownMenuItem<Author> _renderOptions(Author author) =>
      new DropdownMenuItem<Author>(
        child: new Text(author.name),
        value: author,
      );
}
