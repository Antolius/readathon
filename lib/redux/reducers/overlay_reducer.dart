import 'package:readathon/redux/actions/overlay.dart';
import 'package:readathon/redux/state.dart';
import 'package:redux/src/utils.dart';

final overlayReducer = combineTypedReducers<OverlayState>([
  new ReducerBinding<OverlayState, OverlayErrorAction>(
    (_, action) => new OverlayState(),
  ),
]);
