import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:threes_game/state.dart';
import 'package:threes_game/action.dart';
import 'package:threes_game/redux.dart';

typedef void Dispatch<ActionType>(ActionType action);
typedef StateType Reducer<StateType, ActionType>(StateType state, ActionType action);
typedef void OnStoreUpdate<ActionType>(StoreUpdate update, Dispatch<ActionType> dispatcher);

class ThreeStore {
  BoardState currentState;

  ThreeStore(this.currentState);

  void dispatch(BuildContext context, ThreeAction action) {
    switch (action.type) {
      case ThreeActionType.Left:
        currentState = currentState.moveLeft();
        break;
      case ThreeActionType.up:
        currentState = currentState.moveUp();
        break;
      case ThreeActionType.right:
        currentState = currentState.moveRight();
        break;
      case ThreeActionType.down:
        currentState = currentState.moveDown();
        break;
    }
  }
}

ThreeStore store = new ThreeStore(BoardState.initiatalState());

class Store<StateType, ActionType> extends StatefulWidget {
  final Widget child;
  final Reducer<StateType, ActionType> reducer;
  final StateType initialState;
  final List<OnStoreUpdate<ActionType>> middleware;

  Store({
    @required this.child,
    @required this.initialState,
    @required this.reducer,
    // this.middleware = const<OnStoreUpdate>[]
  });

  @override
  State createState() => new _StoreState<StateType, ActionType>();

  static StoreUpdate storeStateOf(BuildContext context) {
    final _StoreScope storeScope = context.inheritFromWidgetOfExactType(_StoreScope);
    return storeScope?.state?.update;
  }

  static void dispatch<ActionType>(BuildContext context, ActionType action) {
    final _StoreScope storeScope = context.inheritFromWidgetOfExactType(_StoreScope);
    storeScope.state.dispatch(action);
  }
}

class _StoreScope extends InheritedWidget {
  final _StoreState state;

  _StoreScope(this.state, {Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(_StoreScope old) {
    return true;
  }
}

class _StoreState<StateType, ActionType> extends State<Store<StateType, ActionType>> {
  StoreUpdate<StateType, ActionType> update;

  void dispatch(ActionType action) {
    StateType newState = widget.reducer(update.state, action);
    update = new StoreUpdate<StateType, ActionType>(newState, action, update.state);
    setState(() {});
    new Future(() {
       widget.middleware.forEach((m) { m(update, dispatch); });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _StoreScope(this, child: widget.child);
  }

  @override
  void initState() {
    super.initState();
    print("初始化状态");
    update = new StoreUpdate(widget.initialState, null, null);
    new Future(() {
       widget.middleware.forEach((m) { m(update, dispatch); });
    });
  }
}

class StoreUpdate<StateType, ActionType> {
  final StateType state;
  final ActionType lastAction;
  final StateType previousState;

  const StoreUpdate(this.state, this.lastAction, this.previousState);

  @override
  String toString() {
    return '($state, $lastAction, $previousState)';
  }

  @override
  bool operator==(other) =>
    other is StoreUpdate
    && other.state == state
    && other.lastAction == lastAction
    && other.previousState == previousState;

  @override
  int get hashCode => hashValues(state, lastAction, previousState);
}