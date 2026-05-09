import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../core/design_system.dart';
import '../../providers/user_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Spiritual Reports'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTotalCard(),
            const SizedBox(height: 30),
            const Text('Weekly Progress', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildWeeklyChart(),
            const SizedBox(height: 30),
            const Text('Milestones', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildMilestones(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        children: [
          const Text('Total Astaghfirullah', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          const Text(
            '45,200', // Placeholder, should be calculated
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            'Purifying your heart, one step at a time.',
            style: TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 12000,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  return Text(days[value.toInt() % 7]);
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            _makeGroupData(0, 3000),
            _makeGroupData(1, 4500),
            _makeGroupData(2, 2000),
            _makeGroupData(3, 5000),
            _makeGroupData(4, 8000),
            _makeGroupData(5, 12000),
            _makeGroupData(6, 9000),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primary,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  Widget _buildMilestones() {
    return Column(
      children: [
        _buildMilestoneItem('First 1,000', 'Achieved', Icons.check_circle, true),
        _buildMilestoneItem('Consistent Week', 'In Progress', Icons.hourglass_empty, false),
        _buildMilestoneItem('Month 1 Complete', 'Locked', Icons.lock_outline, false),
      ],
    );
  }

  Widget _buildMilestoneItem(String title, String status, IconData icon, bool completed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: completed ? Border.all(color: AppColors.primary, width: 1) : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: completed ? AppColors.primary : AppColors.textSecondary),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(status, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
