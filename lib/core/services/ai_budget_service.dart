import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ory/core/common/constants/app_secret.dart';

import '../../features/payment/models/budget_plan.dart';
import '../common/constants/constants.dart';
import '../utils/utils.dart';

class BudgetAIService {
  static const String _apiKey = AppSecret.geminiApiKey;
  final GenerativeModel _model;

  BudgetAIService()
    : _model = GenerativeModel(model: Constants.geminiModel, apiKey: _apiKey);

  Future<BudgetPlan> generatePlan({
    required double income,
    required BudgetPeriod period,
    required Set<String> categories,
  }) async {
    final prompt = '''
Generate a comprehensive budget plan with these parameters:
- Monthly Income: \$$income
- Currency: BDT (Bangladeshi Taka)
- Budget Period: ${period.name}
- Categories: ${categories.join(', ')}

Include these elements in JSON format:
1. Breakdown of allocations for each category (percentages and absolute values)
2. Savings plan (percentage and absolute value)
3. Daily/Weekly spending limits based on period
4. Time-saving tips for financial management
5. Assumptions made in calculations
6. Motivational message with savings potential

Structure the response in this exact JSON format:
{
  "total_income": number,
  "period": "monthly/weekly/daily",
  "allocations": [
    {
      "category": "string",
      "percentage": number,
      "amount": number,
      "type": "mandatory/optional"
    }
  ],
  "savings": {
    "percentage": number,
    "amount": number,
    "time_saved_hours": number
  },
  "spending_limits": {
    "daily": number,
    "weekly": number
  },
  "assumptions": "string",
  "motivation": "string"
}

Prioritize:
- Essential categories first
- Minimum 15% savings
- Realistic spending limits
- Practical time-saving tips
- Clear explanations for assumptions
- Positive, encouraging language
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final jsonString = _extractJson(response.text ?? '');
      return BudgetPlan.fromJson(jsonDecode(jsonString));
    } catch (e) {
      throw Exception('Failed to generate plan: ${e.toString()}');
    }
  }

  String _extractJson(String response) {
    final startIndex = response.indexOf('{');
    final endIndex = response.lastIndexOf('}');
    return response.substring(startIndex, endIndex + 1);
  }
}
