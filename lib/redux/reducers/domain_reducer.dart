import 'package:readathon/redux/actions/actions.dart';
import 'package:readathon/redux/state.dart';
import 'package:redux/src/utils.dart';

final domainReducer = combineTypedReducers<DomainState>([
  new ReducerBinding<DomainState, AddBookAction>(
    (state, action) => state.withNewBook(action.newBook),
  ),
  new ReducerBinding<DomainState, AddGoalAction>(
    (state, action) => state.withNewGoal(action.newGoal),
  ),
  new ReducerBinding<DomainState, LoadBooksAction>(
    (state, action) => state.copyWith(books: action.books),
  ),
  new ReducerBinding<DomainState, LoadGoalsAction>(
    (state, action) => state.copyWith(goals: action.goals),
  ),
]);
