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
              'Assets/1x/MaterialBgmdpi.png',
              fit: BoxFit.cover,
            ),
          ),
          // Semi-transparent overlay
          // Positioned.fill(
          //   child: Container(color: Colors.black.withOpacity(0.1)),
          // ),
          // Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'Assets/1x/ArrowLeftmdpi.png', // Ganti dengan path PNG kamu
                        width: 80,
                        height: 80,
                        // color: Colors
                        //     .white, // opsional: hanya berfungsi jika PNG hitam putih (monochrome)
                      ),
                      onPressed: _goToPrevious,
                    ),
                    const SizedBox(width: 100),
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
                        animalName: animals[currentIndex], // misalnya: "cat"
                      ),
                    ),

                    // AnimatedSwitcher(
                    //   duration: const Duration(milliseconds: 500),
                    //   transitionBuilder:
                    //       (Widget child, Animation<double> animation) {
                    //     final offsetAnimation = Tween<Offset>(
                    //       begin: const Offset(1, 0),
                    //       end: Offset.zero,
                    //     ).animate(animation);
                    //     return SlideTransition(
                    //         position: offsetAnimation, child: child);
                    //   },
                    //   child: Text(
                    //     animals[currentIndex],
                    //     key: ValueKey<String>(animals[currentIndex]),
                    //     style: const TextStyle(
                    //       fontSize: 48,
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.bold,
                    //       shadows: [
                    //         Shadow(color: Colors.black, blurRadius: 10)
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(width: 100),
                    IconButton(
                      icon: Image.asset(
                        'Assets/1x/ArrowRightmdpi.png', // Ganti dengan path PNG kamu
                        width: 80,
                        height: 80,
                        // color: Colors
                        //     .white, // opsional: hanya berfungsi jika PNG hitam putih (monochrome)
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

class AnimalDisplayWidget extends StatelessWidget {
  final String animalName;

  const AnimalDisplayWidget({
    super.key,
    required this.animalName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'Assets/1x/${animalName}mdpi.png',
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'Assets/1x/${animalName}titlemdpi.png',
              width: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            Image.asset(
              'Assets/1x/${animalName}text.png',
              width: 150,
              fit: BoxFit.contain,
            ),
          ],
        ),

        const SizedBox(height: 16),
        // Image.asset(
        //   'Assets/1x/${animalName}mdpi.png',
        //   width: 250,
        // ),
      ],
    );
  }
}
