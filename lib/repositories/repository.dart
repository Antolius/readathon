import 'dart:async';

import 'package:readathon/models/models.dart';


abstract class Repository {

  Future saveBooks(Iterable<Book> books);

  Future sageGoals(Iterable<Goal> goals);

  Future<Iterable<Book>> loadBooks();

  Future<Iterable<Goal>> loadGoals();

}