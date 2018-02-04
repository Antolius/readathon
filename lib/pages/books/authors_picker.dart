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

class AuthorsPicker extends StatefulWidget {
  final Set<Author> existingAuthors;

  const AuthorsPicker(this.existingAuthors, { Key key }): super(key: key);

  @override
  AuthorsPickerState createState() => new AuthorsPickerState();
}

class AuthorsPickerState extends State<AuthorsPicker> {
  Set<Author> _availableAuthors;
  List<Author> pickedAuthors;

  @override
  void initState() {
    super.initState();
    pickedAuthors = [];
    _availableAuthors = new Set.from(widget.existingAuthors);
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.only(top: 8.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildRows(),
      ),
    );
  }

  List<Widget> _buildRows() {
    List<List<Widget>> rowItems = [];
    if (_availableAuthors.isNotEmpty) {
      rowItems.addAll(pickedAuthors.map(_renderPickAuthorRowItems));
      if (_availableAuthors.length > pickedAuthors.length) {
        rowItems.add(_renderPickAuthorRowItems(null));
      }
    }
    rowItems.add(<Widget>[
      new FlatButton(
        onPressed: () => _onAddNewAuthor(context),
        child: new Text('ADD NEW AUTHOR'),
      )
    ]);

    for (var i = 0; i < rowItems.length; i++) {
      if (i == 0) {
        rowItems[i] = [
          new Padding(
            padding: new EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            child: new Icon(
              Icons.person,
              color: Colors.grey,
            ),
          )
        ]..addAll(rowItems[i]);
      } else {
        rowItems[i] = [
          new Container(
            constraints: new BoxConstraints(minWidth: 48.0),
          )
        ]..addAll(rowItems[i]);
      }
    }

    return rowItems.map((items) => new Row(children: items)).toList();
  }

  _onAddNewAuthor(BuildContext context) async {
    Author author = await showDialog(
      context: context,
      child: new AddAuthorModal(),
    );
    if (author != null) {
      setState(() => _availableAuthors.add(author));
    }
  }

  List<Widget> _renderPickAuthorRowItems(Author author) {
    if (author == null) {
      var shouldPadd = pickedAuthors.isNotEmpty;
      return <Widget>[
        new Expanded(
          child: new Padding(
            padding: new EdgeInsets.only(right: shouldPadd ? 64.0 : 0.0),
            child: _renderDropdownButton(author),
          ),
        ),
      ];
    }

    return <Widget>[
      new Expanded(child: _renderDropdownButton(author)),
      (_renderRemoveButton(author)),
    ];
  }

  Widget _renderRemoveButton(Author author) {
    return new Padding(
      padding: new EdgeInsetsDirectional.only(start: 24.0),
      child: new FloatingActionButton(
        onPressed: () => setState(() {
              pickedAuthors.remove(author);
            }),
        mini: true,
        elevation: 2.0,
        backgroundColor: Colors.grey,
        child: new Icon(Icons.remove),
      ),
    );
  }

  Widget _renderDropdownButton(Author author) {
    return new DropdownButton(
      value: author,
      items: _filterAvailableAuthorsFor(author).map(_renderOptions).toList(),
      onChanged: (picked) => setState(() {
            if (author != null) {
              var indexToChange = pickedAuthors.indexOf(author);
              pickedAuthors[indexToChange] = picked;
            } else {
              pickedAuthors.add(picked);
            }
          }),
    );
  }

  DropdownMenuItem<Author> _renderOptions(Author author) =>
      new DropdownMenuItem<Author>(
        child: new Text(
          author.name,
          overflow: TextOverflow.ellipsis,
        ),
        value: author,
      );

  _filterAvailableAuthorsFor(Author author) => _availableAuthors
      .where((auth) => author == auth || !pickedAuthors.contains(auth));
}
