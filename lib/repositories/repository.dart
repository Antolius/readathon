import 'dart:async';

import 'package:readathon/models/models.dart';


abstract class Repository {

  Future saveBooks(List<Book> books);

  Future sageGoals(List<Goal> goals);

  Future<List<Book>> loadBooks();

  Future<List<Goal>> loadGoals();

}