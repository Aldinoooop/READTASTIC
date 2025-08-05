// import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.landscapeRight,
//     DeviceOrientation.landscapeLeft,
//   ]);
//   runApp(const MaterialApp(home: AnimalSwitcher()));
// }

class AnimalSwitcher extends StatefulWidget {
  const AnimalSwitcher({super.key});

  @override
  State<AnimalSwitcher> createState() => _AnimalSwitcherState();
}

class _AnimalSwitcherState extends State<AnimalSwitcher> {
  final List<String> animals = ['Ayam', 'Babi', 'Cicak', 'Domba'];
  int currentIndex = 0;

  void _goToNext() {
    setState(() {
      currentIndex = (currentIndex + 1) % animals.length;
    });
  }

  void _goToPrevious() {
    setState(() {
      currentIndex = (currentIndex - 1 + animals.length) % animals.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/1x/MaterialBgmdpi.png',
              fit: BoxFit.cover,
            ),
          ),

          // KIRI: asset36 besar di bawah
          Positioned(
            left: 0,
            bottom: 0,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  alignment: Alignment.bottomLeft,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/1x/asset36.png',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // KANAN: asset36 besar di bawah
          Positioned(
            right: 0,
            bottom: 0,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  alignment: Alignment.bottomRight,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/1x/asset36.png',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Konten tengah
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/1x/ArrowLeftmdpi.png',
                        width: 80,
                        height: 80,
                      ),
                      onPressed: _goToPrevious,
                    ),
                    const SizedBox(width: 50),

                    // Hewan tampil tengah
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        final offsetAnimation = Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(animation);
                        return SlideTransition(
                            position: offsetAnimation, child: child);
                      },
                      child: AnimalDisplayWidget(
                        key: ValueKey<String>(animals[currentIndex]),
                        animalName: animals[currentIndex],
                      ),
                    ),

                    const SizedBox(width: 50),
                    IconButton(
                      icon: Image.asset(
                        'assets/1x/ArrowRightmdpi.png',
                        width: 80,
                        height: 80,
                      ),
                      onPressed: _goToNext,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

class AnimalDisplayWidget extends StatefulWidget {
  final String animalName;

  const AnimalDisplayWidget({
    super.key,
    required this.animalName,
  });

  @override
  State<AnimalDisplayWidget> createState() => _AnimalDisplayWidgetState();
}

class _AnimalDisplayWidgetState extends State<AnimalDisplayWidget>
    with SingleTickerProviderStateMixin {
  double _scale = 0;

  @override
  void initState() {
    super.initState();
    // Trigger animasi saat build
    Future.delayed(Duration.zero, () {
      setState(() {
        _scale = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      tween: Tween<double>(begin: 0, end: _scale),
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/1x/${widget.animalName}mdpi.png',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Judul
              Container(
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.blue), // Outline biru
                // ),
                height: 80,
                width: 100,
                child: Image.asset(
                  'assets/1x/${widget.animalName}titlemdpi.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 5),

              // Gambar Teks
              Container(
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.blue), // Outline biru
                // ),
                height: 100,
                width: 100,
                child: Image.asset(
                  'assets/1x/${widget.animalName}textmdpi.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
