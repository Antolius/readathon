import 'package:uuid/uuid.dart';

class Tag {
  static final List<Tag> DEFAULTS = const [
    AUTHOR,
    NUMBER_OF_PAGES,
    LANGUAGE,
    COUNTRY,
    FAVORITE,
    NUMBER_OF_TIMES_READ
  ];
  static const Tag AUTHOR =
      const Tag._internal('author', 'TAG_AUTHOR', TagType.STRING);
  static const NUMBER_OF_PAGES = const Tag._internal(
      'number of pages', 'TAG_NUMBER_OF_PAGES', TagType.NUM);
  static const LANGUAGE =
      const Tag._internal('language', 'TAG_LANGUAGE', TagType.STRING, true);
  static const COUNTRY =
      const Tag._internal('country', 'TAG_COUNTRY', TagType.STRING, true);
  static const FAVORITE =
      const Tag._internal('favorite', 'TAG_FAVORITE', TagType.BOOL, true);
  static const NUMBER_OF_TIMES_READ = const Tag._internal(
      'number of times read', 'TAG_NUMBER_OF_READS', TagType.NUM, true);

  final String id;
  final String name;
  final TagType type;
  final bool isUserEditable;

  const Tag._internal(this.name, this.id, this.type,
      [this.isUserEditable = false]);

  Tag(
    this.name,
    this.type, {
    String id,
  })
      : this.id = id ?? new Uuid().v4(),
        this.isUserEditable = true,
        assert(name != null && name.isNotEmpty);

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'type': this.type.index,
        'isUserEditable': this.isUserEditable,
      };

  static Tag fromJson(Map<String, dynamic> json) => new Tag._internal(
        json['name'] as String,
        json['id'] as String,
        TagType.values[json['type'] as int],
        json['isUserEditable'] as bool,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          type == other.type &&
          isUserEditable == other.isUserEditable;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ type.hashCode ^ isUserEditable.hashCode;
}

enum TagType { STRING, NUM, BOOL }

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

  StringTagValue(Tag tag, this.value)
      : assert(tag != null && tag.type == TagType.STRING),
        assert(value != null),
        super(tag);

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

  BoolTagValue(Tag tag, this.value)
      : assert(tag != null && tag.type == TagType.BOOL),
        assert(value != null),
        super(tag);

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

  NumTagValue(Tag tag, this.value)
      : assert(tag != null && tag.type == TagType.NUM),
        assert(value != null),
        super(tag);

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
