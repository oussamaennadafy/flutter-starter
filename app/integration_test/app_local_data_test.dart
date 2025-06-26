import 'package:compass_app/config/dependencies.dart';
import 'package:compass_app/main.dart';
import 'package:compass_app/ui/core/ui/custom_checkbox.dart';
import 'package:compass_app/ui/core/ui/home_button.dart';
import 'package:compass_app/ui/home/widgets/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

/// This Integration Test launches the Compass-App with the local configuration.
/// The app uses data from the assets folder to create a booking.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test with local data', () {
    testWidgets('should load app', (tester) async {
      // Load app widget.
      await tester.pumpWidget(
        MultiProvider(providers: providersLocal, child: const MainApp()),
      );
    });

    testWidgets('Open a booking', (tester) async {
      // Load app widget with local configuration
      await tester.pumpWidget(
        MultiProvider(providers: providersLocal, child: const MainApp()),
      );

      await tester.pumpAndSettle();

      // Home screen
      expect(find.byType(HomeScreen), findsOneWidget);
      await tester.pumpAndSettle();

      // Should show user name
      expect(find.text('Sofie\'s Trips'), findsOneWidget);

      // Tap on booking (Alaska is created by default)
      await tester.tap(find.text('Alaska, North America'));
      await tester.pumpAndSettle();

      // Should be at booking screen
      expect(find.text('Alaska'), findsOneWidget);
    });

    testWidgets('Create booking', (tester) async {
      // Load app widget with local configuration
      await tester.pumpWidget(
        MultiProvider(providers: providersLocal, child: const MainApp()),
      );
      await tester.pumpAndSettle();

      // Home screen
      expect(find.byType(HomeScreen), findsOneWidget);
      await tester.pumpAndSettle();

      // Select Europe because it is always the first result
      await tester.tap(find.text('Europe'), warnIfMissed: false);

      // Select dates
      await tester.tap(find.text('Add Dates'));
      await tester.pumpAndSettle();
      final tomorrow = DateTime.now().add(const Duration(days: 1)).day;
      final nextDay = DateTime.now().add(const Duration(days: 2)).day;
      // Select first and last widget that matches today number
      //and tomorrow number, sort of ensures a valid range
      await tester.tap(find.text(tomorrow.toString()).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(nextDay.toString()).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Refresh screen state
      await tester.pumpAndSettle();

      // Select one activity
      await tester.tap(find.byType(CustomCheckbox).first);
      await tester.pumpAndSettle();
      expect(find.text('1 selected'), findsOneWidget);

      // Should be at booking screen
      expect(find.text('Amalfi Coast'), findsOneWidget);

      // Navigate back home
      await tester.tap(find.byType(HomeButton));
      await tester.pumpAndSettle();

      // Home screen
      expect(find.byType(HomeScreen), findsOneWidget);

      // New Booking should appear
      expect(find.text('Amalfi Coast, Europe'), findsOneWidget);
    });
  });
}
