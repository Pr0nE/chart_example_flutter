import 'package:chart_example_flutter/app/app.dart';
import 'package:chart_example_flutter/features/chart/domain/models/robot_data_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test/helpers/test_data.dart';
import '../test/helpers/widget_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration Tests', () {
    setUp(() async {
      await TestHelpers.clearAllData();
    });

    group('Authentication Tests', () {
      testWidgets('First-time user login flow', (tester) async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        await tester.pumpWidget(RobotAnalyticsApp(sharedPreferences: prefs));
        await tester.pumpAndSettle();

        TestHelpers.verifySplashPage();

        await tester.pumpAndSettle(const Duration(seconds: 3));

        TestHelpers.verifyLoginPage();

        await TestHelpers.performLogin(
          tester,
          username: TestData.validUsername,
          password: TestData.validPassword,
        );

        TestHelpers.verifyChartPage();

        expect(find.text(TestData.chartPageTitle), findsOneWidget);
        expect(find.byIcon(Icons.logout), findsOneWidget);
        expect(
          find.widgetWithText(FloatingActionButton, TestData.addDataButtonText),
          findsOneWidget,
        );
      });

      testWidgets('Login fails with invalid credentials', (tester) async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        await tester.pumpWidget(RobotAnalyticsApp(sharedPreferences: prefs));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        TestHelpers.verifyLoginPage();

        await TestHelpers.performLogin(
          tester,
          username: TestData.invalidUsername,
          password: TestData.invalidPassword,
        );

        TestHelpers.verifyErrorMessage(TestData.invalidCredentialsError);

        TestHelpers.verifyLoginPage();
      });

      testWidgets('Login form validation', (tester) async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        await tester.pumpWidget(RobotAnalyticsApp(sharedPreferences: prefs));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        final loginButton = find.widgetWithText(
          ElevatedButton,
          TestData.loginButtonText,
        );
        await tester.tap(loginButton);
        await tester.pumpAndSettle();

        TestHelpers.verifyLoginValidationError(TestData.usernameEmptyError);

        final usernameField = find.byType(TextFormField).first;
        await tester.enterText(usernameField, TestData.validUsername);
        await tester.pumpAndSettle();

        await tester.tap(loginButton);
        await tester.pumpAndSettle();

        TestHelpers.verifyLoginValidationError(TestData.passwordEmptyError);

        await tester.enterText(
          usernameField,
          TestData.usernameWithSpecialChars,
        );
        await tester.pumpAndSettle();

        final passwordField = find.byType(TextFormField).last;
        await tester.enterText(passwordField, TestData.validPassword);
        await tester.pumpAndSettle();

        await tester.tap(loginButton);
        await tester.pumpAndSettle();

        TestHelpers.verifyErrorMessage(TestData.usernameInvalidCharsError);
      });

      testWidgets('Session persistence across app restarts', (tester) async {
        await TestHelpers.setupLoggedInUser();
        final prefs = await SharedPreferences.getInstance();

        await tester.pumpWidget(RobotAnalyticsApp(sharedPreferences: prefs));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        TestHelpers.verifyChartPage();

        await TestHelpers.performLogout(tester);

        TestHelpers.verifyLoginPage();

        await TestHelpers.restartApp(
          tester,
          RobotAnalyticsApp(sharedPreferences: prefs),
        );

        TestHelpers.verifyLoginPage();
      });

      testWidgets('Logout flow', (tester) async {
        await TestHelpers.setupLoggedInUser();
        final prefs = await SharedPreferences.getInstance();

        await tester.pumpWidget(RobotAnalyticsApp(sharedPreferences: prefs));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        TestHelpers.verifyChartPage();

        await TestHelpers.performLogout(tester);

        TestHelpers.verifyLoginPage();

        expect(find.byIcon(Icons.logout), findsNothing);
      });
    });

    group('Chart Tests', () {
      testWidgets('Add new data point and verify chart updates', (
        tester,
      ) async {
        await TestHelpers.setupLoggedInUser();
        final prefs = await SharedPreferences.getInstance();

        await tester.pumpWidget(RobotAnalyticsApp(sharedPreferences: prefs));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        TestHelpers.verifyChartPage();

        await TestHelpers.openAddDataBottomSheet(tester);

        expect(find.text(TestData.addNewDataTitle), findsOneWidget);

        final minutesField = find.byType(TextFormField).last;
        await tester.enterText(
          minutesField,
          TestData.validMinutesMid.toString(),
        );
        await tester.pumpAndSettle();

        final addButton = find.widgetWithText(
          ElevatedButton,
          TestData.addDataButtonText,
        );
        await tester.tap(addButton.last);
        await tester.pumpAndSettle();

        expect(find.text(TestData.addNewDataTitle), findsNothing);

        TestHelpers.verifyChartPage();

        expect(find.byType(CustomPaint), findsWidgets);
      });

      testWidgets('Duplicate date validation', (tester) async {
        await TestHelpers.setupWithChartData([
          RobotDataPoint(
            date: TestData.testDate1,
            minutesActive: TestData.validMinutesLow,
          ),
          RobotDataPoint(
            date: TestData.testDate2,
            minutesActive: TestData.validMinutesMid,
          ),
        ]);
        final prefs = await SharedPreferences.getInstance();

        await tester.pumpWidget(RobotAnalyticsApp(sharedPreferences: prefs));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await TestHelpers.openAddDataBottomSheet(tester);

        final minutesField = find.byType(TextFormField).last;
        await tester.enterText(
          minutesField,
          TestData.validMinutesMid.toString(),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        TestHelpers.verifyChartPage();
      });
    });
  });
}
