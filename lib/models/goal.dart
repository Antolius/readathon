import 'package:readathon/models/book.dart';
import 'package:readathon/models/tag.dart';
import 'package:uuid/uuid.dart';

class Goal {
  final String id;
  final String title;
  final String note;
  final DateTime deadline;
  final int numberOfBooks;
  final TagExpression expression;

  Goal(
    this.title,
    this.deadline,
    this.numberOfBooks,
    this.expression, {
    String id,
    String note,
  })
      : this.id = id ?? new Uuid().v4(),
        this.note = note ??
            'Read $numberOfBooks books such that ${expression
                .description} before $deadline';

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'title': this.title,
        'note': this.note,
        'deadline': this.deadline.millisecondsSinceEpoch,
        'numberOfBooks': this.numberOfBooks,
        'expression': this.expression.toJson(),
      };

  static Goal fromJson(Map<String, dynamic> json) => new Goal(
        json['title'] as String,
        new DateTime.fromMillisecondsSinceEpoch(json['deadline'] as int),
        json['numberOfBooks'] as int,
        TagExpression.fromJson(json['expression'] as Map<String, dynamic>),
        id: json['id'] as String,
        note: json['note'] as String,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Goal &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          note == other.note &&
          deadline == other.deadline &&
          numberOfBooks == other.numberOfBooks &&
          expression == other.expression;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      note.hashCode ^
      deadline.hashCode ^
      numberOfBooks.hashCode ^
      expression.hashCode;
}

abstract class TagExpression {
  bool evaluate(Iterable<TagValue> values);

  static TagExpression from(TagValueVisitor<bool> checker) =>
      new SingleTagExpression(checker);

  TagExpression and(TagExpression other) => new AndTagExpression(this, other);

  TagExpression or(TagExpression other) => new OrTagExpression(this, other);

  String get description;

  Map<String, dynamic> toJson();

  static TagExpression fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'single_tag_expression':
        return new SingleTagExpression(
          PredicateVisitor.fromJson(json['predicate'] as Map<String, dynamic>),
        );
      case 'and_tag_expression':
        return new AndTagExpression(
          fromJson(json['first'] as Map<String, dynamic>),
          fromJson(json['second'] as Map<String, dynamic>),
        );
      case 'or_tag_expression':
        return new OrTagExpression(
          fromJson(json['first'] as Map<String, dynamic>),
          fromJson(json['second'] as Map<String, dynamic>),
        );
      default:
        throw new ArgumentError.value(
            json['type'], 'type', 'Unknown TagExpression type.');
    }
  }
}

class SingleTagExpression extends TagExpression {
  final PredicateVisitor predicate;

  SingleTagExpression(this.predicate);

  @override
  bool evaluate(Iterable<TagValue> values) {
    try {
      return values.firstWhere((val) => val.accept(this.predicate)) != null;
    } catch (e) {
      return false;
    }
  }

  @override
  String get description => predicate.description;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SingleTagExpression &&
          runtimeType == other.runtimeType &&
          predicate == other.predicate;

  @override
  int get hashCode => predicate.hashCode;

  @override
  Map<String, dynamic> toJson() => {
        'predicate': predicate.toJson(),
        'type': 'single_tag_expression',
      };
}

class AndTagExpression extends TagExpression {
  final TagExpression first;
  final TagExpression second;

  AndTagExpression(this.first, this.second);

  @override
  bool evaluate(Iterable<TagValue> values) =>
      first.evaluate(values) && second.evaluate(values);

  @override
  String get description => '${first.description} and ${second.description}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AndTagExpression &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;

  @override
  Map<String, dynamic> toJson() => {
        'type': 'and_tag_expression',
        'first': first.toJson(),
        'second': second.toJson(),
      };
}

class OrTagExpression extends TagExpression {
  final TagExpression first;
  final TagExpression second;

  OrTagExpression(this.first, this.second);

  @override
  bool evaluate(Iterable<TagValue> values) =>
      first.evaluate(values) || second.evaluate(values);

  @override
  String get description => '${first.description} or ${second.description}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrTagExpression &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;

  @override
  Map<String, dynamic> toJson() => {
        'type': 'or_tag_expression',
        'first': first.toJson(),
        'second': second.toJson(),
      };
}

abstract class PredicateVisitor extends TagValueVisitor<bool> {
  static bool falseStringFunction(StringTagValue _) => false;

  static bool falseBoolFunction(BoolTagValue _) => false;

  static bool falseNumFunction(NumTagValue _) => false;

  PredicateVisitor(
    String description, {
    VisitFunction<StringTagValue, bool> stringVisitor: falseStringFunction,
    VisitFunction<BoolTagValue, bool> boolVisitor: falseBoolFunction,
    VisitFunction<NumTagValue, bool> numVisitor: falseNumFunction,
  })
      : super(description, stringVisitor, boolVisitor, numVisitor);

  Map<String, dynamic> toJson();

  static PredicateVisitor fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'greater_than_value_predicate':
        return GreaterThanValuePredicate.fromJson(json);
      case 'exact_value_predicate':
        return ExactValuePredicate.fromJson(json);
      case 'any_value_predicate':
        return new AnyValuePredicate();
      default:
        throw new ArgumentError.value(
            json['type'], 'type', 'Unknown PredicateVisitor type.');
    }
  }
}

class AnyValuePredicate extends PredicateVisitor {
  AnyValuePredicate()
      : super(
          'any one counts',
          stringVisitor: (_) => true,
          boolVisitor: (_) => true,
          numVisitor: (_) => true,
        );

  @override
  Map<String, dynamic> toJson() => {'type': 'any_value_predicate'};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnyValuePredicate && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class GreaterThanValuePredicate extends PredicateVisitor {
  final int _limitValue;
  final Tag _targetedTag;

  GreaterThanValuePredicate.byPages(int numberOfPages)
      : this(numberOfPages, Tag.NUMBER_OF_PAGES);

  GreaterThanValuePredicate(
    this._limitValue,
    this._targetedTag, {
    String description,
  })
      : super(
          description ?? '${_targetedTag.name} is greater than ${_limitValue}',
          numVisitor: (NumTagValue value) =>
              value.tag == _targetedTag && value.value > _limitValue,
        );

  Map<String, dynamic> toJson() => {
        'type': 'greater_than_value_predicate',
        '_limitValue': this._limitValue,
        '_targetedTag': this._targetedTag,
        'description': this.description,
      };

  static GreaterThanValuePredicate fromJson(Map<String, dynamic> json) =>
      new GreaterThanValuePredicate(
        json['_limitValue'] as int,
        Tag.fromJson(json['_targetedTag'] as Map<String, dynamic>),
        description: json['description'] as String,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GreaterThanValuePredicate &&
          runtimeType == other.runtimeType &&
          _limitValue == other._limitValue &&
          _targetedTag == other._targetedTag;

  @override
  int get hashCode => _limitValue.hashCode ^ _targetedTag.hashCode;
}

class ExactValuePredicate extends PredicateVisitor {
  final dynamic _expectedValue;
  final Tag _targetedTag;
  final String _valueType;

  ExactValuePredicate.byAuthor(Author author)
      : this.forString(
          author.id,
          Tag.AUTHOR,
          description: 'author is ${author.name}',
        );

  ExactValuePredicate.forString(
    String exactValue,
    Tag targetedTag, {
    String description,
  })
      : this._internal(exactValue, targetedTag, 'string',
            description: description);

  ExactValuePredicate.forBool(
    bool exactValue,
    Tag targetedTag, {
    String description,
  })
      : this._internal(exactValue, targetedTag, 'boolean',
            description: description);

  ExactValuePredicate.forNum(
    num exactValue,
    Tag targetedTag, {
    String description,
  })
      : this._internal(exactValue, targetedTag, 'number',
            description: description);

  ExactValuePredicate._internal(
    this._expectedValue,
    this._targetedTag,
    this._valueType, {
    String description,
  })
      : super(
          description ?? '${_targetedTag.name} is equal to ${_expectedValue}',
          stringVisitor: (StringTagValue value) =>
              value.tag == _targetedTag && value.value == _expectedValue,
        );

  @override
  Map<String, dynamic> toJson() => {
        '_expectedValue': this._expectedValue,
        '_targetedTag': this._targetedTag,
        '_valueType': this._valueType,
        'description': this.description,
        'type': 'exact_value_predicate',
      };

  static ExactValuePredicate fromJson(Map<String, dynamic> json) {
    switch (json['_valueType'] as String) {
      case 'string':
        return new ExactValuePredicate.forString(
          json['_expectedValue'] as String,
          Tag.fromJson(json['_targetedTag'] as Map<String, dynamic>),
          description: json['description'] as String,
        );
      case 'boolean':
        return new ExactValuePredicate.forBool(
          json['_expectedValue'] as bool,
          Tag.fromJson(json['_targetedTag'] as Map<String, dynamic>),
          description: json['description'] as String,
        );
      case 'number':
        return new ExactValuePredicate.forNum(
          json['_expectedValue'] as num,
          Tag.fromJson(json['_targetedTag'] as Map<String, dynamic>),
          description: json['description'] as String,
        );
      default:
        throw new ArgumentError.value(json['_valueType'], '_valueType',
            'Unknown ExactValuePredicate _valueType.');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExactValuePredicate &&
          runtimeType == other.runtimeType &&
          _expectedValue == other._expectedValue &&
          _targetedTag == other._targetedTag &&
          _valueType == other._valueType;

  @override
  int get hashCode =>
      _expectedValue.hashCode ^ _targetedTag.hashCode ^ _valueType.hashCode;
}
