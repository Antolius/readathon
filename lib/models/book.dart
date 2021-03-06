import 'package:collection/collection.dart';
import 'package:readathon/models/tag.dart';
import 'package:uuid/uuid.dart';

class Author {
  //TODO: specify
  static const UNKNOWN_IMAGE_URL = 'UNKNOWN_IMAGE_URL';

  final String id;
  final String name;
  final String imageUrl;
  final List<TagValue<dynamic>> tags;

  Author(
    this.name, {
    String id,
    this.imageUrl = UNKNOWN_IMAGE_URL,
    this.tags = const [],
  })
      : this.id = id ?? new Uuid().v4(),
        assert(name != null && name.trim().isNotEmpty),
        assert(imageUrl != null && imageUrl.trim().isNotEmpty),
        assert(tags != null);

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'imageUrl': this.imageUrl,
        'tags': this.tags.map((tag) => tag.toJson()).toList(growable: false),
      };

  static Author fromJson(Map<String, dynamic> json) => new Author(
        json['name'] as String,
        id: json['id'] as String,
        imageUrl: json['imageUrl'] as String,
        tags: (json['tags'] as List<Map<String, dynamic>>)
            .map((tagJson) => TagValue.fromJson(tagJson))
            .toList(growable: false),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Author &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          imageUrl == other.imageUrl &&
          const ListEquality().equals(tags, other.tags);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      imageUrl.hashCode ^
      const ListEquality().hash(tags);
}

class Book {
  //TODO: specify
  static const UNKNOWN_COVER_IMAGE_URL = 'UNKNOWN_COVER_IMAGE_URL';

  final String id;
  final String title;
  final int numberOfPages;
  final String coverImageUrl;
  final List<Author> authors;
  final List<TagValue<dynamic>> tags;

  Book(
    this.title,
    this.numberOfPages,
    this.authors, {
    String id,
    this.coverImageUrl: UNKNOWN_COVER_IMAGE_URL,
    this.tags: const [],
  })
      : this.id = id ?? new Uuid().v4(),
        assert(title != null && title.trim().isNotEmpty),
        assert(numberOfPages != null && numberOfPages > 0),
        assert(authors != null && authors.length > 0),
        assert(coverImageUrl != null && coverImageUrl.trim().isNotEmpty),
        assert(tags != null);

  Book copyWith({
    String id,
    String title,
    int numberOfPages,
    String coverImageUrl,
    List<Author> authors,
    List<TagValue<dynamic>> tags,
  }) =>
      new Book(
        title ?? this.title,
        numberOfPages ?? this.numberOfPages,
        authors ?? this.authors,
        coverImageUrl: coverImageUrl ?? this.coverImageUrl,
        id: id ?? this.id,
        tags: tags ?? this.tags,
      );

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'title': this.title,
        'numberOfPages': this.numberOfPages,
        'coverImageUrl': this.coverImageUrl,
        'authors': this
            .authors
            .map((author) => author.toJson())
            .toList(growable: false),
        'tags': this.tags.map((tag) => tag.toJson()).toList(growable: false),
      };

  static Book fromJson(Map<String, dynamic> json) => new Book(
        json['title'] as String,
        json['numberOfPages'] as int,
        (json['authors'] as List<Map<String, dynamic>>)
            .map((authorJson) => Author.fromJson(authorJson))
            .toList(growable: false),
        id: json['id'] as String,
        coverImageUrl: json['coverImageUrl'] as String,
        tags: (json['tags'] as List<Map<String, dynamic>>)
            .map((tagJson) => TagValue.fromJson(tagJson))
            .toList(growable: false),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          numberOfPages == other.numberOfPages &&
          coverImageUrl == other.coverImageUrl &&
          const ListEquality().equals(authors, other.authors) &&
          const ListEquality().equals(tags, other.tags);

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      numberOfPages.hashCode ^
      coverImageUrl.hashCode ^
      const ListEquality().hash(authors) ^
      const ListEquality().hash(tags);
}
