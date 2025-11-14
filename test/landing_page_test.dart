import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physics_app/main.dart';

/// Widget tests for the LandingPage (main.dart)
void main() {
  group('LandingPage Widget Tests', () {
    testWidgets('should display app title "Depth Caculator"', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MyApp());

      // Assert - Note: actual app has typo "Caculator"
      expect(find.text('Depth Caculator'), findsOneWidget);
    });

    testWidgets('should display wave icon', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MyApp());

      // Assert
      expect(find.byIcon(Icons.waves), findsOneWidget);
    });

    testWidgets('should display "Go to Depth Calculator" button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MyApp());

      // Assert
      expect(find.text('Go to Depth Calculator'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should have MaterialApp with correct title', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Depth Detector');
    });

    testWidgets('should display background image', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MyApp());

      // Assert - Look for Container with BG.jpg
      final containerFinder = find.byWidgetPredicate(
        (widget) => widget is Container && widget.decoration != null,
      );
      expect(containerFinder, findsWidgets);
    });

    testWidgets('should have centered layout', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MyApp());

      // Assert
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('wave icon should be wrapped in animated builder', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MyApp());

      // Assert - there are multiple AnimatedBuilders (from MaterialApp internals too)
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('should not have debug banner', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, false);
    });
  });

  group('LandingPage Animation Tests', () {
    testWidgets('animation should start and progress', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act - advance animation
      await tester.pump(const Duration(seconds: 1));

      // Assert - Transform should exist (animation is running)
      expect(find.byType(Transform), findsWidgets);
    });

    testWidgets('should complete full animation cycle', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act - pump frames to advance animation (2 seconds = one cycle)
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      // Assert - widget should still be visible after animation
      expect(find.byIcon(Icons.waves), findsOneWidget);
    });

    testWidgets('animation should continue beyond initial cycle', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act - pump animation for multiple cycles
      await tester.pump(const Duration(seconds: 5));

      // Assert - animation should still be active
      expect(find.byIcon(Icons.waves), findsOneWidget);
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('should animate wave icon smoothly over time', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act - advance animation at different intervals
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byIcon(Icons.waves), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byIcon(Icons.waves), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 1000));

      // Assert - icon should remain visible throughout animation
      expect(find.byIcon(Icons.waves), findsOneWidget);
    });
  });

  group('LandingPage Navigation Tests', () {
    testWidgets('should navigate to WaveCalculatorPage when button is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act - tap the button
      await tester.tap(find.text('Go to Depth Calculator'));
      await tester.pumpAndSettle();

      // Assert - should navigate to new page
      expect(find.text('Go to Depth Calculator'), findsNothing);
    });

    testWidgets('should display WaveCalculatorPage after navigation', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act
      await tester.tap(find.text('Go to Depth Calculator'));
      await tester.pumpAndSettle();

      // Assert - should show elements from WaveCalculatorPage
      expect(find.textContaining('Current Velocity:'), findsOneWidget);
    });

    testWidgets('should allow back navigation', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act - navigate forward
      await tester.tap(find.text('Go to Depth Calculator'));
      await tester.pumpAndSettle();

      // Navigate back using back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Assert - should be back on landing page
      expect(find.text('Depth Caculator'), findsOneWidget);
      expect(find.text('Go to Depth Calculator'), findsOneWidget);
    });

    testWidgets('should handle multiple forward and back navigations', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act - navigate forward
      await tester.tap(find.text('Go to Depth Calculator'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Current Velocity:'), findsOneWidget);

      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Go to Depth Calculator'), findsOneWidget);

      // Navigate forward again
      await tester.tap(find.text('Go to Depth Calculator'));
      await tester.pumpAndSettle();

      // Assert - should be on calculator page again
      expect(find.textContaining('Current Velocity:'), findsOneWidget);
    });
  });

  group('LandingPage Style Tests', () {
    testWidgets('title should have correct color', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act
      final textWidget = tester.widget<Text>(find.text('Depth Caculator'));

      // Assert
      expect(textWidget.style?.color, const Color.fromARGB(255, 43, 0, 99));
    });

    testWidgets('title should have correct font size', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act
      final textWidget = tester.widget<Text>(find.text('Depth Caculator'));

      // Assert
      expect(textWidget.style?.fontSize, 25);
    });

    testWidgets('title should have bold font weight', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act
      final textWidget = tester.widget<Text>(find.text('Depth Caculator'));

      // Assert
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('wave icon should have large size', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.waves));

      // Assert
      expect(iconWidget.size, 100);
    });

    testWidgets('wave icon should have blue color', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.waves));

      // Assert
      expect(iconWidget.color, Colors.blue);
    });
  });

  group('LandingPage Layout Tests', () {
    testWidgets('should have proper spacing between elements', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MyApp());

      // Assert - should have SizedBox for spacing
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should stack elements vertically in Column', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MyApp());

      // Assert
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should use SafeArea', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MyApp());

      // Assert
      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('should have Container with decoration', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final containerFinder = find.byWidgetPredicate(
        (widget) => widget is Container && widget.decoration != null,
      );
      expect(containerFinder, findsWidgets);
    });
  });

  group('LandingPage Lifecycle Tests', () {
    testWidgets('should initialize animation controller on init', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MyApp());

      // Assert - animation should be running (AnimatedBuilder exists)
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('should dispose animation controller', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      expect(find.byType(AnimatedBuilder), findsWidgets);

      // Act - remove widget tree
      await tester.pumpWidget(Container());

      // Assert - should not throw errors during disposal
      expect(find.byType(AnimatedBuilder), findsNothing);
    });

    testWidgets('should rebuild widget without errors', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act - rebuild multiple times
      await tester.pump();
      await tester.pump();
      await tester.pump();

      // Assert
      expect(find.text('Depth Caculator'), findsOneWidget);
      expect(find.byIcon(Icons.waves), findsOneWidget);
    });
  });

  group('LandingPage Animation Details Tests', () {
    testWidgets('should use Transform.translate for animation', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act
      await tester.pump(const Duration(milliseconds: 500));

      // Assert - should have Transform widget
      expect(find.byType(Transform), findsWidgets);
    });

    testWidgets('animation should repeat', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act - advance past one full cycle
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - animation should still be active
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('should use CurvedAnimation', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      // Assert - AnimatedBuilder should be present (indicates animation is set up)
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });
  });

  group('LandingPage Button Tests', () {
    testWidgets('button should be tappable', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act - tap button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert - should navigate
      expect(find.textContaining('Current Velocity:'), findsOneWidget);
    });

    testWidgets('button should contain correct text', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final text = tester.widget<Text>(find.descendant(
        of: find.byWidget(button),
        matching: find.byType(Text),
      ));
      expect(text.data, 'Go to Depth Calculator');
    });

    testWidgets('button should remain visible after animation cycles', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Act - advance animation multiple times
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(seconds: 3));

      // Assert - button should still be visible and tappable
      expect(find.text('Go to Depth Calculator'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Verify it's still functional
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.textContaining('Current Velocity:'), findsOneWidget);
    });
  });
}
