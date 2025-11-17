import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'test_data.dart';

class TestHelpers {
  static Future<void> clearAllData() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> setupLoggedInUser() async {
    SharedPreferences.setMockInitialValues({
      TestData.spKeyUser: TestData.validUsername,
    });
  }

  static Future<void> setupWithChartData(
    List<ChartDataPoint> dataPoints,
  ) async {
    final chartDataJson = dataPoints.map((point) => point.toJson()).toList();

    final jsonString = jsonEncode(chartDataJson);

    SharedPreferences.setMockInitialValues({
      TestData.spKeyUser: TestData.validUsername,
      TestData.spKeyChartData: jsonString,
    });
  }

  static Future<void> waitForAppToSettle(WidgetTester tester) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }

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

  static Future<void> performLogout(WidgetTester tester) async {
    final logoutButton = find.byIcon(Icons.logout);
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();
  }

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

  static void verifySplashPage() {
    expect(find.text(TestData.splashTitle), findsWidgets);
  }

  static void verifyLoginPage() {
    expect(find.text(TestData.loginPageTitle), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, TestData.loginButtonText),
      findsOneWidget,
    );
  }

  static void verifyChartPage() {
    expect(find.text(TestData.chartPageTitle), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
    expect(
      find.widgetWithText(FloatingActionButton, TestData.addDataButtonText),
      findsOneWidget,
    );
  }

  static void verifySnackBarWithText(String text) {
    expect(find.text(text), findsOneWidget);
  }

  static void verifyErrorMessage(String errorText) {
    expect(find.textContaining(errorText), findsAtLeastNWidgets(1));
  }

  static void verifyLoginValidationError(String errorText) {
    expect(find.text(errorText), findsAtLeastNWidgets(1));
  }

  static Future<void> wait(WidgetTester tester, Duration duration) async {
    await tester.pump(duration);
  }

  static Future<void> tapWidgetWithText(
    WidgetTester tester,
    String text,
  ) async {
    final widget = find.text(text);
    expect(widget, findsOneWidget);
    await tester.tap(widget);
    await tester.pumpAndSettle();
  }

  static Future<void> tapWidgetWithIcon(
    WidgetTester tester,
    IconData icon,
  ) async {
    final widget = find.byIcon(icon);
    expect(widget, findsOneWidget);
    await tester.tap(widget);
    await tester.pumpAndSettle();
  }

  static Future<void> enterTextInField(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  static void verifyWidgetExists(String text) {
    expect(find.text(text), findsOneWidget);
  }

  static void verifyWidgetDoesNotExist(String text) {
    expect(find.text(text), findsNothing);
  }

  static Future<void> restartApp(WidgetTester tester, Widget app) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }
}
