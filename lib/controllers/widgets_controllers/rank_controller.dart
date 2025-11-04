import 'package:get/get.dart';

class RankItem {
  final int rank;
  final String name;
  final int level;
  final int points;
  final int score;
  final bool isHighlighted;

  RankItem({
    required this.rank,
    required this.name,
    required this.level,
    required this.points,
    required this.score,
    this.isHighlighted = false,
  });
}

class RankController extends GetxController {
  var ranks = <RankItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Example data
    ranks.value = [
      RankItem(rank: 32, name: "You", level: 1, points: 2000, score: 110, isHighlighted: true),
      RankItem(rank: 4, name: "Adam", level: 5, points: 2000, score: 570),
      RankItem(rank: 5, name: "Warner", level: 8, points: 2000, score: 480),
      RankItem(rank: 6, name: "Tasha", level: 3, points: 2000, score: 390),
      RankItem(rank: 7, name: "Liam", level: 4, points: 2000, score: 420),
    ];
  }
}