// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/data/repositories/auth/auth_repository.dart';
import 'package:compass_app/routing/routes.dart';
import 'package:compass_app/ui/home/widgets/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../../../testing/app.dart';
import '../../../../testing/fakes/repositories/fake_auth_repository.dart';
import '../../../../testing/mocks.dart';

void main() {
  group('HomeScreen tests', () {
    late MockGoRouter goRouter;

    setUp(() {
      goRouter = MockGoRouter();
      when(() => goRouter.push(any())).thenAnswer((_) => Future.value(null));
    });

    Future<void> loadWidget(WidgetTester tester) async {
      await testApp(
        tester,
        ChangeNotifierProvider.value(
          value: FakeAuthRepository() as AuthRepository,
        ),
        goRouter: goRouter,
      );
    }

    testWidgets('should load screen', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should show user name', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      expect(find.text('NAME\'s Trips'), findsOneWidget);
    });

    testWidgets('should navigate to search', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      // Tap on create a booking FAB
      await tester.tap(find.byKey(const ValueKey('booking-button')));
      await tester.pumpAndSettle();

      // Should navigate to results screen
      verify(() => goRouter.go(Routes.search)).called(1);
    });

    testWidgets('should open existing booking', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      // Tap on booking (created from kBooking)
      await tester.tap(find.text('name1, Europe'));
      await tester.pumpAndSettle();

      // Should navigate to results screen
      verify(() => goRouter.push(Routes.bookingWithId(0))).called(1);
    });

    testWidgets('should delete booking', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      // Swipe on booking (created from kBooking)
      await tester.drag(find.text('name1, Europe'), const Offset(-1000, 0));
      await tester.pumpAndSettle();

      // Existing booking should be gone
      expect(find.text('name1, Europe'), findsNothing);
    });

    testWidgets('fail to delete booking', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      // Swipe on booking (created from kBooking)
      await tester.drag(find.text('name1, Europe'), const Offset(-1000, 0));
      await tester.pumpAndSettle();

      // Existing booking should be there
      expect(find.text('name1, Europe'), findsOneWidget);
    });
  });
}
