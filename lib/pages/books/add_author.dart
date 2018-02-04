import 'package:flutter/src/material/dialog.dart';
import 'package:flutter/src/material/flat_button.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:flutter/src/material/input_decorator.dart';
import 'package:flutter/src/material/text_form_field.dart';
import 'package:flutter/src/material/theme.dart';
import 'package:flutter/src/painting/edge_insets.dart';
import 'package:flutter/src/rendering/flex.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/form.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/icon.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:readathon/models/book.dart';

class AddAuthorModal extends StatelessWidget {
  static final GlobalKey<FormFieldState<String>> _nameKey =
      new GlobalKey<FormFieldState<String>>();

  _onSave(BuildContext context) {
    var state = _nameKey.currentState;
    if (state.validate()) {
      Navigator.of(context).pop(new Author(state.value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Dialog(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.all(24.0),
            child: new Column(
              children: <Widget>[
                new Text(
                  'Add new author',
                  style: Theme.of(context).textTheme.title,
                ),
                new Padding(
                  padding: new EdgeInsets.only(top: 20.0),
                  child: new TextFormField(
                    key: _nameKey,
                    decoration: new InputDecoration(
                      icon: const Icon(Icons.person),
                      labelText: 'Name',
                    ),
                    validator: (val) =>
                        val?.isNotEmpty ?? false ? null : 'Name is required',
                    autofocus: true,
                  ),
                ),
              ],
            ),
          ),
          new Padding(
            padding: new EdgeInsets.all(8.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: new Text('CANCLE'),
                ),
                new FlatButton(
                  onPressed: () => _onSave(context),
                  child: new Text('SAVE'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
