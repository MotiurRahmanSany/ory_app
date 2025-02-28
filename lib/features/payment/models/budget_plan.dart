// ignore_for_file: public_member_api_docs, sort_constructors_first
class BudgetPlan {
  final double totalIncome;
  final String period;
  final List<Allocation> allocations;
  final Savings savings;
  final SpendingLimits spendingLimits;
  final String assumptions;
  final String motivation;

  BudgetPlan({
    required this.totalIncome,
    required this.period,
    required this.allocations,
    required this.savings,
    required this.spendingLimits,
    required this.assumptions,
    required this.motivation,
  });

  factory BudgetPlan.fromJson(Map<String, dynamic> json) {
    final allocations =
        (json['allocations'] as List)
            .map((e) => Allocation.fromJson(e))
            .toList();
    return BudgetPlan(
      totalIncome: (json['total_income'] as num).toDouble(),
      period: json['period'],
      allocations: allocations,
      savings: Savings.fromJson(json['savings']),
      spendingLimits: SpendingLimits.fromJson(json['spending_limits']),
      assumptions: json['assumptions'],
      motivation: json['motivation'],
    );
  }

  @override
  String toString() {
    return 'BudgetPlan(totalIncome: $totalIncome, period: $period, allocations: $allocations, savings: $savings, spendingLimits: $spendingLimits, assumptions: $assumptions, motivation: $motivation)';
  }
}

class Allocation {
  final String category;
  final double percentage;
  final double amount;
  final String type;

  Allocation({
    required this.category,
    required this.percentage,
    required this.amount,
    required this.type,
  });

  factory Allocation.fromJson(Map<String, dynamic> json) {
    return Allocation(
      category: json['category'],
      percentage: (json['percentage'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      type: json['type'],
    );
  }

  @override
  String toString() {
    return 'Allocation(category: $category, percentage: $percentage, amount: $amount, type: $type)';
  }
}

class Savings {
  final double percentage;
  final double amount;
  final int timeSavedHours;

  Savings({
    required this.percentage,
    required this.amount,
    required this.timeSavedHours,
  });

  factory Savings.fromJson(Map<String, dynamic> json) {
    return Savings(
      percentage: (json['percentage'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      timeSavedHours: (json['time_saved_hours'] as num).round(),
    );
  }

  @override
  String toString() =>
      'Savings(percentage: $percentage, amount: $amount, timeSavedHours: $timeSavedHours)';
}

class SpendingLimits {
  final double daily;
  final double weekly;

  SpendingLimits({required this.daily, required this.weekly});

  factory SpendingLimits.fromJson(Map<String, dynamic> json) {
    return SpendingLimits(
      daily: (json['daily'] as num).toDouble(),
      weekly: (json['weekly'] as num).toDouble(),
    );
  }

  @override
  String toString() => 'SpendingLimits(daily: $daily, weekly: $weekly)';
}
