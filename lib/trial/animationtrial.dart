import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: FlyInTextPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class FlyInTextPage extends StatefulWidget {
  const FlyInTextPage({super.key});

  @override
  State<FlyInTextPage> createState() => _FlyInTextPageState();
}

class _FlyInTextPageState extends State<FlyInTextPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, -1), // Mulai dari luar layar (atas)
      end: Offset.zero,           // Akhir di posisi normal
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward(); // Jalankan animasi saat screen tampil
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SlideTransition(
          position: _animation,
          child: Text(
            "Selamat Datang!",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
