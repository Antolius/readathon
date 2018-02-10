import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:flutter/src/material/dialog.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:flutter/src/material/flat_button.dart';
import 'package:flutter/src/material/floating_action_button.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:flutter/src/painting/edge_insets.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:flutter/src/rendering/flex.dart';
import 'package:flutter/src/rendering/paragraph.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/icon.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:readathon/models/book.dart';
import 'package:readathon/pages/books/add_author.dart';

class AuthorsPickerFormField extends FormField<List<Author>> {
  final Set<Author> existingAuthors;

  AuthorsPickerFormField({
    Key key,
    this.existingAuthors,
    FormFieldValidator<List<Author>> validator,
    initialValue,
  })
      : super(
          key: key,
          validator: validator,
          initialValue: initialValue ?? [],
          builder: (state) {
            var pickerState = state as AuthorsPickerState;
            return new _AuthorsPicker(pickerState, pickerState.focusNode);
          },
        );

  @override
  AuthorsPickerState createState() => new AuthorsPickerState(existingAuthors);
}

class AuthorsPickerState extends FormFieldState<List<Author>>
    with _AuthorsPickerController {
  final Set<Author> _preexistingAuthors;
  Set<Author> _availableAuthors;
  FocusNode focusNode;

  AuthorsPickerState(this._preexistingAuthors);

  @override
  void initState() {
    super.initState();
    _availableAuthors = new Set.from(_preexistingAuthors);
    focusNode = new FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  List<Author> get pickedAuthors => value;

  Set<Author> get availableAuthors => _availableAuthors;
}

abstract class _AuthorsPickerController {
  Set<Author> get availableAuthors;

  List<Author> get pickedAuthors;

  String get errorText;

  void setState(VoidCallback fn);

  void addAvailableAuthor(Author author) => setState(() {
        availableAuthors.add(author);
        pickedAuthors.add(author);
      });

  void pick(Author author) => setState(() => pickedAuthors.add(author));

  void rePick(int index, Author author) => setState(() {
        pickedAuthors[index] = author;
      });

  void unPick(Author author) => setState(() => pickedAuthors.remove(author));
}

class _AuthorsPicker extends StatelessWidget {
  final _AuthorsPickerController _controller;
  final FocusNode _focusNode;

  _AuthorsPicker(this._controller, this._focusNode);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.only(top: 8.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildRows(context),
      ),
    );
  }

  List<Widget> _buildRows(BuildContext context) {
    List<List<Widget>> rowItems = [];
    final available = _controller.availableAuthors;
    final alreadyPicked = _controller.pickedAuthors;
    final anyAuthorsExist = available.isNotEmpty;
    final thereAreAuthorsLeftToPick = available.length > alreadyPicked.length;

    if (anyAuthorsExist) {
      rowItems.addAll(alreadyPicked
          .map((author) => _buildPickAuthorRowItems(context, author)));
      if (thereAreAuthorsLeftToPick) {
        rowItems.add(_buildPickAuthorRowItems(context, null));
      }
    }
    if (_controller.errorText != null) {
      rowItems.add(_buildError(context));
    }
    rowItems.add(_buildAddNewAuthorButton(context));

    for (var i = 0; i < rowItems.length; i++) {
      rowItems[i] = [_buildRowDecoration(context, i)]..addAll(rowItems[i]);
    }

    return rowItems.map((items) => new Row(children: items)).toList();
  }

  List<Widget> _buildPickAuthorRowItems(BuildContext context, Author author) {
    if (author == null) {
      var shouldPadd = _controller.pickedAuthors.isNotEmpty;
      return <Widget>[
        new Expanded(
          child: new Padding(
            padding: new EdgeInsets.only(right: shouldPadd ? 64.0 : 0.0),
            child: _buildDropdownButton(context, author),
          ),
        )
      ];
    }

    return <Widget>[
      new Expanded(child: _buildDropdownButton(context, author)),
      _buildRemovePickerButton(context, author),
    ];
  }

  Widget _buildRemovePickerButton(BuildContext context, Author author) =>
      new Padding(
        padding: new EdgeInsetsDirectional.only(start: 24.0),
        child: new FloatingActionButton(
          onPressed: () {
            _controller.unPick(author);
            FocusScope.of(context).requestFocus(_focusNode);
          },
          mini: true,
          elevation: 2.0,
          backgroundColor: Colors.grey,
          child: new Icon(Icons.remove),
        ),
      );

  Widget _buildDropdownButton(BuildContext context, Author previousPick) {
    return new DropdownButton(
      value: previousPick,
      hint: new Text(
        'Pick an author',
        style: new TextStyle(
          inherit: true,
          color: _focusNode.hasFocus ? Theme.of(context).accentColor : null,
        ),
      ),
      items: _availableExcluding(previousPick).map(_buildDropdownItem).toList(),
      onChanged: (picked) {
        if (previousPick != null) {
          var indexToChange = _controller.pickedAuthors.indexOf(previousPick);
          _controller.rePick(indexToChange, picked);
        } else {
          _controller.pick(picked);
        }
        FocusScope.of(context).requestFocus(_focusNode);
      },
    );
  }

  DropdownMenuItem<Author> _buildDropdownItem(Author author) =>
      new DropdownMenuItem<Author>(
        child: new Text(
          author.name,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        value: author,
      );

  _availableExcluding(Author author) => _controller.availableAuthors.where(
      (auth) => author == auth || !_controller.pickedAuthors.contains(auth));

  List<Widget> _buildError(BuildContext context) => <Widget>[
        new Text(
          _controller.errorText,
          style: new TextStyle(
            inherit: true,
            fontSize: 12.0,
            color: Theme.of(context).errorColor,
          ),
        )
      ];

  List<Widget> _buildAddNewAuthorButton(BuildContext context) => <Widget>[
        new FlatButton(
          onPressed: () => _onAddNewAuthor(context),
          child: new Text('ADD NEW AUTHOR'),
        )
      ];

  _onAddNewAuthor(BuildContext context) async {
    Author author = await showDialog(
      context: context,
      child: new AddAuthorModal(),
    );
    if (author != null) {
      _controller.addAvailableAuthor(author);
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  _buildRowDecoration(BuildContext context, int i) => i == 0
      ? new Padding(
          padding: new EdgeInsets.only(right: 16.0),
          child: new Icon(
            _controller.pickedAuthors.length > 1 ? Icons.people : Icons.person,
            color: _focusNode.hasFocus
                ? Theme.of(context).accentColor
                : Colors.grey,
          ),
        )
      : new Container(
          constraints: new BoxConstraints(minWidth: 40.0),
        );
}
