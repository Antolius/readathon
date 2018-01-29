import 'package:readathon/models/book.dart';
import 'package:readathon/models/goal.dart';
import 'package:readathon/models/tag.dart';
import 'package:test/test.dart';

void main() {
  group('Author tag expression', () {
    test('should match book by author id', () {
      var givenAuthorId = 'AUTHOR_ID';
      var givenAuthor = new Author('Bob', id: givenAuthorId);
      var givenBook = givenBookWith(givenAuthor, 100);
      var givenChecker = new ExactValuePredicate.byAuthor(givenAuthor);

      var actual = TagExpression.from(givenChecker).evaluate(givenBook.tags);

      expect(actual, isTrue);
    });

    test('should not match book without propert author id', () {
      var givenBook = givenBookWith(new Author('Bob', id: 'ID_1'), 100);
      var givenChecker =
          new ExactValuePredicate.byAuthor(new Author('Bob', id: 'ID_2'));
      var actual = TagExpression.from(givenChecker).evaluate(givenBook.tags);
      expect(actual, isFalse);
    });
  });

  group('Number of pages tag expression', () {
    test('should match book with greater number of pages', () {
      var givenBook = givenBookWith(new Author('Bob', id: 'ID_1'), 200);
      var givenChecker = new GreaterThanValuePredicate.byPages(100);
      var actual = TagExpression.from(givenChecker).evaluate(givenBook.tags);
      expect(actual, isTrue);
    });

    test('should not match book with equal number of pages', () {
      var givenBook = givenBookWith(new Author('Bob', id: 'ID_1'), 100);
      var givenChecker = new GreaterThanValuePredicate.byPages(100);
      var actual = TagExpression.from(givenChecker).evaluate(givenBook.tags);
      expect(actual, isFalse);
    });

    test('should not match book with smaller number of pages', () {
      var givenBook = givenBookWith(new Author('Bob', id: 'ID_1'), 50);
      var givenChecker = new GreaterThanValuePredicate.byPages(100);
      var actual = TagExpression.from(givenChecker).evaluate(givenBook.tags);
      expect(actual, isFalse);
    });
  });

  group('And expression', () {
    test('should match if both subexpressions match', () {
      var givenAuthorId = 'AUTHOR_ID';
      var givenAuthor = new Author('Bob', id: givenAuthorId);
      var givenBook = givenBookWith(givenAuthor, 200);

      var givenAuthorExpression =
          TagExpression.from(new ExactValuePredicate.byAuthor(givenAuthor));
      var givenNumberOfPagesExpression =
          TagExpression.from(new GreaterThanValuePredicate.byPages(100));

      var actual = givenAuthorExpression
          .and(givenNumberOfPagesExpression)
          .evaluate(givenBook.tags);

      expect(actual, isTrue);
    });

    test('should not match if one of subexpressions does not match', () {
      var givenAuthorId = 'AUTHOR_ID';
      var givenAuthor = new Author('Bob', id: givenAuthorId);
      var givenBook = givenBookWith(givenAuthor, 90);

      var givenAuthorExpression =
          TagExpression.from(new ExactValuePredicate.byAuthor(givenAuthor));
      var givenNumberOfPagesExpression =
          TagExpression.from(new GreaterThanValuePredicate.byPages(100));

      var actual = givenAuthorExpression
          .and(givenNumberOfPagesExpression)
          .evaluate(givenBook.tags);

      expect(actual, isFalse);
    });
  });

  group('Or expression', () {
    test('should match if one of subexpressions matches', () {
      var givenAuthorId = 'AUTHOR_ID';
      var givenAuthor = new Author('Bob', id: givenAuthorId);
      var givenBook = givenBookWith(givenAuthor, 90);

      var givenAuthorExpression =
          TagExpression.from(new ExactValuePredicate.byAuthor(givenAuthor));
      var givenNumberOfPagesExpression =
          TagExpression.from(new GreaterThanValuePredicate.byPages(100));

      var actual = givenAuthorExpression
          .or(givenNumberOfPagesExpression)
          .evaluate(givenBook.tags);

      expect(actual, isTrue);
    });
    test('should not match if none of subexpressions matches', () {
      var givenBook = givenBookWith(new Author('Bob', id: 'AUTHOR_ID_1'), 90);

      var givenAuthorExpression = TagExpression.from(
          new ExactValuePredicate.byAuthor(
              new Author('Bob', id: 'AUTHOR_ID_2')));
      var givenNumberOfPagesExpression =
          TagExpression.from(new GreaterThanValuePredicate.byPages(100));

      var actual = givenAuthorExpression
          .or(givenNumberOfPagesExpression)
          .evaluate(givenBook.tags);

      expect(actual, isFalse);
    });
  });
}

Book givenBookWith(Author givenAuthor, int givenNumberOfPages) => new Book(
      title: 'Title',
      numberOfPages: 0,
      authors: [givenAuthor],
      tags: [
        new StringTagValue(Tag.AUTHOR, givenAuthor.id),
        new NumTagValue(Tag.NUMBER_OF_PAGES, givenNumberOfPages),
      ],
    );
