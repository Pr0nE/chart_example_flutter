import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chart_example_flutter/features/auth/ui/auth_cubit.dart';
import 'package:chart_example_flutter/features/auth/data/auth_repository.dart';
import 'package:chart_example_flutter/features/auth/domain/repository/auth_repository.dart';
import 'package:chart_example_flutter/features/auth/ui/login_page.dart';

void main() {
  late AuthCubit authCubit;
  late AuthRepository authRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();
    authRepository = AuthRepositoryImpl(sharedPreferences: sharedPreferences);
    authCubit = AuthCubit(authRepository);
  });

  tearDown(() {
    authCubit.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: const LoginPage(),
      ),
    );
  }

  group('LoginPage', () {
    testWidgets('renders login form with username and password fields', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('shows error when username field is empty', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter username'), findsOneWidget);
    });

    testWidgets('shows error when password field is empty', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final usernameField = find.byType(TextFormField).first;
      await tester.enterText(usernameField, 'Lely');

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter password'), findsOneWidget);
    });

    testWidgets('shows error for invalid characters in username', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final usernameField = find.byType(TextFormField).first;
      await tester.enterText(usernameField, 'User&Name');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.textContaining('invalid characters'), findsOneWidget);
    });

    testWidgets('password visibility toggle works', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final visibilityButton = find.byIcon(Icons.visibility);

      expect(visibilityButton, findsOneWidget);

      await tester.tap(visibilityButton);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });
  });
}
