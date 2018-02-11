import 'package:flutter/material.dart';
import 'package:readathon/models/models.dart';

class TagsFormField extends FormField<List<TagValue>> {
  final Set<Tag> existingTags;

  TagsFormField({
    Key key,
    this.existingTags,
    FormFieldValidator<List<TagValue>> validator,
    initialValue,
  })
      : super(
            key: key,
            validator: validator,
            initialValue: initialValue ?? [],
            builder: (state) {
              var tagState = state as TagsFormFieldState;
              return new _TagsForm(tagState);
            });

  @override
  TagsFormFieldState createState() => new TagsFormFieldState(existingTags);
}

class TagsFormFieldState extends FormFieldState<List<TagValue>> {
  final Set<Tag> _preexistingTags;
  Set<Tag> _availableTags;
  Map<TagValue, bool> _expandedTags;

  TagsFormFieldState(this._preexistingTags);

  @override
  void initState() {
    super.initState();
    _availableTags = new Set.from(_preexistingTags);
    _expandedTags = new Map();
    value.forEach((val) => _expandedTags[val] = false);
  }

  onExpand(int index, bool isAlreadyExpanded) => setState(() {
        _expandedTags[value[index]] = !isAlreadyExpanded;
      });

  isExpanded(TagValue tagValue) => _expandedTags[tagValue];

  removeTagValue(TagValue tagValue) => setState(() {
        value.remove(tagValue);
        _expandedTags.remove(tagValue);
      });
}

class _TagsForm extends StatelessWidget {
  final TagsFormFieldState _tagState;

  _TagsForm(this._tagState);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.only(bottom: 16.0),
          child: new Row(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(right: 16.0),
                child: new Icon(
                  Icons.label,
                  color: Colors.grey,
                ),
              ),
              new Text(
                'Tags',
                style:
                    new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
        new ExpansionPanelList(
          expansionCallback: (int index, bool isAlreadyExpanded) =>
              _tagState.onExpand(index, isAlreadyExpanded),
          children: _tagState.value
              .map((tagValue) => _buildTagPanel(context, tagValue))
              .toList(),
        ),
      ],
    );
  }

  _buildTagPanel(BuildContext context, TagValue tagValue) => new ExpansionPanel(
        isExpanded: _tagState.isExpanded(tagValue),
        headerBuilder: (BuildContext context, bool isExpanded) =>
            _buildHeader(context, tagValue, isExpanded),
        body: _buildBody(context, tagValue),
      );

  Widget _buildHeader(
          BuildContext context, TagValue tagValue, bool isExpanded) =>
      new Padding(
        padding: new EdgeInsets.only(left: 24.0),
        child: new Row(
          children: <Widget>[
            new Text(
              _capitalize(tagValue.tag.name),
              style: new TextStyle(fontSize: 15.0),
            ),
            new Padding(
              padding: new EdgeInsets.only(left: 16.0),
              child: new Text(
                isExpanded ? '' : tagValue.value.toString(),
                style: new TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      );

  _buildBody(BuildContext context, TagValue tagValue) => new Padding(
        padding: new EdgeInsets.only(bottom: 16.0),
        child: new Column(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.symmetric(horizontal: 24.0),
              child: tagValue.accept(new _EditWidgetBuildingVisitor(context)),
            ),
            new Divider(
              height: 32.0,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(right: 8.0),
                  child: new FlatButton(
                    onPressed: () => _tagState.removeTagValue(tagValue),
                    child: new Text('REMOVE TAG'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  String _capitalize(String s) => '${s[0].toUpperCase()}${s.substring(1)}';
}

class _EditWidgetBuildingVisitor extends TagValueVisitor<Widget> {
  final BuildContext _context;

  _EditWidgetBuildingVisitor(this._context)
      : super(
          'Edit widget building visitor',
          (StringTagValue stringValue) => new TextFormField(
                initialValue: stringValue.value,
                decoration: new InputDecoration(
                  labelText:
                      'Input string value for ${stringValue.tag.name} tag',
                ),
                validator: (val) => val?.isNotEmpty ?? false
                    ? null
                    : '${stringValue.tag.name} is required',
              ),
          (BoolTagValue boolValue) => new CheckboxListTile(
                value: boolValue.value,
                onChanged: null,
              ),
          (NumTagValue numValue) => new TextFormField(
                initialValue: numValue.value.toString(),
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  labelText: 'Input number value for ${numValue.tag.name} tag',
                ),
                validator: (val) {
                  if (val?.isEmpty ?? true)
                    return '${numValue.tag.name} is required';
                  num number = num.parse(val, (_) => null);
                  if (number == null)
                    return '${numValue.tag.name} must be a number';
                  return null;
                },
              ),
        );
}
