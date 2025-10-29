import 'package:flutter/material.dart';
import 'frequency_wavelength_page.dart';
import 'main.dart'; // For navigation back to LandingPage.
import 'animations_screen.dart';

class WaveCalculatorPage extends StatefulWidget {
  const WaveCalculatorPage({Key? key}) : super(key: key);

  @override
  State<WaveCalculatorPage> createState() => _WaveCalculatorPageState();
}

class _WaveCalculatorPageState extends State<WaveCalculatorPage> {
  // Default hard-coded values.
  double _frequency = 40000;
  double _wavelength = 0.0375;
  double _velocity = 0; // Calculated as frequency * wavelength

  // Controller for the time input.
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _velocity = _frequency * _wavelength;
  }

  Future<void> _goToFreqWavePage() async {
    final result = await Navigator.push<Map<String, double>>(
      context,
      MaterialPageRoute(
        builder: (_) => FrequencyWavelengthPage(
          initialFrequency: _frequency,
          initialWavelength: _wavelength,
        ),
      ),
    );
    if (result != null && result.containsKey('velocity')) {
      setState(() {
        _frequency = result['frequency']!;
        _wavelength = result['wavelength']!;
        _velocity = result['velocity']!;
      });
    }
  }

  void _calculateDepth() {
    if (_timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the time first!')),
      );
      return;
    }
    try {
      double time = double.parse(_timeController.text);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AnimationsScreen(
            velocity: _velocity,
            timeTaken: time,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid input: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use BG.jpg as the full-screen background.
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/BG.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top row: back button and title.
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LandingPage()),
                        );
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Depth Calculator',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 43, 0, 99),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // Current velocity display.
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Current Velocity: ${_velocity.toStringAsFixed(2)} m/s',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 43, 0, 99),
                  ),
                ),
              ),
              // Center: Time input field.
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextField(
                      controller: _timeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Time Taken (seconds)',
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
              // Bottom: Buttons.
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calculateDepth,
                        child: const Text('Calculate Depth'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _goToFreqWavePage,
                        child: const Text('Calculate Wavelength and Frequency'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
