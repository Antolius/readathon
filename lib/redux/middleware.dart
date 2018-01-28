import 'package:readathon/redux/actions/actions.dart';
import 'package:readathon/redux/state.dart';
import 'package:readathon/repositories/repository.dart';
import 'package:redux/src/store.dart';
import 'package:redux/src/utils.dart';

List<Middleware<AppState>> createStoreMiddleware(Repository repo) =>
    combineTypedMiddleware<AppState>([
      loadAll(repo),
      createBook(repo),
      saveBooks(repo),
    ]);

MiddlewareBinding<AppState, BootAppAction> loadAll(Repository repo) =>
    new MiddlewareBinding<AppState, BootAppAction>((store, action, next) {
      repo
          .loadBooks()
          .then((books) => store.dispatch(new LoadBooksAction(books)))
          .then((_) => repo.loadGoals())
          .then((goals) => store.dispatch(new LoadGoalsAction(goals)))
          .then((_) => store.dispatch(const AppBootedAction()))
          .catchError((_) => store.dispatch(
                new OverlayErrorAction(
                  'Failed to boot application.',
                  retryText: 'Try again',
                  onRetry: () => store.dispatch(const BootAppAction()),
                ),
              ));
      next(action);
    });

MiddlewareBinding<AppState, AddBookAction> createBook(Repository repo) =>
    new MiddlewareBinding<AppState, AddBookAction>((store, action, next) {
      next(action);
      repo
          .saveBooks(store.state.domainState.books)
          .catchError((_) => store.dispatch(
                new OverlayErrorAction(
                  'Failed to save books.',
                  retryText: 'Retry',
                  onRetry: () => store.dispatch(const SaveBooksAction()),
                ),
              ));
    });

MiddlewareBinding<AppState, SaveBooksAction> saveBooks(Repository repo) =>
    new MiddlewareBinding<AppState, SaveBooksAction>((store, action, next) {
      next(action);
      repo
          .saveBooks(store.state.domainState.books)
          .catchError((_) => store.dispatch(
                new OverlayErrorAction(
                  'Failed to save books.',
                  retryText: 'Retry',
                  onRetry: () => store.dispatch(const SaveBooksAction()),
                ),
              ));
    });

MiddlewareBinding<AppState, AddGoalAction> createGoal(Repository repo) =>
    new MiddlewareBinding<AppState, AddGoalAction>((store, action, next) {
      next(action);
      repo
          .sageGoals(store.state.domainState.goals)
          .catchError((_) => store.dispatch(
                new OverlayErrorAction(
                  'Failed to save goal.',
                  retryText: 'Retry',
                  onRetry: () => store.dispatch(const SaveGoalsAction()),
                ),
              ));
    });

MiddlewareBinding<AppState, SaveGoalsAction> saveGoals(Repository repo) =>
    new MiddlewareBinding<AppState, SaveGoalsAction>((store, action, next) {
      next(action);
      repo
          .sageGoals(store.state.domainState.goals)
          .catchError((_) => store.dispatch(
                new OverlayErrorAction(
                  'Failed to save goal.',
                  retryText: 'Retry',
                  onRetry: () => store.dispatch(const SaveGoalsAction()),
                ),
              ));
    });
