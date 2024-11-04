import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroTimer with ChangeNotifier {
  Timer? _timer;
  int _remainingSeconds = 1500; // 25 minutes
  bool _isRunning = false;

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;

  void startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    _remainingSeconds = 1500; // Reset to 25 minutes
    notifyListeners();
  }

  String get timeFormatted {
    int minutes = (_remainingSeconds ~/ 60) % 60;
    int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}