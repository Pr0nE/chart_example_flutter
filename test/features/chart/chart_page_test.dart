import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chart_example_flutter/features/auth/data/auth_cubit.dart';
import 'package:chart_example_flutter/features/auth/data/auth_repository.dart';
import 'package:chart_example_flutter/features/auth/domain/auth_io.dart';
import 'package:chart_example_flutter/features/chart/data/chart_cubit.dart';
import 'package:chart_example_flutter/features/chart/data/chart_repository_impl.dart';
import 'package:chart_example_flutter/features/chart/domain/chart_io.dart';
import 'package:chart_example_flutter/features/chart/ui/chart_page.dart';

void main() {
  late ChartIO chartIO;
  late AuthIO authIO;

  // Helper to create initial test data
  List<Map<String, dynamic>> getInitialTestData() {
    return List.generate(7, (index) {
      final date = DateTime(2025, 10, 8 + index);
      return {
        'date': date.toIso8601String(),
        'minutesActive': 100 + (index * 50),
      };
    });
  }

  setUp(() async {
    // Pre-populate SharedPreferences with initial data
    final initialData = getInitialTestData();
    SharedPreferences.setMockInitialValues({
      'chart_data': json.encode(initialData),
    });
    final sharedPreferences = await SharedPreferences.getInstance();

    final chartRepository = ChartRepositoryImpl(
      sharedPreferences: sharedPreferences,
    );
    chartIO = ChartCubit(chartRepository);

    final authRepository = AuthRepositoryImpl(
      sharedPreferences: sharedPreferences,
    );
    authIO = AuthCubit(authRepository);
  });

  tearDown(() {
    if (chartIO is ChartCubit) {
      (chartIO as ChartCubit).close();
    }
    if (authIO is AuthCubit) {
      (authIO as AuthCubit).close();
    }
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ChartIO>.value(value: chartIO),
          RepositoryProvider<AuthIO>.value(value: authIO),
        ],
        child: const ChartPage(),
      ),
    );
  }

  group('ChartPage', () {
    testWidgets('renders app bar with title and logout button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Robot Activity Chart'), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('shows loading indicator while loading', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading chart data...'), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('floating action button is present', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Add Data'), findsOneWidget);
    });
  });
}
