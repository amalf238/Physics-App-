import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physics_app/frequency_wavelength_page.dart';

/// Widget tests for FrequencyWavelengthPage
void main() {
  group('FrequencyWavelengthPage Widget Tests', () {
    testWidgets('should display page title', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Assert
      expect(find.text('Change Frequency & Wavelength'), findsOneWidget);
    });

    testWidgets('should display calculated velocity', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Assert - 40000 * 0.0375 = 1500.0
      expect(find.text('Calculated Velocity: 1500.00 m/s'), findsOneWidget);
    });

    testWidgets('should have two TextFields for input', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Assert
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('should display "Save & Back" button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Assert
      expect(find.text('Save & Back'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should have frequency hint text', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField).first);
      expect(textField.decoration?.hintText, 'Frequency (Hz)');
    });

    testWidgets('should have wavelength hint text', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField).last);
      expect(textField.decoration?.hintText, 'Wavelength (meters)');
    });
  });

  group('FrequencyWavelengthPage Initialization Tests', () {
    testWidgets('should initialize frequency field with provided value', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 50000,
          initialWavelength: 0.03,
        ),
      ));

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField).first);
      expect(textField.controller?.text, '50000.0');
    });

    testWidgets('should initialize wavelength field with provided value', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 50000,
          initialWavelength: 0.03,
        ),
      ));

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField).last);
      expect(textField.controller?.text, '0.03');
    });

    testWidgets('should calculate initial velocity from provided values', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 50000,
          initialWavelength: 0.03,
        ),
      ));

      // Assert - 50000 * 0.03 = 1500.0
      expect(find.text('Calculated Velocity: 1500.00 m/s'), findsOneWidget);
    });

    testWidgets('should handle different initial values', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 30000,
          initialWavelength: 0.05,
        ),
      ));

      // Assert - 30000 * 0.05 = 1500.0
      expect(find.text('Calculated Velocity: 1500.00 m/s'), findsOneWidget);
    });
  });

  group('FrequencyWavelengthPage Input Tests', () {
    testWidgets('should accept numeric input in frequency field', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Act - enter new value in first TextField (frequency)
      final frequencyField = find.byType(TextField).first;
      await tester.enterText(frequencyField, '60000');
      await tester.pump();

      // Assert
      final textField = tester.widget<TextField>(frequencyField);
      expect(textField.controller?.text, '60000');
    });

    testWidgets('should accept decimal input in wavelength field', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Act - enter new value in second TextField (wavelength)
      final wavelengthField = find.byType(TextField).last;
      await tester.enterText(wavelengthField, '0.025');
      await tester.pump();

      // Assert
      final textField = tester.widget<TextField>(wavelengthField);
      expect(textField.controller?.text, '0.025');
    });

    testWidgets('both fields should have numeric keyboard', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Act
      final textFields = tester.widgetList<TextField>(find.byType(TextField));

      // Assert
      for (final textField in textFields) {
        expect(textField.keyboardType, TextInputType.number);
      }
    });
  });

  group('FrequencyWavelengthPage Real-time Velocity Update Tests', () {
    testWidgets('should update velocity when frequency changes', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));
      expect(find.text('Calculated Velocity: 1500.00 m/s'), findsOneWidget);

      // Act - change frequency to 60000
      final frequencyField = find.byType(TextField).first;
      await tester.enterText(frequencyField, '60000');
      await tester.pump();

      // Assert - velocity should update to 60000 * 0.0375 = 2250.0
      expect(find.text('Calculated Velocity: 2250.00 m/s'), findsOneWidget);
    });

    testWidgets('should update velocity when wavelength changes', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));
      expect(find.text('Calculated Velocity: 1500.00 m/s'), findsOneWidget);

      // Act - change wavelength to 0.05
      final wavelengthField = find.byType(TextField).last;
      await tester.enterText(wavelengthField, '0.05');
      await tester.pump();

      // Assert - velocity should update to 40000 * 0.05 = 2000.0
      expect(find.text('Calculated Velocity: 2000.00 m/s'), findsOneWidget);
    });

    testWidgets('should update velocity when both values change', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));
      expect(find.text('Calculated Velocity: 1500.00 m/s'), findsOneWidget);

      // Act - change both values
      await tester.enterText(find.byType(TextField).first, '50000');
      await tester.pump();
      await tester.enterText(find.byType(TextField).last, '0.03');
      await tester.pump();

      // Assert - velocity should update to 50000 * 0.03 = 1500.0
      expect(find.text('Calculated Velocity: 1500.00 m/s'), findsOneWidget);
    });

    testWidgets('should show 0.00 m/s when frequency is cleared', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Act - clear frequency field
      await tester.enterText(find.byType(TextField).first, '');
      await tester.pump();

      // Assert
      expect(find.text('Calculated Velocity: 0.00 m/s'), findsOneWidget);
    });

    testWidgets('should show 0.00 m/s when wavelength is cleared', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Act - clear wavelength field
      await tester.enterText(find.byType(TextField).last, '');
      await tester.pump();

      // Assert
      expect(find.text('Calculated Velocity: 0.00 m/s'), findsOneWidget);
    });
  });

  group('FrequencyWavelengthPage Validation Tests', () {
    testWidgets('should show error when frequency is invalid and Save is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Act - clear frequency field
      await tester.enterText(find.byType(TextField).first, '');
      await tester.tap(find.text('Save & Back'));
      await tester.pump();

      // Assert - should show SnackBar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Invalid input'), findsOneWidget);
    });

    testWidgets('should show error when wavelength is invalid and Save is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Act - clear wavelength field
      await tester.enterText(find.byType(TextField).last, '');
      await tester.tap(find.text('Save & Back'));
      await tester.pump();

      // Assert - should show SnackBar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Invalid input'), findsOneWidget);
    });

    testWidgets('should accept valid positive values', (WidgetTester tester) async {
      // Arrange
      Map<String, double>? result;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await Navigator.push<Map<String, double>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FrequencyWavelengthPage(
                      initialFrequency: 40000,
                      initialWavelength: 0.0375,
                    ),
                  ),
                );
              },
              child: const Text('Go'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      // Act - enter valid values
      await tester.enterText(find.byType(TextField).first, '50000');
      await tester.enterText(find.byType(TextField).last, '0.03');
      await tester.tap(find.text('Save & Back'));
      await tester.pumpAndSettle();

      // Assert - should navigate back successfully
      expect(find.text('Go'), findsOneWidget);
    });

    testWidgets('should show error when frequency is negative', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Act - enter negative frequency
      await tester.enterText(find.byType(TextField).first, '-1000');
      await tester.tap(find.text('Save & Back'));
      await tester.pump();

      // Assert - should show SnackBar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Invalid input'), findsOneWidget);
    });

    testWidgets('should handle non-numeric text input gracefully', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Act - enter invalid text
      await tester.enterText(find.byType(TextField).first, 'abc');
      await tester.tap(find.text('Save & Back'));
      await tester.pump();

      // Assert - should show SnackBar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Invalid input'), findsOneWidget);
    });
  });

  group('FrequencyWavelengthPage Navigation Tests', () {
    testWidgets('should navigate back with updated values when Save & Back is tapped', (WidgetTester tester) async {
      // Arrange
      Map<String, double>? result;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await Navigator.push<Map<String, double>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FrequencyWavelengthPage(
                      initialFrequency: 40000,
                      initialWavelength: 0.0375,
                    ),
                  ),
                );
              },
              child: const Text('Go'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      // Act - change values and save
      await tester.enterText(find.byType(TextField).first, '50000');
      await tester.enterText(find.byType(TextField).last, '0.03');
      await tester.tap(find.text('Save & Back'));
      await tester.pumpAndSettle();

      // Assert
      expect(result, isNotNull);
      expect(result!['frequency'], 50000.0);
      expect(result!['wavelength'], 0.03);
      expect(result!['velocity'], 1500.0);
    });

    testWidgets('should not navigate back with invalid values', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Act - enter invalid value
      await tester.enterText(find.byType(TextField).first, '');
      await tester.tap(find.text('Save & Back'));
      await tester.pump();

      // Assert - should still be on the same page and show error
      expect(find.text('Change Frequency & Wavelength'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });

  group('FrequencyWavelengthPage Layout Tests', () {
    testWidgets('should have proper spacing between elements', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Assert
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should use Column for vertical layout', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Assert
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should center content', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Assert
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('should have padding around content', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Assert
      expect(find.byType(Padding), findsWidgets);
    });
  });

  group('FrequencyWavelengthPage Lifecycle Tests', () {
    testWidgets('should dispose controllers properly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));
      expect(find.byType(TextField), findsNWidgets(2));

      // Act - remove widget
      await tester.pumpWidget(Container());

      // Assert - should not throw errors
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('should rebuild without errors', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: FrequencyWavelengthPage(
          initialFrequency: 40000,
          initialWavelength: 0.0375,
        ),
      ));

      // Act
      await tester.pump();
      await tester.pump();

      // Assert
      expect(find.text('Change Frequency & Wavelength'), findsOneWidget);
      expect(find.text('Calculated Velocity: 1500.00 m/s'), findsOneWidget);
    });
  });
}
