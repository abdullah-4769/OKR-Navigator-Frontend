import 'package:get/get.dart';

class TopPerformerController extends GetxController {
  /// Selected timeframe
  var selectedTimeframe = "today".obs;

  /// Performers data (API ready structure)
  var performers = <Map<String, dynamic>>[].obs;

  /// Mock Data for now (replace with API call later)
  final mockData = {
    "today": [
      {"name": "Mathew", "score": 1000, "level": 5, "points": 2000},
      {"name": "Liv", "score": 925, "level": 4, "points": 1800},
      {"name": "Maria", "score": 890, "level": 3, "points": 1500},
    ],
    "this_week": [
      {"name": "Alex", "score": 1500, "level": 8, "points": 3000},
      {"name": "Sophia", "score": 1300, "level": 7, "points": 2800},
      {"name": "John", "score": 1200, "level": 6, "points": 2600},
    ],
    "this_month": [
      {"name": "Chris", "score": 2500, "level": 10, "points": 5000},
      {"name": "Ella", "score": 2300, "level": 9, "points": 4700},
      {"name": "Daniel", "score": 2200, "level": 9, "points": 4500},
    ],
  };

  @override
  void onInit() {
    super.onInit();
    fetchPerformers("today");
  }

  void changeTimeframe(String timeframe) {
    selectedTimeframe.value = timeframe;
    fetchPerformers(timeframe);
  }

  void fetchPerformers(String timeframe) {
    performers.assignAll(mockData[timeframe] ?? []);
  }
}
