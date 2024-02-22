import 'package:flutter/material.dart';
import 'floor_model/health_database.dart';
import 'floor_model/emotion_recorder_entity.dart';
import 'floor_model/diet_recorder_entity.dart';
import 'floor_model/workout_recorder_entity.dart';
import 'package:intl/intl.dart';

class UserActivityProvider with ChangeNotifier {
  final AppDatabase database;
  DateTime? _lastRecordingTime;
  String? _lastRecordingType;
  int _recordingPts  = 0;
  int _ptsIncremented = 5;

  DateTime? get lastRecordingTime => _lastRecordingTime;
  String? get lastRecordingType => _lastRecordingType;
  int get recordingPoints => _recordingPts;
  int get dedicationLevel => _calculateDedicationLevel();

  UserActivityProvider({required this.database});

  Future<void> showPtsAndAct() async {
    final int emotionPts = await database.emotionRecorderDao.getSumOfPoints() ?? 0;
    final int dietPts = await database.dietRecorderDao.getSumOfPoints() ?? 0;
    final int workoutPts = await database.workoutRecorderDao.getSumOfPoints() ?? 0;

    _recordingPts = emotionPts + dietPts + workoutPts;

    final EmotionEntry? lastEmotion = await database.emotionRecorderDao.getLastRecord();
    final DietEntry? lastDiet = await database.dietRecorderDao.getLastRecord();
    final WorkoutEntry? lastWorkout = await database.workoutRecorderDao.getLastRecord();

    final DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');

    List<MapEntry<String, DateTime>> actCompGroup = [];

    // checks for empty entry
    if (lastEmotion != null) {
      actCompGroup.add(MapEntry('Emotion', format.parse(lastEmotion.recordedTime)));
    }
    if (lastDiet != null) {
      actCompGroup.add(MapEntry('Diet', format.parse(lastDiet.recordedTime)));
    }
    if (lastWorkout != null) {
      actCompGroup.add(MapEntry('Workout', format.parse(lastWorkout.recordedTime)));
    }

    actCompGroup.sort((a, b) => b.value.compareTo(a.value));

    if (actCompGroup.isNotEmpty) {
      final latestActivity = actCompGroup.first;
      _lastRecordingTime = latestActivity.value;
      _lastRecordingType = latestActivity.key;
    }

    notifyListeners();

  }

  int recordActivity(String type) {
    int cPts;
    cPts = _updateRecordingPoints();
    showPtsAndAct();
    notifyListeners();
    return cPts;
  }

  // updates RP, if initial record adds 100 points
  int _updateRecordingPoints() {
    int cPts;
    if (_lastRecordingTime != null) {
      cPts =  _calculatePoints(_ptsIncremented);
      _recordingPts += cPts;
    }else{
      cPts = 100;
      _recordingPts += cPts;
    }
    return cPts;
  }

 // increment by 5 points everytime, max: 100
  int _calculatePoints(int minSinceLastRecord) {
    _ptsIncremented = _ptsIncremented +  5;
    int points = (_ptsIncremented % 100);
    return points;
  }

  //Every 100 points increases DL
  int _calculateDedicationLevel() {
    return _recordingPts ~/ 100;
  }

  // what they might get, use same formula as calculate pts.
  int potentialPoints() {
    if (_lastRecordingTime == null) return 100;
    return (_ptsIncremented + 5) % 100;
  }
}


