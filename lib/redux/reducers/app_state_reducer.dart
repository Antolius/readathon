import 'package:readathon/redux/reducers/boot_reducer.dart';
import 'package:readathon/redux/reducers/domain_reducer.dart';
import 'package:readathon/redux/reducers/main_page_reducer.dart';
import 'package:readathon/redux/reducers/overlay_reducer.dart';
import 'package:readathon/redux/reducers/add_book_apage_reducer.dart';
import 'package:readathon/redux/state.dart';

AppState appStateReducer(AppState state, dynamic action) => new AppState(
      isBooting: bootReducer(state.isBooting, action),
      domainState: domainReducer(state.domainState, action),
      overlayState: overlayReducer(state.overlayState, action),
      mainPageState: mainPageReducer(state.mainPageState, action),
      addBookPageState: addBookPageReducer(state.addBookPageState, action),
    );
