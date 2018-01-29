import 'package:readathon/app_sections.dart';
import 'package:readathon/models/models.dart';

class AppState {
  final bool isBooting;
  final DomainState domainState;
  final OverlayState overlayState;
  final MainPageState mainPageState;

  AppState({
    this.isBooting = false,
    this.domainState = const DomainState(),
    this.overlayState = const OverlayState(),
    this.mainPageState = const MainPageState(),
  });

  factory AppState.booting() => new AppState(isBooting: true);

  AppState copyWith({
    bool isBooting,
    DomainState domainState,
    OverlayState overlayState,
    MainPageState mainPageState,
  }) =>
      new AppState(
        isBooting: isBooting ?? this.isBooting,
        domainState: domainState ?? this.domainState,
        overlayState: overlayState ?? this.overlayState,
        mainPageState: mainPageState ?? this.mainPageState,
      );
}

class DomainState {
  final Iterable<Book> books;
  final Iterable<Goal> goals;

  const DomainState({
    this.books: const [],
    this.goals: const [],
  });

  DomainState copyWith({
    Iterable<Book> books,
    Iterable<Goal> goals,
  }) =>
      new DomainState(
        books: books ?? this.books,
        goals: goals ?? this.goals,
      );

  DomainState withNewBook(Book newBook) => copyWith(
        books: new List.from(this.books)..add(newBook),
      );

  DomainState withNewGoal(Goal newGoal) => copyWith(
        goals: new List.from(this.goals)..add(newGoal),
      );
}

class OverlayState {
  final String errorMessage;
  final String retryText;
  final void Function() onRetry;

  const OverlayState({
    this.errorMessage,
    this.retryText,
    this.onRetry,
  });
}

class MainPageState {
  final AppSection activeSection;

  const MainPageState({this.activeSection: AppSection.BOOKS});
}
