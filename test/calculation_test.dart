import 'package:flutter_test/flutter_test.dart';

/// Unit tests for physics calculations used in the Depth Detector app
void main() {
  group('Velocity Calculation Tests', () {
    test('should calculate velocity correctly with positive values', () {
      // Arrange
      const frequency = 40000.0; // Hz
      const wavelength = 0.0375; // meters

      // Act
      final velocity = frequency * wavelength;

      // Assert
      expect(velocity, 1500.0); // Expected: 1500 m/s
    });

    test('should calculate velocity with different frequency', () {
      // Arrange
      const frequency = 50000.0;
      const wavelength = 0.03;

      // Act
      final velocity = frequency * wavelength;

      // Assert
      expect(velocity, 1500.0);
    });

    test('should calculate velocity with decimal values', () {
      // Arrange
      const frequency = 12345.67;
      const wavelength = 0.089;

      // Act
      final velocity = frequency * wavelength;

      // Assert
      expect(velocity, closeTo(1098.76, 0.01));
    });

    test('should return zero when frequency is zero', () {
      // Arrange
      const frequency = 0.0;
      const wavelength = 0.0375;

      // Act
      final velocity = frequency * wavelength;

      // Assert
      expect(velocity, 0.0);
    });

    test('should return zero when wavelength is zero', () {
      // Arrange
      const frequency = 40000.0;
      const wavelength = 0.0;

      // Act
      final velocity = frequency * wavelength;

      // Assert
      expect(velocity, 0.0);
    });
  });

  group('Depth Calculation Tests', () {
    test('should calculate depth correctly with valid inputs', () {
      // Arrange
      const velocity = 1500.0; // m/s
      const timeTaken = 2.0; // seconds

      // Act
      final depth = (velocity * timeTaken) / 2;

      // Assert
      expect(depth, 1500.0); // Expected: 1500 meters
    });

    test('should calculate depth for small time values', () {
      // Arrange
      const velocity = 1500.0;
      const timeTaken = 0.5;

      // Act
      final depth = (velocity * timeTaken) / 2;

      // Assert
      expect(depth, 375.0);
    });

    test('should calculate depth for large time values', () {
      // Arrange
      const velocity = 1500.0;
      const timeTaken = 10.0;

      // Act
      final depth = (velocity * timeTaken) / 2;

      // Assert
      expect(depth, 7500.0);
    });

    test('should calculate depth with decimal values', () {
      // Arrange
      const velocity = 1487.5;
      const timeTaken = 3.25;

      // Act
      final depth = (velocity * timeTaken) / 2;

      // Assert
      expect(depth, closeTo(2417.19, 0.01));
    });

    test('should return zero when velocity is zero', () {
      // Arrange
      const velocity = 0.0;
      const timeTaken = 2.0;

      // Act
      final depth = (velocity * timeTaken) / 2;

      // Assert
      expect(depth, 0.0);
    });

    test('should return zero when time is zero', () {
      // Arrange
      const velocity = 1500.0;
      const timeTaken = 0.0;

      // Act
      final depth = (velocity * timeTaken) / 2;

      // Assert
      expect(depth, 0.0);
    });

    test('should divide by 2 for round trip time', () {
      // The formula divides by 2 because the wave travels down and back up
      // Arrange
      const velocity = 1000.0;
      const timeTaken = 4.0;

      // Act
      final depth = (velocity * timeTaken) / 2;

      // Assert
      expect(depth, 2000.0); // Not 4000, because round trip
    });
  });

  group('Pulse Duration Calculation Tests', () {
    test('should calculate pulse duration correctly', () {
      // Arrange
      const timeTaken = 2.0; // seconds
      const scalingFactor = 0.1;

      // Act
      final pulseDuration = (timeTaken * scalingFactor * 500).toInt();

      // Assert
      expect(pulseDuration, 100); // milliseconds
    });

    test('should calculate pulse duration for small time', () {
      // Arrange
      const timeTaken = 0.5;
      const scalingFactor = 0.1;

      // Act
      final pulseDuration = (timeTaken * scalingFactor * 500).toInt();

      // Assert
      expect(pulseDuration, 25);
    });

    test('should calculate pulse duration for large time', () {
      // Arrange
      const timeTaken = 10.0;
      const scalingFactor = 0.1;

      // Act
      final pulseDuration = (timeTaken * scalingFactor * 500).toInt();

      // Assert
      expect(pulseDuration, 500);
    });

    test('should round down pulse duration to integer', () {
      // Arrange
      const timeTaken = 1.99;
      const scalingFactor = 0.1;

      // Act
      final pulseDuration = (timeTaken * scalingFactor * 500).toInt();

      // Assert
      expect(pulseDuration, 99); // Truncated, not rounded
    });

    test('should return zero when time is zero', () {
      // Arrange
      const timeTaken = 0.0;
      const scalingFactor = 0.1;

      // Act
      final pulseDuration = (timeTaken * scalingFactor * 500).toInt();

      // Assert
      expect(pulseDuration, 0);
    });

    test('should calculate pulse duration with different scaling factor', () {
      // Arrange
      const timeTaken = 4.0;
      const scalingFactor = 0.2;

      // Act
      final pulseDuration = (timeTaken * scalingFactor * 500).toInt();

      // Assert
      expect(pulseDuration, 400);
    });
  });

  group('Combined Physics Calculations Tests', () {
    test('should calculate full depth from frequency and wavelength', () {
      // Arrange
      const frequency = 40000.0;
      const wavelength = 0.0375;
      const timeTaken = 2.0;

      // Act
      final velocity = frequency * wavelength;
      final depth = (velocity * timeTaken) / 2;

      // Assert
      expect(velocity, 1500.0);
      expect(depth, 1500.0);
    });

    test('should handle complete calculation chain', () {
      // Arrange
      const frequency = 50000.0;
      const wavelength = 0.03;
      const timeTaken = 4.0;

      // Act
      final velocity = frequency * wavelength;
      final depth = (velocity * timeTaken) / 2;
      final pulseDuration = (timeTaken * 0.1 * 500).toInt();

      // Assert
      expect(velocity, 1500.0);
      expect(depth, 3000.0);
      expect(pulseDuration, 200);
    });
  });

  group('Edge Cases and Boundary Tests', () {
    test('should handle very small frequency', () {
      // Arrange
      const frequency = 0.001;
      const wavelength = 1000.0;

      // Act
      final velocity = frequency * wavelength;

      // Assert
      expect(velocity, 1.0);
    });

    test('should handle very large values', () {
      // Arrange
      const frequency = 1000000.0;
      const wavelength = 10.0;
      const timeTaken = 100.0;

      // Act
      final velocity = frequency * wavelength;
      final depth = (velocity * timeTaken) / 2;

      // Assert
      expect(velocity, 10000000.0);
      expect(depth, 500000000.0);
    });

    test('should handle negative values (invalid but should calculate)', () {
      // Note: In real app, these should be validated by UI
      // Arrange
      const frequency = -40000.0;
      const wavelength = 0.0375;

      // Act
      final velocity = frequency * wavelength;

      // Assert
      expect(velocity, -1500.0); // Mathematically correct, physically invalid
    });

    test('should handle extremely precise decimal values', () {
      // Arrange
      const frequency = 123456.789123;
      const wavelength = 0.012345678;

      // Act
      final velocity = frequency * wavelength;

      // Assert
      expect(velocity, closeTo(1524.157, 0.001));
    });

    test('should handle depth calculation with very small values', () {
      // Arrange
      const velocity = 1500.0;
      const timeTaken = 0.001; // 1 millisecond

      // Act
      final depth = (velocity * timeTaken) / 2;

      // Assert
      expect(depth, 0.75); // 0.75 meters or 75 cm
    });
  });
}
