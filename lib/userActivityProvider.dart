import 'package:flutter/material.dart';

class UserActivityProvider with ChangeNotifier {
  DateTime? _lastRecordingTime;
  String? _lastRecordingType;
  int _recordingPts = 0;
  final int maxPoints = 100; // Maximum points for a recording

  DateTime? get lastRecordingTime => _lastRecordingTime;
  String? get lastRecordingType => _lastRecordingType;
  int get recordingPoints => _recordingPts;
  int get dedicationLevel => _calculateDedicationLevel();

  // Record a new activity
  void recordActivity(String type) {
    _updateLastRecordingTime();
    _updateLastRecordingType(type);
    _updateRecordingPoints();
    notifyListeners();
  }

  // Update the last recording time
  void _updateLastRecordingTime() {
    _lastRecordingTime = DateTime.now();
  }

  // Update the last recording type
  void _updateLastRecordingType(String type) {
    _lastRecordingType = type;
  }

  // Update recording points based on the time elapsed
  void _updateRecordingPoints() {
    if (_lastRecordingTime != null) {
      int minSinceLastRecord = DateTime.now().difference(_lastRecordingTime!).inMinutes;
      _recordingPts += _calculatePoints(minSinceLastRecord);
    }
  }

  // Calculate points based on minutes since last recording
  int _calculatePoints(int minSinceLastRecord) {
    int points = (minSinceLastRecord / 10).clamp(0, maxPoints).toInt();
    return points;
  }

  // Calculate the dedication level based on recording points
  int _calculateDedicationLevel() {
    return _recordingPts ~/ 100;
  }

  // Calculate potential points if the user records now
  int potentialPoints() {
    if (_lastRecordingTime == null) return 0;
    int minSinceLastRecord = DateTime.now().difference(_lastRecordingTime!).inMinutes;
    return _calculatePoints(minSinceLastRecord);
  }
}
