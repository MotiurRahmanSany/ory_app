import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/budget_plan.dart';

class GeneratedPlanScreen extends StatelessWidget {
  final BudgetPlan plan;

  const GeneratedPlanScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your AI Budget Plan'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget Plan for You 🎉',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildHeader(),
            const SizedBox(height: 30),
            _buildSavingsCard(),
            const SizedBox(height: 30),
            _buildAllocationChart(),
            const SizedBox(height: 30),
            _buildSpendingLimits(),
            const SizedBox(height: 30),
            _buildAssumptionsPanel(),
            const SizedBox(height: 30),
            _buildMotivationCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade300, Colors.blue.shade300],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            '${plan.totalIncome.toStringAsFixed(0)} BDT',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Total ${plan.period} Income',
            style: const TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              '💰 Monthly Savings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSavingsMetric(
                  '${plan.savings.percentage}%',
                  'Of Income Saved',
                ),
                _buildSavingsMetric(
                  '${plan.savings.amount.toStringAsFixed(0)} BDT',
                  'Amount',
                ),
                _buildSavingsMetric(
                  '${plan.savings.timeSavedHours}hrs',
                  'Time Saved',
                ),
              ],
            ),
            const SizedBox(height: 15),
            LinearProgressIndicator(
              value: plan.savings.percentage / 100,
              backgroundColor: Colors.grey.shade200,
              color: Colors.green.shade400,
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllocationChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Budget Allocation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: PieChart(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 1000),
                PieChartData(
                  sections: _buildChartSections(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...plan.allocations.map((a) => _buildAllocationItem(a)),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections() {
    final colors = [
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.red.shade400,
      Colors.teal.shade400,
    ];

    return plan.allocations.asMap().entries.map((entry) {
      final index = entry.key;
      final allocation = entry.value;
      return PieChartSectionData(
        value: allocation.percentage,
        color: colors[index % colors.length],
        title: '${allocation.percentage.toStringAsFixed(0)}%',
        showTitle: true,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildAllocationItem(Allocation allocation) {
    return ListTile(
      leading: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              allocation.type == 'mandatory'
                  ? Colors.green.shade400
                  : Colors.blue.shade400,
        ),
      ),
      title: Text(allocation.category),
      trailing: Text(
        '${allocation.amount.toStringAsFixed(0)} BDT',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${allocation.percentage.toStringAsFixed(1)}% of income'),
    );
  }

  Widget _buildSpendingLimits() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              '🛑 Spending Limits',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildLimitItem('Daily', plan.spendingLimits.daily),
            _buildLimitItem('Weekly', plan.spendingLimits.weekly),
          ],
        ),
      ),
    );
  }

  Widget _buildLimitItem(String period, double amount) {
    return ListTile(
      leading: const Icon(Icons.speed_rounded),
      title: Text('$period Limit'),
      trailing: Text(
        '${amount.toStringAsFixed(0)} BDT',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red.shade400,
        ),
      ),
    );
  }

  Widget _buildAssumptionsPanel() {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        'AI Assumptions',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            plan.assumptions,
            style: TextStyle(color: Colors.grey.shade600, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildMotivationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.emoji_emotions_rounded,
            size: 40,
            color: Colors.green,
          ),
          const SizedBox(height: 15),
          Text(
            plan.motivation,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.green.shade800,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsMetric(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
