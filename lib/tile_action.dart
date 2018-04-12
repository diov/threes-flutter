class TileAction {
  final int fromI;
  final int fromJ;
  final int destI;
  final int destJ;
  final int score;

  TileAction({this.fromI, this.fromJ, this.destI, this.destJ, this.score});

  @override
  String toString() {
    return "fromI: $fromI, fromJ: $fromJ, destI: $destI, destJ: $destJ, score:"
        " $score \n";
  }
}
