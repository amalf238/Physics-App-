import 'package:flutter/material.dart';
import 'wave_calculator_page.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Depth Detector',
      home: const LandingPage(),
    );
  }
}

/// LandingPage:
///  - Displays a title, a bouncing wave animation, and a button to navigate to the Depth Calculator.
///  - Uses BG.jpg as the background.
class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use BG.jpg as full-screen background.
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/BG.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Depth Caculator',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 43, 0, 99),
                  ),
                ),
                const SizedBox(height: 40),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    double move = 50 * _animation.value;
                    return Transform.translate(
                      offset: Offset(0, move),
                      child: const Icon(
                        Icons.waves,
                        color: Colors.blue,
                        size: 100,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const WaveCalculatorPage()),
                    );
                  },
                  child: const Text('Go to Depth Calculator'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
