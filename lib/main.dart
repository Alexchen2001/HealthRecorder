// Alexander Chen
// CPSC 5250 Homework 1
// SUID: 4186272


import 'package:flutter/material.dart';
import 'package:hwone/userActivityWidget.dart';
import 'package:hwone/workoutRecorder.dart';
import 'package:provider/provider.dart';
import './userActivityProvider.dart';
import './emotionRecorder.dart';
import './dietRecorder.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
        create: (context) => UserActivityProvider(),
        child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:Scaffold(
        // appBar: AppBar(
        // actions: [UserActivityWidget(),
        // ]),
        body:PageViewApps(),
      ),
    );
  }
}

class PageViewApps extends StatelessWidget {
  const PageViewApps({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
      body:PageView(
      controller: controller,
      children: [
        EmotionRecorderApp(),
        DietRecorderApp(),
        WorkoutRecorderApp(),
      ],
    ),
      bottomNavigationBar: const UserActivityWidget(),
    );
  }
}




