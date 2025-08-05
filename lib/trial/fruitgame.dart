import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

final AudioPlayer _player = AudioPlayer();

class Letter {
  final String char;
  final int style;

  Letter(this.char, this.style);

  String get fileName => '${char.toUpperCase()}_$style.png';

  @override
  String toString() => char;
}

class FruitGame extends StatefulWidget {
  const FruitGame({super.key});

  @override
  State<FruitGame> createState() => _FruitGameState();
}

class _FruitGameState extends State<FruitGame> {
  int currentIndex = 0;
  bool isCorrect = false;

  final List<Map<String, dynamic>> questions = [
    {"answer": "APEL", "style": 1},
    {"answer": "ANGGUR", "style": 2},
    {"answer": "MANGGA", "style": 3},
    {"answer": "JAMBU", "style": 4},
  ];

  late List<Letter> shuffledLetters;
  late List<Letter?> userAnswer;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  void _loadQuestion() {
    String answer = questions[currentIndex]["answer"];
    int style = questions[currentIndex]["style"];

    List<Letter> letters =
        answer.split('').map((c) => Letter(c, style)).toList();

    letters.shuffle(Random());

    setState(() {
      shuffledLetters = List<Letter>.from(letters);
      userAnswer = List<Letter?>.filled(answer.length, null);
      isCorrect = false;
    });
  }

  Future<void> _playSound() async {
    String answer = questions[currentIndex]["answer"];
    await _player.stop(); // berhentiin dulu kalau ada suara lain
    await _player.play(AssetSource('audioassets/${answer.toLowerCase()}.mp3'));
  }

  Future<void> _checkAnswer() async {
    String correctAnswer = questions[currentIndex]["answer"];
    String userInput = userAnswer.map((l) => l?.char ?? '').join();

    if (!userAnswer.contains(null)) {
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
          } else {
            setState(() {
              isCorrect = false;
              currentIndex = 0;
            });
            _loadQuestion();
          }
        });
      } else {
        Future.delayed(const Duration(milliseconds: 500), () {
          int style = questions[currentIndex]["style"];
          setState(() {
            userAnswer = List<Letter?>.filled(correctAnswer.length, null);
            shuffledLetters = correctAnswer
                .split('')
                .map((c) => Letter(c, style))
                .toList()
              ..shuffle(Random());
            isCorrect = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String answer = questions[currentIndex]["answer"];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/1x/SoalBgmdpi.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: Column(
                key: ValueKey<int>(currentIndex),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 400,
                    child: Image.asset(
                      'assets/Title_Soal.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/1x/${answer.toLowerCase()}_mdpi.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: _playSound,
                            child: Image.asset(
                              'assets/Listen.png',
                              width: 100,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 50),
                      Column(
                        children: [
                          Wrap(
                            spacing: 8,
                            children: List.generate(answer.length, (index) {
                              return DragTarget<Letter>(
                                onWillAccept: (data) =>
                                    userAnswer[index] == null,
                                onAccept: (data) {
                                  setState(() {
                                    userAnswer[index] = data;
                                    shuffledLetters.remove(data);
                                  });
                                  _checkAnswer();
                                },
                                builder:
                                    (context, candidateData, rejectedData) {
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
                                    child: userAnswer[index] != null
                                        ? Image.asset(
                                            'assets/letters/${userAnswer[index]!.fileName}',
                                            width: 40,
                                            height: 50,
                                            fit: BoxFit.contain,
                                          )
                                        : const SizedBox(
                                            width: 40, height: 50),
                                  );
                                },
                              );
                            }),
                          ),
                          const SizedBox(height: 40),
                          Wrap(
                            spacing: 10,
                            children: shuffledLetters.map((letter) {
                              return Draggable<Letter>(
                                data: letter,
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Image.asset(
                                    'assets/letters/${letter.fileName}',
                                    width: 40,
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0.3,
                                  child: Image.asset(
                                    'assets/letters/${letter.fileName}',
                                    width: 40,
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/letters/${letter.fileName}',
                                  width: 40,
                                  height: 50,
                                  fit: BoxFit.contain,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
