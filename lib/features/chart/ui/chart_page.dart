import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/domain/auth_io.dart';
import '../domain/chart_io.dart';
import '../domain/chart_state.dart';
import 'widgets/add_data_bottom_sheet.dart';
import 'widgets/custom_line_chart.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  StreamSubscription<ChartState>? _chartSubscription;

  @override
  void initState() {
    super.initState();

    final chartIO = context.read<ChartIO>();

    _chartSubscription = chartIO.chartStateStream.listen((state) {
      if (!mounted) return;

      if (state is ChartError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      chartIO.loadChartData();
    });
  }

  @override
  void dispose() {
    _chartSubscription?.cancel();
    super.dispose();
  }

  void _showAddDataBottomSheet() {
    final chartIO = context.read<ChartIO>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddDataBottomSheet(
        onAdd: (date, minutes) {
          chartIO.addDataPoint(date, minutes);
        },
      ),
    );
  }

  void _handleLogout() {
    context.read<AuthIO>().logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final chartIO = context.read<ChartIO>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Robot Activity Chart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: StreamBuilder<ChartState>(
        stream: chartIO.chartStateStream,
        initialData: chartIO.currentState,
        builder: (context, snapshot) {
          final state = snapshot.data ?? chartIO.currentState;

          if (state is ChartLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading chart data...'),
                ],
              ),
            );
          }

          if (state is ChartLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Expanded(
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomLineChart(data: state.data),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDataBottomSheet,
        icon: const Icon(Icons.add),
        label: const Text('Add Data'),
      ),
    );
  }
}
