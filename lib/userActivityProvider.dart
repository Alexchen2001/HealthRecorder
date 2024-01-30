import 'package:flutter/material.dart';

class UserActivityProvider with ChangeNotifier {
  DateTime? _lastRecordingTime;
  String? _lastRecordingType;
  int _recordingPts = 0;
  int _ptsIncremented = 5;

  DateTime? get lastRecordingTime => _lastRecordingTime;
  String? get lastRecordingType => _lastRecordingType;
  int get recordingPoints => _recordingPts;
  int get dedicationLevel => _calculateDedicationLevel();

  void recordActivity(String type) {
    _updateRecordingPoints();
    _updateLastRecordingTime();
    _updateLastRecordingType(type);
    notifyListeners();
  }

  void _updateLastRecordingTime() {
    _lastRecordingTime = DateTime.now();
  }

  void _updateLastRecordingType(String type) {
    _lastRecordingType = type;
  }

  // updates RP, if initial record adds 100 points
  void _updateRecordingPoints() {
    if (_lastRecordingTime != null) {
      _recordingPts += _calculatePoints(_ptsIncremented);
    }else{
      _recordingPts += 100;
    }
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
