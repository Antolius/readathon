import 'package:uuid/uuid.dart';

class Tag {
  static final Set<Tag> DEFAULTS = new Set.from([
    AUTHOR,
    NUMBER_OF_PAGES,
    LANGUAGE,
    COUNTRY,
  ]);
  static final Tag AUTHOR = new Tag('author', id: 'TAG_AUTHOR');
  static final Tag NUMBER_OF_PAGES =
      new Tag('number of pages', id: 'TAG_NUMBER_OF_PAGES');
  static final Tag LANGUAGE = new Tag('language', id: 'TAG_NUMBER_LANGUAGE');
  static final Tag COUNTRY = new Tag('country', id: 'TAG_COUNTRY');

  final String id;
  final String name;

  Tag(
    this.name, {
    String id,
  })
      : this.id = id ?? new Uuid().v4();

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "name": this.name,
      };

  static Tag fromJson(Map<String, dynamic> json) =>
      new Tag(json['name'] as String, id: json['id'] as String);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

typedef ReturnType VisitFunction<TagValueType extends TagValue<dynamic>,
    ReturnType>(TagValueType tagValue);

class TagValueVisitor<ReturnType> {
  final String description;
  final VisitFunction<StringTagValue, ReturnType> _stringVisitor;
  final VisitFunction<BoolTagValue, ReturnType> _boolVisitor;
  final VisitFunction<NumTagValue, ReturnType> _numVisitor;

  TagValueVisitor(
    this.description,
    this._stringVisitor,
    this._boolVisitor,
    this._numVisitor,
  );

  ReturnType visitString(StringTagValue value) => _stringVisitor(value);

  ReturnType visitBool(BoolTagValue value) => _boolVisitor(value);

  ReturnType visitNum(NumTagValue value) => _numVisitor(value);
}

abstract class TagValue<ValueType> {
  final Tag tag;

  TagValue(this.tag);

  ValueType get value;

  R accept<R>(TagValueVisitor<R> visitor);

  Map<String, dynamic> toJson();

  static TagValue<dynamic> fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'String':
        return new StringTagValue(
            Tag.fromJson(json['tag']), json['value'] as String);
      case 'bool':
        return new BoolTagValue(
            Tag.fromJson(json['tag']), json['value'] as bool);
      case 'num':
        return new NumTagValue(Tag.fromJson(json['tag']), json['value'] as num);
      default:
        throw new ArgumentError.value(json['type'], 'TagValue type',
            'Unknown TagValue type. Supported types are: String, bool and num.');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagValue && runtimeType == other.runtimeType && tag == other.tag;

  @override
  int get hashCode => tag.hashCode;
}

class StringTagValue extends TagValue<String> {
  final String value;

  StringTagValue(Tag tag, this.value) : super(tag);

  @override
  R accept<R>(TagValueVisitor<R> visitor) => visitor.visitString(this);

  @override
  Map<String, dynamic> toJson() => {
        "tag": this.tag.toJson(),
        "value": this.value,
        "type": "String",
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StringTagValue &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class BoolTagValue extends TagValue<bool> {
  final bool value;

  BoolTagValue(Tag tag, this.value) : super(tag);

  @override
  R accept<R>(TagValueVisitor<R> visitor) => visitor.visitBool(this);

  @override
  Map<String, dynamic> toJson() => {
        "tag": this.tag.toJson(),
        "value": this.value,
        "type": "bool",
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is BoolTagValue &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => super.hashCode ^ value.hashCode;
}

class NumTagValue extends TagValue<num> {
  final num value;

  NumTagValue(Tag tag, this.value) : super(tag);

  @override
  R accept<R>(TagValueVisitor<R> visitor) => visitor.visitNum(this);

  @override
  Map<String, dynamic> toJson() => {
        "tag": this.tag.toJson(),
        "value": this.value,
        "type": "num",
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is NumTagValue &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => super.hashCode ^ value.hashCode;
}
