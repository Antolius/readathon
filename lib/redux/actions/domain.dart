import 'package:readathon/models/book.dart';
import 'package:readathon/models/goal.dart';

class AddBookAction {
  final Book newBook;

  const AddBookAction(this.newBook);
}

class AddGoalAction {
  final Goal newGoal;

  const AddGoalAction(this.newGoal);
}

class LoadBooksAction {
  final Iterable<Book> books;

  const LoadBooksAction(this.books);
}

class LoadGoalsAction {
  final Iterable<Goal> goals;

  const LoadGoalsAction(this.goals);
}

class SaveBooksAction {
  const SaveBooksAction();
}

class SaveGoalsAction {
  const SaveGoalsAction();
}
