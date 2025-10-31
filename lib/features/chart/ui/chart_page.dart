import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/domain/auth_io.dart';
import '../domain/chart_io.dart';
import '../domain/models/chart_state.dart';
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
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Robot Hours Active Per Day',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Total data points: ${state.data.length}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Statistics',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _StatItem(
                                label: 'Average',
                                value: _calculateAverage(state.data),
                                unit: 'hrs',
                              ),
                              _StatItem(
                                label: 'Max',
                                value: _calculateMax(state.data),
                                unit: 'hrs',
                              ),
                              _StatItem(
                                label: 'Min',
                                value: _calculateMin(state.data),
                                unit: 'hrs',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('No data available'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDataBottomSheet,
        icon: const Icon(Icons.add),
        label: const Text('Add Data'),
      ),
    );
  }

  String _calculateAverage(data) {
    if (data.isEmpty) return '0.0';
    final sum = data.fold(0.0, (sum, point) => sum + point.hoursActive);
    return (sum / data.length).toStringAsFixed(1);
  }

  String _calculateMax(data) {
    if (data.isEmpty) return '0.0';
    final max = data.map((e) => e.hoursActive).reduce((a, b) => a > b ? a : b);
    return max.toStringAsFixed(1);
  }

  String _calculateMin(data) {
    if (data.isEmpty) return '0.0';
    final min = data.map((e) => e.hoursActive).reduce((a, b) => a < b ? a : b);
    return min.toStringAsFixed(1);
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _StatItem({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
