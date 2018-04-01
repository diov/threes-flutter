import 'package:flutter/widgets.dart';
import 'package:threes_game/state.dart';
import 'package:threes_game/store.dart';
import 'package:threes_game/action.dart';

class ThreeRedux extends StatelessWidget {
  final Widget child;

  ThreeRedux({this.child});

  @override
  Widget build(BuildContext context) {
    print("创建 Redux 对象");
    return new Store<BoardState, ThreeAction>(
      child: child,
      initialState: BoardState.initiatalState(),
      reducer: reduce,
    );
  }

  static BoardState reduce(BoardState state, ThreeAction action) {
    print("Reduce 调用 ${state.tiles} ${action.type}");
    switch (action.type) {
      case ThreeActionType.Left:
        return state.moveLeft();
      case ThreeActionType.up:
        return state.moveUp();
      case ThreeActionType.right:
        return state.moveRight();
      case ThreeActionType.down:
        return state.moveDown();
    }
    return state;
  }

  static StoreUpdate<BoardState, ThreeAction> stateOf(BuildContext context) {
    return Store?.storeStateOf(context);
  }

  static void dispatch(BuildContext context, ThreeAction action) {
    print("分发事件 ${context} ${action}");
    Store?.dispatch(context, action);
  }
}