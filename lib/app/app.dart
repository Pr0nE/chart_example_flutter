import 'package:chart_example_flutter/features/auth/data/auth_repository.dart';
import 'package:chart_example_flutter/features/auth/domain/repository/auth_repository.dart';
import 'package:chart_example_flutter/features/auth/ui/cubit/auth_cubit.dart';
import 'package:chart_example_flutter/features/auth/ui/login_page.dart';
import 'package:chart_example_flutter/features/auth/ui/splash_page.dart';
import 'package:chart_example_flutter/features/chart/data/chart_repository_impl.dart';
import 'package:chart_example_flutter/features/chart/domain/repository/chart_repository.dart';
import 'package:chart_example_flutter/features/chart/ui/cubit/chart_cubit.dart';
import 'package:chart_example_flutter/features/chart/ui/chart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RobotAnalyticsApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const RobotAnalyticsApp({super.key, required this.sharedPreferences});

  @override
  State<RobotAnalyticsApp> createState() => _RobotAnalyticsAppState();
}

class _RobotAnalyticsAppState extends State<RobotAnalyticsApp> {
  late final AuthRepository authRepository;
  late final ChartRepository chartRepository;
  late final AuthCubit authCubit;
  late final ChartCubit chartCubit;

  @override
  void initState() {
    super.initState();

    authRepository = AuthRepositoryImpl(
      sharedPreferences: widget.sharedPreferences,
    );
    chartRepository = ChartRepositoryImpl(
      sharedPreferences: widget.sharedPreferences,
    );

    authCubit = AuthCubit(authRepository);
    chartCubit = ChartCubit(chartRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<ChartRepository>.value(value: chartRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: authCubit),
          BlocProvider<ChartCubit>.value(value: chartCubit),
        ],
        child: MaterialApp(
          title: 'Robot Analytics',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashPage(),
            '/login': (context) => const LoginPage(),
            '/home': (context) => const ChartPage(),
          },
        ),
      ),
    );
  }
}
