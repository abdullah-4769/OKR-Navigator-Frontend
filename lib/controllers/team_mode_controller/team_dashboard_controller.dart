import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamDashboardController extends GetxController {
  var teamName = "Team Alpha".obs;
  var teamLevel = 5.obs;
  var successRate = 85.obs;

  var badges = 12.obs;
  var trophies = 16.obs;
  var games = 8.obs;

  var achievements = <Map<String, dynamic>>[
    {'key': 'Strategic Thinker', 'done': true,  'icon': Icons.emoji_events, },
    {'key': 'Goal Master', 'done': true,  'icon': Icons.emoji_events, },
    {'key': 'Innovation Expert', 'done': true,  'icon': Icons.emoji_events,},
    {'key': 'Challenge Solver', 'done': true,  'icon': Icons.emoji_events,},
  ].obs;

  var feedbackList = <Map<String, dynamic>>[
    {
      'name': 'Johnson',
      'role': 'Strategist',
      'level': 5,
      'avatar': 'assets/images/solop.png',
      'message': 'Nice! I drew "Digital Transformation Initiative". These strategies complement each other well!',
      'rating': 4
    },
    {
      'name': 'Tasha',
      'role': 'Strategist',
      'level': 5,
      'avatar': 'assets/images/solo2.png',
      'message': 'Excellent strategic thinking on the market analysis. Your insights really helped shape',
      'rating': 4
    },
  ].obs;

  var recentGames = <Map<String, dynamic>>[
    {
      'title': 'Solo Campaign - Level 1',
      'date': 'Jan 15, 2025',
      'score': 85
    },
    {'title': 'Team Challenge', 'date': 'Jan 12, 2025', 'score': 92},
  ].obs;

  double progressValue() => successRate.value / 100;
}
