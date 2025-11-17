import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chart_example_flutter/features/auth/ui/cubit/auth_cubit.dart';
import 'package:chart_example_flutter/features/auth/domain/repository/auth_repository.dart';
import 'package:chart_example_flutter/features/chart/ui/cubit/chart_cubit.dart';
import 'package:chart_example_flutter/features/chart/domain/repository/chart_repository.dart';
import 'package:chart_example_flutter/features/chart/domain/models/robot_data_point.dart';
import 'package:chart_example_flutter/features/chart/ui/chart_page.dart';
import 'package:chart_example_flutter/features/chart/ui/widgets/custom_line_chart.dart';

class MockChartRepository extends Mock implements ChartRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ChartCubit chartCubit;
  late AuthCubit authCubit;
  late MockChartRepository mockChartRepository;
  late MockAuthRepository mockAuthRepository;

  List<RobotDataPoint> getInitialTestData() {
    return List.generate(7, (index) {
      final date = DateTime(2025, 10, 8 + index);
      return RobotDataPoint(date: date, minutesActive: 100 + (index * 50));
    });
  }

  setUp(() {
    mockChartRepository = MockChartRepository();
    mockAuthRepository = MockAuthRepository();

    when(
      () => mockChartRepository.getChartData(),
    ).thenAnswer((_) async => getInitialTestData());

    chartCubit = ChartCubit(mockChartRepository);
    authCubit = AuthCubit(mockAuthRepository);
  });

  tearDown(() {
    chartCubit.close();
    authCubit.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ChartCubit>.value(value: chartCubit),
          BlocProvider<AuthCubit>.value(value: authCubit),
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



    testWidgets('floating action button is present', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Add Data'), findsOneWidget);
    });

    group('Chart Display Tests', () {
      testWidgets('displays CustomLineChart widget when data is loaded', (
        tester,
      ) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(CustomLineChart), findsOneWidget);
      });

      testWidgets('displays zoom controls in chart', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final zoomInButtons = find.byIcon(Icons.add);
        expect(zoomInButtons, findsWidgets);

        expect(find.byIcon(Icons.remove), findsOneWidget);
      });

      testWidgets('shows "No data available" when data list is empty', (
        tester,
      ) async {
        when(
          () => mockChartRepository.getChartData(),
        ).thenAnswer((_) async => []);

        final emptyChartCubit = ChartCubit(mockChartRepository);

        final widget = MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<ChartCubit>.value(value: emptyChartCubit),
              BlocProvider<AuthCubit>.value(value: authCubit),
            ],
            child: const ChartPage(),
          ),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        expect(find.text('No data available'), findsOneWidget);

        expect(find.byType(CustomLineChart), findsNothing);

        emptyChartCubit.close();
      });

      testWidgets('chart updates when new data is added', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        var customLineChart = tester.widget<CustomLineChart>(
          find.byType(CustomLineChart),
        );
        expect(customLineChart.data.length, equals(7));

        final newDataPoint = RobotDataPoint(
          date: DateTime(2025, 10, 15),
          minutesActive: 200,
        );

        final updatedData = [...getInitialTestData(), newDataPoint];
        when(
          () => mockChartRepository.getChartData(),
        ).thenAnswer((_) async => updatedData);

        chartCubit.loadChartData();
        await tester.pumpAndSettle();

        customLineChart = tester.widget<CustomLineChart>(
          find.byType(CustomLineChart),
        );
        expect(customLineChart.data.length, equals(8));
      });
    });
  });
}
