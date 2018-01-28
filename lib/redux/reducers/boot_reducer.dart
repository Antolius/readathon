import 'package:readathon/redux/actions/actions.dart';
import 'package:redux/src/utils.dart';
import 'package:readathon/redux/actions/overlay.dart';

final bootReducer = combineTypedReducers<bool>([
  new ReducerBinding<bool, AppBootedAction>((_, __) => false),
  new ReducerBinding<bool, OverlayErrorAction>((_, __) => false),
]);
