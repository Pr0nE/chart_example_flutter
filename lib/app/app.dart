import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/auth/data/auth_cubit.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/domain/auth_io.dart';
import '../features/auth/domain/repository/auth_repository.dart';
import '../features/auth/ui/login_page.dart';
import '../features/auth/ui/splash_page.dart';
import '../features/chart/data/chart_cubit.dart';
import '../features/chart/data/chart_repository_impl.dart';
import '../features/chart/domain/chart_io.dart';
import '../features/chart/domain/repository/chart_repository.dart';
import '../features/chart/ui/chart_page.dart';

class RobotAnalyticsApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const RobotAnalyticsApp({super.key, required this.sharedPreferences});

  @override
  State<RobotAnalyticsApp> createState() => _RobotAnalyticsAppState();
}

class _RobotAnalyticsAppState extends State<RobotAnalyticsApp> {
  late final AuthRepository authRepository;
  late final ChartRepository chartRepository;
  late final AuthIO authIO;
  late final ChartIO chartIO;

  @override
  void initState() {
    super.initState();

    authRepository = AuthRepositoryImpl(
      sharedPreferences: widget.sharedPreferences,
    );
    chartRepository = ChartRepositoryImpl(
      sharedPreferences: widget.sharedPreferences,
    );

    authIO = AuthCubit(authRepository);
    chartIO = ChartCubit(chartRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<ChartRepository>.value(value: chartRepository),

        RepositoryProvider<AuthIO>.value(value: authIO),
        RepositoryProvider<ChartIO>.value(value: chartIO),
      ],
      child: MaterialApp(
        title: 'Robot Analytics',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const ChartPage(),
        },
      ),
    );
  }
}
