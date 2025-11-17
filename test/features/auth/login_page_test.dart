import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chart_example_flutter/features/auth/ui/cubit/auth_cubit.dart';
import 'package:chart_example_flutter/features/auth/domain/repository/auth_repository.dart';
import 'package:chart_example_flutter/features/auth/domain/models/user.dart';
import 'package:chart_example_flutter/features/auth/ui/login_page.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthCubit authCubit;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authCubit = AuthCubit(mockAuthRepository);
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

    group('Authentication Tests', () {
      testWidgets('shows error message with invalid credentials', (
        tester,
      ) async {
        when(
          () => mockAuthRepository.login('Lely', 'wrongpassword'),
        ).thenAnswer((_) async => null);

        await tester.pumpWidget(createWidgetUnderTest());

        final usernameField = find.byType(TextFormField).first;
        final passwordField = find.byType(TextFormField).last;

        await tester.enterText(usernameField, 'Lely');
        await tester.enterText(passwordField, 'wrongpassword');

        await tester.tap(find.text('Login'));
        await tester.pump(); 

        await tester.pumpAndSettle();

        expect(find.text('Invalid username or password'), findsOneWidget);

        verify(
          () => mockAuthRepository.login('Lely', 'wrongpassword'),
        ).called(1);
      });

      testWidgets('shows error message when login throws exception', (
        tester,
      ) async {
        when(
          () => mockAuthRepository.login('Lely', 'password123'),
        ).thenThrow(Exception('Network error'));

        await tester.pumpWidget(createWidgetUnderTest());

        final usernameField = find.byType(TextFormField).first;
        final passwordField = find.byType(TextFormField).last;

        await tester.enterText(usernameField, 'Lely');
        await tester.enterText(passwordField, 'password123');

        await tester.tap(find.text('Login'));
        await tester.pump();

        await tester.pumpAndSettle();

        expect(find.textContaining('Exception: Network error'), findsOneWidget);

        verify(() => mockAuthRepository.login('Lely', 'password123')).called(1);
      });

      testWidgets('successful login with valid credentials', (tester) async {
        when(
          () => mockAuthRepository.login('Lely', 'password123'),
        ).thenAnswer((_) async => const User(username: 'Lely'));


        final widget = MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: authCubit,
            child: const LoginPage(),
          ),
          routes: {
            '/home': (context) => const Scaffold(body: Text('Home Page')),
          },
        );

        await tester.pumpWidget(widget);

        final usernameField = find.byType(TextFormField).first;
        final passwordField = find.byType(TextFormField).last;

        await tester.enterText(usernameField, 'Lely');
        await tester.enterText(passwordField, 'password123');

        await tester.tap(find.text('Login'));
        await tester.pump(); 

        await tester.pumpAndSettle(); 

        expect(find.text('Home Page'), findsOneWidget);

        verify(() => mockAuthRepository.login('Lely', 'password123')).called(1);
      });
    });
  });
}

