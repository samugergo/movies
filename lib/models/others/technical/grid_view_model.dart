class GridViewModel {
  GridViewModel(
      {required this.itemCount,
      required this.crossSpacing,
      required this.mainSpacing,
      required this.itemWidth,
      required this.itemHeight}) {
    aspectRatio = itemWidth / itemHeight;
  }

  final int itemCount;
  final double crossSpacing;
  final double mainSpacing;
  final double itemWidth;
  final double itemHeight;
  double? aspectRatio;
}
