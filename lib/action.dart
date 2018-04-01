
enum ThreeActionType {
  Left,
  right,
  up,
  down
}

class ThreeAction {
  ThreeActionType type;

  ThreeAction(this.type);

  ThreeAction.moveUp() {
    this.type = ThreeActionType.up;
  }

  ThreeAction.moveDown() {
    this.type = ThreeActionType.down;
  }

  ThreeAction.moveLeft() {
    this.type = ThreeActionType.Left;
  }

  ThreeAction.moveRight() {
    this.type = ThreeActionType.right;
  }
}