import 'dart:convert';

import 'package:readathon/models/book.dart';
import 'package:readathon/models/tag.dart';
import 'package:test/test.dart';

void main() {
  var strTag = new Tag('Tag1', id: 'TAG_1_ID');
  var numTag = new Tag('Tag2', id: 'TAG_2_ID');
  var boolTag = new Tag('Tag3', id: 'TAG_3_ID');

  group('Book', () {
    test('should serialize into JSON', () {
      var givenBook = new Book(
        'Book title',
        155,
        [
          new Author(
            'Author name',
            id: 'AUTHOR_ID',
            imageUrl: 'author/image.png',
            tags: [
              new StringTagValue(strTag, 'String tag value'),
              new BoolTagValue(boolTag, true),
              new NumTagValue(numTag, 1),
              new NumTagValue(numTag, 0.5),
            ],
          ),
        ],
        id: 'BOOK_ID',
        coverImageUrl: 'book/cover/image.png',
        tags: [
          new StringTagValue(strTag, 'String tag value'),
          new BoolTagValue(boolTag, true),
          new NumTagValue(numTag, 1),
          new NumTagValue(numTag, 0.5),
        ],
      );

      var actual = JSON.encode(givenBook.toJson());

      var expected =
          '{"id":"BOOK_ID","title":"Book title","numberOfPages":155,"coverImageUrl":"book/cover/image.png","authors":[{"id":"AUTHOR_ID","name":"Author name","imageUrl":"author/image.png","tags":[{"tag":{"id":"TAG_1_ID","name":"Tag1"},"value":"String tag value","type":"String"},{"tag":{"id":"TAG_3_ID","name":"Tag3"},"value":true,"type":"bool"},{"tag":{"id":"TAG_2_ID","name":"Tag2"},"value":1,"type":"num"},{"tag":{"id":"TAG_2_ID","name":"Tag2"},"value":0.5,"type":"num"}]}],"tags":[{"tag":{"id":"TAG_1_ID","name":"Tag1"},"value":"String tag value","type":"String"},{"tag":{"id":"TAG_3_ID","name":"Tag3"},"value":true,"type":"bool"},{"tag":{"id":"TAG_2_ID","name":"Tag2"},"value":1,"type":"num"},{"tag":{"id":"TAG_2_ID","name":"Tag2"},"value":0.5,"type":"num"}]}';
      expect(actual, equals(expected));
    });

    test('should deserialize from JSON', () {
      var givenJson =
          '{"id":"BOOK_ID","title":"Book title","numberOfPages":155,"coverImageUrl":"book/cover/image.png","authors":[{"id":"AUTHOR_ID","name":"Author name","imageUrl":"author/image.png","tags":[{"tag":{"id":"TAG_1_ID","name":"Tag1"},"value":"String tag value","type":"String"},{"tag":{"id":"TAG_3_ID","name":"Tag3"},"value":true,"type":"bool"},{"tag":{"id":"TAG_2_ID","name":"Tag2"},"value":1,"type":"num"},{"tag":{"id":"TAG_2_ID","name":"Tag2"},"value":0.5,"type":"num"}]}],"tags":[{"tag":{"id":"TAG_1_ID","name":"Tag1"},"value":"String tag value","type":"String"},{"tag":{"id":"TAG_3_ID","name":"Tag3"},"value":true,"type":"bool"},{"tag":{"id":"TAG_2_ID","name":"Tag2"},"value":1,"type":"num"},{"tag":{"id":"TAG_2_ID","name":"Tag2"},"value":0.5,"type":"num"}]}';

      var actual = Book.fromJson(JSON.decode(givenJson));

      var expected = new Book(
        'Book title',
        155,
        [
          new Author(
            'Author name',
            id: 'AUTHOR_ID',
            imageUrl: 'author/image.png',
            tags: [
              new StringTagValue(strTag, 'String tag value'),
              new BoolTagValue(boolTag, true),
              new NumTagValue(numTag, 1),
              new NumTagValue(numTag, 0.5),
            ],
          ),
        ],
        id: 'BOOK_ID',
        coverImageUrl: 'book/cover/image.png',
        tags: [
          new StringTagValue(strTag, 'String tag value'),
          new BoolTagValue(boolTag, true),
          new NumTagValue(numTag, 1),
          new NumTagValue(numTag, 0.5),
        ],
      );
      expect(actual, equals(expected));
    });
  });
}
