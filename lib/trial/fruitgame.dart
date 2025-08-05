import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';

final AudioPlayer _player = AudioPlayer();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.landscapeRight,
//     DeviceOrientation.landscapeLeft,
//   ]);
//   runApp(const MaterialApp(home: FruitGame()));
// }

class FruitGame extends StatefulWidget {
  const FruitGame({super.key});

  @override
  State<FruitGame> createState() => _FruitGameState();
}

class _FruitGameState extends State<FruitGame> {
  int currentIndex = 0;
  bool isCorrect = false;

  final List<Map<String, dynamic>> questions = [
    {"answer": "APEL"},
    {"answer": "ANGGUR"},
    {"answer": "MANGGA"},
    {"answer": "JAMBU"},
    // {"answer": "NANAS"},
    // {"answer": "DURIAN"},
    // {"answer": "APEL"},
    // {"answer": "SEMANGKA"},
  ];

  List<String> shuffledLetters = [];
  List<String?> userAnswer = [];

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  void _loadQuestion() {
    String answer = questions[currentIndex]["answer"];
    List<String> letters = answer.split('');
    letters.shuffle(Random());

    setState(() {
      shuffledLetters = letters;
      userAnswer = List<String?>.filled(answer.length, null);
      isCorrect = false;
    });
  }

  Future<void> _checkAnswer() async {
    String correctAnswer = questions[currentIndex]["answer"];
    String userInput = userAnswer.join();

    if (userInput == correctAnswer) {
      await _player.play(AssetSource('correctsound.mp3'));
      setState(() {
        isCorrect = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (currentIndex < questions.length - 1) {
          setState(() {
            currentIndex++;
          });
          _loadQuestion();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String answer = questions[currentIndex]["answer"];

    return Scaffold(
      body: Stack(
        children: [
          // Background PNG
          Positioned.fill(
            child: Image.asset(
              'assets/1x/SoalBgmdpi.png', // Ganti dengan path sesuai asset kamu
              fit: BoxFit.cover,
            ),
          ),
          // Konten Utama
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Susun nama buah!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Gambar Buah (Slot khusus)
                Image.asset(
                  'assets/1x/${questions[currentIndex]["answer"]!.toLowerCase()}_mdpi.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 20),

                // Slot Jawaban
                Wrap(
                  spacing: 8,
                  children: List.generate(answer.length, (index) {
                    return DragTarget<String>(
                      onAccept: (data) {
                        setState(() {
                          userAnswer[index] = data;
                          shuffledLetters.remove(data);
                        });
                        _checkAnswer();
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          width: 50,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: userAnswer[index] != null
                                  ? Colors.green
                                  : Colors.red,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Text(
                            userAnswer[index] ?? '',
                            style: const TextStyle(fontSize: 24),
                          ),
                        );
                      },
                    );
                  }),
                ),

                const SizedBox(height: 40),

                // Huruf-huruf untuk drag
                Wrap(
                  spacing: 10,
                  children: shuffledLetters.map((letter) {
                    return Draggable<String>(
                      data: letter,
                      feedback: Material(
                        color: Colors.transparent,
                        child: Text(letter,
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: Text(letter,
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                      ),
                      child: Text(letter,
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                    );
                  }).toList(),
                )
              ],
            ),
          ),

          // Icon Benar
          if (isCorrect)
            Center(
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 500),
                child: Icon(Icons.check_circle,
                    size: 120, color: Colors.green[600]),
              ),
            ),
        ],
      ),
    );
  }
}
