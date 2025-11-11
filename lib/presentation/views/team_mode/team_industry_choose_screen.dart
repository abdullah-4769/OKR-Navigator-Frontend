// lib/presentation/views/team_mode/team_industry_choose_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../industry_screens/choose_industry_screen.dart'; // Import the main industry screen

class TeamIndustryChooseScreen extends StatelessWidget {
  const TeamIndustryChooseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChooseIndustryScreen(selectedRole: null);
  }
}