import 'dart:convert';

import 'package:readathon/models/book.dart';
import 'package:readathon/models/goal.dart';
import 'package:test/test.dart';

void main() {
  group('Simple goal', () {
    test('should serialize into JSON', () {
      var givenGoal = new Goal(
        'Title',
        new DateTime(2019),
        30,
        new SingleTagExpression(new AnyValuePredicate()),
        id: 'GOAL_ID',
        note: 'My humble goal to read 30 books in a year.',
      );

      var actual = JSON.encode(givenGoal.toJson());

      var expected =
          '{"id":"GOAL_ID","title":"Title","note":"My humble goal to read 30 books in a year.","deadline":1546297200000,"numberOfBooks":30,"expression":{"predicate":{"type":"any_value_predicate"},"type":"single_tag_expression"}}';
      expect(actual, equals(expected));
    });

    test('should deserialie from JSON', () {
      var givenGoalJson =
          '{"id":"GOAL_ID","title":"Title","note":"My humble goal to read 30 books in a year.","deadline":1546297200000,"numberOfBooks":30,"expression":{"predicate":{"type":"any_value_predicate"},"type":"single_tag_expression"}}';

      var actual = Goal.fromJson(JSON.decode(givenGoalJson));

      var expected = new Goal(
        'Title',
        new DateTime(2019),
        30,
        new SingleTagExpression(new AnyValuePredicate()),
        id: 'GOAL_ID',
        note: 'My humble goal to read 30 books in a year.',
      );
      ;
      expect(actual, equals(expected));
    });
  });

  group('Complex expression', () {
    test('should serialize into JSON', () {
      var givenAuthor = new Author('Bob', id: 'AUTHOR_ID');
      var givenExpressionession =
          new SingleTagExpression(new ExactValuePredicate.byAuthor(givenAuthor))
              .and(new SingleTagExpression(
                  new GreaterThanValuePredicate.byPages(100)))
              .or(new SingleTagExpression(
                  new GreaterThanValuePredicate.byPages(200)));

      var actual = JSON.encode(givenExpressionession.toJson());

      var expected =
          '{"type":"or_tag_expression","first":{"type":"and_tag_expression","first":{"predicate":{"_expectedValue":"AUTHOR_ID","_targetedTag":{"id":"TAG_AUTHOR","name":"author"},"_valueType":"string","description":"author is Bob","type":"exact_value_predicate"},"type":"single_tag_expression"},"second":{"predicate":{"type":"greater_than_value_predicate","_limitValue":100,"_targetedTag":{"id":"TAG_NUMBER_OF_PAGES","name":"number of pages"},"description":"number of pages is greater than 100"},"type":"single_tag_expression"}},"second":{"predicate":{"type":"greater_than_value_predicate","_limitValue":200,"_targetedTag":{"id":"TAG_NUMBER_OF_PAGES","name":"number of pages"},"description":"number of pages is greater than 200"},"type":"single_tag_expression"}}';
      expect(actual, equals(expected));
    });

    test('should deserialize from JSON', () {
      var givenExpressionJson =
          '{"type":"or_tag_expression","first":{"type":"and_tag_expression","first":{"predicate":{"_expectedValue":"AUTHOR_ID","_targetedTag":{"id":"TAG_AUTHOR","name":"author"},"_valueType":"string","description":"author is Bob","type":"exact_value_predicate"},"type":"single_tag_expression"},"second":{"predicate":{"type":"greater_than_value_predicate","_limitValue":100,"_targetedTag":{"id":"TAG_NUMBER_OF_PAGES","name":"number of pages"},"description":"number of pages is greater than 100"},"type":"single_tag_expression"}},"second":{"predicate":{"type":"greater_than_value_predicate","_limitValue":200,"_targetedTag":{"id":"TAG_NUMBER_OF_PAGES","name":"number of pages"},"description":"number of pages is greater than 200"},"type":"single_tag_expression"}}';

      var actual = TagExpression.fromJson(JSON.decode(givenExpressionJson));

      var expectedAuthor = new Author('Bob', id: 'AUTHOR_ID');
      var expected = new SingleTagExpression(
              new ExactValuePredicate.byAuthor(expectedAuthor))
          .and(new SingleTagExpression(
              new GreaterThanValuePredicate.byPages(100)))
          .or(new SingleTagExpression(
              new GreaterThanValuePredicate.byPages(200)));
      expect(actual, equals(expected));
    });
  });
}
