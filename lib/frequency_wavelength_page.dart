import 'package:flutter/material.dart';

/// FrequencyWavelengthPage:
///   - Allows the user to update frequency and wavelength.
///   - Displays the calculated velocity.
///   - Has a "Save & Back" button that returns the updated values to WaveCalculatorPage.
class FrequencyWavelengthPage extends StatefulWidget {
  final double initialFrequency;
  final double initialWavelength;

  const FrequencyWavelengthPage({
    Key? key,
    required this.initialFrequency,
    required this.initialWavelength,
  }) : super(key: key);

  @override
  State<FrequencyWavelengthPage> createState() =>
      _FrequencyWavelengthPageState();
}

class _FrequencyWavelengthPageState extends State<FrequencyWavelengthPage> {
  late TextEditingController _frequencyController;
  late TextEditingController _wavelengthController;

  double _velocity = 0;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with passed-in values.
    _frequencyController =
        TextEditingController(text: widget.initialFrequency.toString());
    _wavelengthController =
        TextEditingController(text: widget.initialWavelength.toString());

    // Calculate initial velocity.
    _velocity = widget.initialFrequency * widget.initialWavelength;
  }

  @override
  void dispose() {
    _frequencyController.dispose();
    _wavelengthController.dispose();
    super.dispose();
  }

  /// Recalculate velocity whenever frequency or wavelength fields change.
  void _updateVelocity() {
    try {
      double freq = double.parse(_frequencyController.text);
      double wave = double.parse(_wavelengthController.text);
      setState(() {
        _velocity = freq * wave;
      });
    } catch (_) {
      setState(() {
        _velocity = 0;
      });
    }
  }

  /// Return updated frequency, wavelength, and velocity via Navigator.pop.
  void _saveAndBack() {
    try {
      double freq = double.parse(_frequencyController.text);
      double wave = double.parse(_wavelengthController.text);
      double vel = freq * wave;
      Navigator.pop(context, {
        'frequency': freq,
        'wavelength': wave,
        'velocity': vel,
      });
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
          // A Column with spaceBetween to position the title at the top,
          // the inputs (and calculated velocity) in the center, and the button at the bottom.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top: Title.
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Change Frequency & Wavelength',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 43, 0, 99),
                  ),
                ),
              ),
              // Middle: Input fields and calculated velocity.
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Frequency input box.
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: TextField(
                          controller: _frequencyController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Frequency (Hz)',
                              filled: true,
                              fillColor: Colors.white70),
                          onChanged: (value) => _updateVelocity(),
                        ),
                      ),
                      // Wavelength input box.
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: TextField(
                          controller: _wavelengthController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Wavelength (meters)',
                              filled: true,
                              fillColor: Colors.white70),
                          onChanged: (value) => _updateVelocity(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Calculated Velocity: ${_velocity.toStringAsFixed(2)} m/s',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 43, 0, 99),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom: "Save & Back" button.
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveAndBack,
                    child: const Text('Save & Back'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
