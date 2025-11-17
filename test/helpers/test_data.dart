import 'package:chart_example_flutter/features/chart/domain/models/robot_data_point.dart';

class TestData {
  // Authentication test data
  static const String validUsername = 'Lely';
  static const String validPassword = 'LelyControl2';

  static const String invalidUsername = 'InvalidUser';
  static const String invalidPassword = 'WrongPassword';

  static const String emptyUsername = '';
  static const String usernameWithSpecialChars = 'User@#123';
  static const String usernameTooShort = 'ab';

  static const String emptyPassword = '';
  static const String passwordTooShort = '123';

  // Chart data samples
  static final List<RobotDataPoint> sampleChartData = [
    RobotDataPoint(date: DateTime(2024, 1, 15), minutesActive: 180),
    RobotDataPoint(date: DateTime(2024, 1, 16), minutesActive: 240),
    RobotDataPoint(date: DateTime(2024, 1, 17), minutesActive: 120),
  ];

  // Valid minutes values
  static const int validMinutesLow = 60;
  static const int validMinutesMid = 180;
  static const int validMinutesHigh = 720;
  static const int validMinutesMax = 1440;

  // Invalid minutes values
  static const int invalidMinutesNegative = -10;
  static const int invalidMinutesZero = 0;
  static const int invalidMinutesOverMax = 1441;

  // Test dates
  static DateTime get testDate1 => DateTime(2024, 1, 20);
  static DateTime get testDate2 => DateTime(2024, 1, 21);
  static DateTime get testDate3 => DateTime(2024, 1, 22);
  static DateTime get todayDate => DateTime.now();

  // UI text constants
  static const String splashTitle = 'Robot Analytics';
  static const String loginPageTitle = 'Login';
  static const String loginButtonText = 'Login';
  static const String chartPageTitle = 'Robot Activity Chart';
  static const String addDataButtonText = 'Add Data';
  static const String addNewDataTitle = 'Add New Data';
  static const String logoutIconTooltip = 'Logout';

  // Error messages
  static const String invalidCredentialsError = 'Invalid username or password';
  static const String usernameEmptyError = 'Please enter username';
  static const String passwordEmptyError = 'Please enter password';
  static const String usernameInvalidCharsError = 'invalid characters';
  static const String duplicateDateError = 'Date already exists';
  static const String invalidMinutesError = 'must be between 0 and 1440';

  // SharedPreferences keys
  static const String spKeyUser = 'username';
  static const String spKeyChartData = 'chart_data';
}
