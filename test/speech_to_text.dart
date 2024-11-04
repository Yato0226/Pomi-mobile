import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'pomodoro_timer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PomodoroTimer(),
      child: MaterialApp(
        title: 'Pomodoro Timer',
        home: PomodoroHome(),
      ),
    );
  }
}

class PomodoroHome extends StatefulWidget {
  @override
  _PomodoroHomeState createState() => _PomodoroHomeState();
}

class _PomodoroHomeState extends State<PomodoroHome> {
  late stt.SpeechToText _speech;
  bool _isListening = true;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _startListening();  // Start listening automatically
  }

  void _startListening() async {
    await _speech.initialize();
    setState(() {
      _isListening = true;
    });

    _speech.listen(onResult: (result) {
      setState(() {
        _lastWords = result.recognizedWords;
        if (_lastWords.toLowerCase() == 'start') {
          Provider.of<PomodoroTimer>(context, listen: false).startTimer();
        } else if (_lastWords.toLowerCase() == 'stop') {
          Provider.of<PomodoroTimer>(context, listen: false).stopTimer();
        }
      });
    });
  }

  @override
  void dispose() {
    _speech.stop();  // Ensure listening stops when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<PomodoroTimer>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Pomodoro Timer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              timer.timeFormatted,
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: timer.isRunning ? timer.stopTimer : timer.startTimer,
              child: Text(timer.isRunning ? 'Stop' : 'Start'),
            ),
            SizedBox(height: 20),
            Text('Voice Command: $_lastWords'),
          ],
        ),
      ),
    );
  }
}
