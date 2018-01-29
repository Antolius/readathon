import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:flutter/src/material/raised_button.dart';
import 'package:flutter/src/painting/edge_insets.dart';
import 'package:flutter/src/rendering/flex.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/icon.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:readathon/app_sections.dart';
import 'package:readathon/pages/books/add_book.dart';
import 'package:readathon/readathon_theme.dart';

class EmptyBooksList extends StatelessWidget {
  const EmptyBooksList();

  @override
  Widget build(BuildContext context) {
    var booksColor = ReadathonTheme.COLORS[AppSection.BOOKS];

    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(
            Icons.sentiment_dissatisfied,
            size: 48.0,
            color: booksColor,
          ),
          new Text('You have no books.'),
          new Padding(
            padding: new EdgeInsets.only(top: 12.0),
            child: new Text('Why don\'t you add some?'),
          ),
          new Padding(
            padding: new EdgeInsets.only(top: 48.0),
            child: new RaisedButton(
              onPressed: () => Navigator.of(context).push(
                    new MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => new AddBookModal(),
                    ),
                  ),
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Icon(Icons.add_box),
                  new Text("ADD A BOOK")
                ],
              ),
              color: booksColor,
            ),
          ),
        ],
      ),
    );
  }
}
