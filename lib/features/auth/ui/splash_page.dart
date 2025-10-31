import 'dart:async';
import 'package:chart_example_flutter/features/auth/domain/auth_io.dart';
import 'package:chart_example_flutter/features/auth/domain/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();

    final authIO = context.read<AuthIO>();

    _authSubscription = authIO.authStateStream.listen((state) {
      if (!mounted) return;

      if (state is AuthAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else if (state is AuthUnauthenticated) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      authIO.checkAuthStatus();
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart_rounded, size: 80, color: Colors.blue),
              SizedBox(height: 24),
              Text(
                'Robot Analytics',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(),
            ],
          ),
        ),
    );
  }
}
