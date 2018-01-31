import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:readathon/models/book.dart';
import 'package:readathon/models/goal.dart';
import 'package:readathon/repositories/repository.dart';

class FileRepository extends Repository {
  final Future<Directory> Function() _rootDirectoryProvider;

  FileRepository(this._rootDirectoryProvider);

  Future<File> get _booksFile async {
    var rootDir = await _rootDirectoryProvider();
    return new File('${rootDir.path}/books.json');
  }

  Future<File> get _goalsFile async {
    var rootDir = await _rootDirectoryProvider();
    return new File('${rootDir.path}/goals.json');
  }

  @override
  Future<List<Book>> loadBooks() async {
    var file = await _booksFile;
    var booksJsonString = await file.readAsString();
    List<Map<String, dynamic>> booksJsonMaps = JSON.decode(booksJsonString);
    return booksJsonMaps
        .map((json) => Book.fromJson(json))
        .toList(growable: false);
  }

  @override
  Future<List<Goal>> loadGoals() async {
    var file = await _goalsFile;
    var goalsJsonString = await file.readAsString();
    List<Map<String, dynamic>> goalsJsonMaps = JSON.decode(goalsJsonString);
    return goalsJsonMaps
        .map((json) => Goal.fromJson(json))
        .toList(growable: false);
  }

  @override
  Future sageGoals(List<Goal> goals) async {
    var jsonString = JSON.encode(goals.map((goal) => goal.toJson()));
    var file = await _goalsFile;
    await file.writeAsString(jsonString);
  }

  @override
  Future saveBooks(List<Book> books) async {
    var jsonString = JSON.encode(books.map((book) => book.toJson()).toList(growable: false));
    var file = await _booksFile;
    await file.writeAsString(jsonString);
  }
}
