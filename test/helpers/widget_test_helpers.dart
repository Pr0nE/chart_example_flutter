import 'dart:convert';

import 'package:chart_example_flutter/features/chart/domain/models/robot_data_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'test_data.dart';

class TestHelpers {
  /// Clear all SharedPreferences data
  static Future<void> clearAllData() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Setup SharedPreferences with a logged-in user
  static Future<void> setupLoggedInUser() async {
    SharedPreferences.setMockInitialValues({
      TestData.spKeyUser: TestData.validUsername,
    });
  }

  /// Setup SharedPreferences with chart data
  static Future<void> setupWithChartData(
    List<RobotDataPoint> dataPoints,
  ) async {
    final chartDataJson = dataPoints.map((point) => point.toJson()).toList();
    final jsonString = jsonEncode(chartDataJson);

    SharedPreferences.setMockInitialValues({
      TestData.spKeyUser: TestData.validUsername,
      TestData.spKeyChartData: jsonString,
    });
  }

  /// Wait for app animations to settle
  static Future<void> waitForAppToSettle(WidgetTester tester) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }

  /// Perform login with given credentials
  static Future<void> performLogin(
    WidgetTester tester, {
    required String username,
    required String password,
  }) async {
    await tester.pumpAndSettle();

    final usernameFinder = find.byType(TextFormField).first;
    final passwordFinder = find.byType(TextFormField).last;

    await tester.enterText(usernameFinder, username);
    await tester.pumpAndSettle();
    await tester.enterText(passwordFinder, password);
    await tester.pumpAndSettle();

    final loginButton = find.widgetWithText(
      ElevatedButton,
      TestData.loginButtonText,
    );
    await tester.tap(loginButton);
    await tester.pumpAndSettle(const Duration(seconds: 3));
  }

  /// Perform logout
  static Future<void> performLogout(WidgetTester tester) async {
    final logoutButton = find.byIcon(Icons.logout);
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();
  }

  /// Open the add data bottom sheet
  static Future<void> openAddDataBottomSheet(WidgetTester tester) async {
    final addDataButton = find.widgetWithText(
      FloatingActionButton,
      TestData.addDataButtonText,
    );
    expect(addDataButton, findsOneWidget);
    await tester.tap(addDataButton);
    await tester.pumpAndSettle();

    expect(find.text(TestData.addNewDataTitle), findsOneWidget);
  }

  /// Add chart data via UI interactions
  static Future<void> addChartDataViaUI(
    WidgetTester tester, {
    required DateTime date,
    required int minutes,
  }) async {
    await openAddDataBottomSheet(tester);

    final datePickerButton = find.byIcon(Icons.calendar_today);
    await tester.tap(datePickerButton);
    await tester.pumpAndSettle();

    final okButton = find.text('OK');
    if (okButton.evaluate().isNotEmpty) {
      await tester.tap(okButton);
      await tester.pumpAndSettle();
    }

    final minutesField = find.byType(TextFormField).last;
    await tester.enterText(minutesField, minutes.toString());
    await tester.pumpAndSettle();

    final addButton = find.widgetWithText(
      ElevatedButton,
      TestData.addDataButtonText,
    );
    await tester.tap(addButton);
    await tester.pumpAndSettle();
  }

  // Verification helpers

  /// Verify splash page is displayed
  static void verifySplashPage() {
    expect(find.text(TestData.splashTitle), findsWidgets);
  }

  /// Verify login page is displayed
  static void verifyLoginPage() {
    expect(find.text(TestData.loginPageTitle), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, TestData.loginButtonText),
      findsOneWidget,
    );
  }

  /// Verify chart page is displayed
  static void verifyChartPage() {
    expect(find.text(TestData.chartPageTitle), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
    expect(
      find.widgetWithText(FloatingActionButton, TestData.addDataButtonText),
      findsOneWidget,
    );
  }

  /// Verify a snackbar with specific text is shown
  static void verifySnackBarWithText(String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Verify an error message is displayed
  static void verifyErrorMessage(String errorText) {
    expect(find.textContaining(errorText), findsAtLeastNWidgets(1));
  }

  /// Verify login validation error is displayed
  static void verifyLoginValidationError(String errorText) {
    expect(find.text(errorText), findsAtLeastNWidgets(1));
  }

  // Generic interaction helpers

  /// Wait for a specific duration
  static Future<void> wait(WidgetTester tester, Duration duration) async {
    await tester.pump(duration);
  }

  /// Tap a widget with specific text
  static Future<void> tapWidgetWithText(
    WidgetTester tester,
    String text,
  ) async {
    final widget = find.text(text);
    expect(widget, findsOneWidget);
    await tester.tap(widget);
    await tester.pumpAndSettle();
  }

  /// Tap a widget with specific icon
  static Future<void> tapWidgetWithIcon(
    WidgetTester tester,
    IconData icon,
  ) async {
    final widget = find.byIcon(icon);
    expect(widget, findsOneWidget);
    await tester.tap(widget);
    await tester.pumpAndSettle();
  }

  /// Enter text in a field
  static Future<void> enterTextInField(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  /// Verify a widget with text exists
  static void verifyWidgetExists(String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Verify a widget with text does not exist
  static void verifyWidgetDoesNotExist(String text) {
    expect(find.text(text), findsNothing);
  }

  /// Restart the app (useful for testing persistence)
  static Future<void> restartApp(WidgetTester tester, Widget app) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }
}
