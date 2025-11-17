class TestData {
  static const String validUsername = 'Lely';
  static const String validPassword = 'LelyControl2';

  static const String invalidUsername = 'InvalidUser';
  static const String invalidPassword = 'WrongPassword';

  static const String emptyUsername = '';
  static const String usernameWithSpecialChars = 'User@#123';
  static const String usernameTooShort = 'ab';

  static const String emptyPassword = '';
  static const String passwordTooShort = '123';

  static final List<ChartDataPoint> sampleChartData = [
    ChartDataPoint(date: DateTime(2024, 1, 15), minutes: 180),
    ChartDataPoint(date: DateTime(2024, 1, 16), minutes: 240),
    ChartDataPoint(date: DateTime(2024, 1, 17), minutes: 120),
  ];

  static const int validMinutesLow = 60;
  static const int validMinutesMid = 180;
  static const int validMinutesHigh = 720;
  static const int validMinutesMax = 1440;

  static const int invalidMinutesNegative = -10;
  static const int invalidMinutesZero = 0;
  static const int invalidMinutesOverMax = 1441;

  static DateTime get testDate1 => DateTime(2024, 1, 20);
  static DateTime get testDate2 => DateTime(2024, 1, 21);
  static DateTime get testDate3 => DateTime(2024, 1, 22);
  static DateTime get todayDate => DateTime.now();

  static const String splashTitle = 'Robot Analytics';
  static const String loginPageTitle = 'Login';
  static const String loginButtonText = 'Login';
  static const String chartPageTitle = 'Robot Activity Chart';
  static const String addDataButtonText = 'Add Data';
  static const String addNewDataTitle = 'Add New Data';
  static const String logoutIconTooltip = 'Logout';

  static const String invalidCredentialsError = 'Invalid username or password';
  static const String usernameEmptyError = 'Please enter username';
  static const String passwordEmptyError = 'Please enter password';
  static const String usernameInvalidCharsError = 'invalid characters';
  static const String duplicateDateError = 'Date already exists';
  static const String invalidMinutesError = 'must be between 0 and 1440';

  static const String spKeyUser = 'username';
  static const String spKeyChartData = 'chart_data';
}

class ChartDataPoint {
  final DateTime date;
  final int minutes;

  ChartDataPoint({required this.date, required this.minutes});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'duration': minutes,
  };
}
