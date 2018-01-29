import 'package:readathon/redux/actions/actions.dart';
import 'package:readathon/redux/state.dart';
import 'package:redux/src/utils.dart';

final mainPageReducer = combineTypedReducers<MainPageState>([
  new ReducerBinding<MainPageState, MainPageTabSelectedAction>(
    (_, action) => new MainPageState(activeSection: action.activatedSection),
  ),
]);
