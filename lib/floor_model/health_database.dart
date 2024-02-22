import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'emotion_recorder_entity.dart';
import 'emotion_recorder_dao.dart';

import 'diet_recorder_entity.dart';
import 'diet_recorder_dao.dart';

import 'workout_recorder_entity.dart';
import 'workout_recorder_dao.dart';

part 'health_database.g.dart';

@Database(version: 1, entities: [EmotionEntry, DietEntry,WorkoutEntry])
abstract class AppDatabase extends FloorDatabase {
  EmotionRecorderDao get emotionRecorderDao;
  DietRecorderDao get dietRecorderDao;
  WorkoutRecorderDao get workoutRecorderDao;

}