import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/ui/auth_cubit.dart';
import '../domain/chart_state.dart';
import 'chart_cubit.dart';
import 'widgets/add_data_bottom_sheet.dart';
import 'widgets/custom_line_chart.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChartCubit>().loadChartData();
    });
  }

  void _showAddDataBottomSheet() {
    final chartCubit = context.read<ChartCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddDataBottomSheet(
        onAdd: (date, minutes) {
          chartCubit.addDataPoint(date, minutes);
        },
      ),
    );
  }

  void _handleLogout() {
    context.read<AuthCubit>().logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChartCubit, ChartState>(
      listener: (context, state) {
        if (state is ChartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
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
        body: BlocBuilder<ChartCubit, ChartState>(
          builder: (context, state) {
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
      ),
    );
  }
}
