import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'pomodoro_timer.dart'; // Assuming you have this file for timer logic

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PomodoroTimer(),
      child: MaterialApp(
        title: 'Futuristic Pomodoro Timer',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blueAccent,
          textTheme: TextTheme(
            bodyMedium: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
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
  bool _isListening = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _startListening();
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
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<PomodoroTimer>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueGrey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                timer.timeFormatted,
                style: TextStyle(
                  fontSize: 48,
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: timer.isRunning ? timer.stopTimer : timer.startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: Text(
                  timer.isRunning ? 'Stop' : 'Start',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Voice Command: $_lastWords',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
