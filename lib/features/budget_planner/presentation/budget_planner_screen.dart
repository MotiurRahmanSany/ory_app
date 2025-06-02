import 'package:flutter/material.dart';
import 'package:ory/core/common/constants/constants.dart';
import 'package:ory/core/common/widgets/animated_ai_logo.dart';
import 'package:ory/core/common/widgets/shimmer_loader.dart';
import 'package:ory/core/utils/utils.dart';

import '../../../core/services/ai_budget_service.dart';
import 'generated_budget_plan_screen.dart';

class BudgetPlannerScreen extends StatefulWidget {
  const BudgetPlannerScreen({super.key});

  @override
  State<BudgetPlannerScreen> createState() => _BudgetPlannerScreenState();
}

class _BudgetPlannerScreenState extends State<BudgetPlannerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _incomeController = TextEditingController();
  BudgetPeriod _selectedPeriod = BudgetPeriod.monthly;
  final Set<String> _selectedCategories = {};
  bool _isLoading = false;

  static const _mandatoryCategories = ['Food', 'Housing', 'Utilities'];
  static const _optionalCategories = [
    'Entertainment',
    'Travel',
    'Fitness',
    'Education',
  ];

  void _generateSmartPlan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    printLog.d('Generating plan...');
    printLog.w('Selected categories: $_selectedCategories');
    try {
      final plan = await BudgetAIService().generatePlan(
        income: double.parse(_incomeController.text),
        period: _selectedPeriod,
        categories: {..._mandatoryCategories, ..._selectedCategories},
      );
      printLog.i('Generated plan: $plan');
      printLog.i(plan);
      print(plan.toString());
      printLog.i('Plan generated successfully');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GeneratedPlanScreen(plan: plan)),
      );
    } catch (e) {
      printLog.e('Error generating plan: $e');
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Color scheme
  final _primaryColor = Colors.deepPurple;
  final _secondaryColor = Colors.amber;
  final _backgroundColor = Colors.grey[50];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          secondary: _secondaryColor,
        ),
      ),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedAiLogo(
                isAnimating: _isLoading,
                size: Constants.titleLogoSize,
              ),
              const SizedBox(width: 8),
              const Text('Budget Genie'),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body:
            _isLoading
                ? ShimmerLoader(loadingText: 'Generating your plan...')
                : SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Plan your budget with AI',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            _buildIncomeInput(),
                            const SizedBox(height: 30),
                            _buildPeriodSelector(),
                            const SizedBox(height: 30),
                            _buildCategorySelector(),
                            // const Spacer(),
                            SizedBox(height: 50),
                            _buildGenerateButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildIncomeInput() {
    return TextFormField(
      controller: _incomeController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Monthly Income',
        prefixIcon: const Icon(Icons.currency_lira),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        suffixText: 'BDT',
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Enter your income';
        // if income is over 10 billion BDT then it's invalid
        if (double.tryParse(value!) == null || double.parse(value) > 1e10) {
          return 'Invalid amount';
        }
        return null;
      },
    );
  }

  Widget _buildPeriodSelector() {
    return SegmentedButton<BudgetPeriod>(
      segments: const [
        ButtonSegment(
          value: BudgetPeriod.monthly,
          label: Text('Monthly'),
          icon: Icon(Icons.calendar_month_rounded),
        ),
        ButtonSegment(
          value: BudgetPeriod.weekly,
          label: Text('Weekly'),
          icon: Icon(Icons.date_range_rounded),
        ),
        ButtonSegment(
          value: BudgetPeriod.daily,
          label: Text('Daily'),
          icon: Icon(Icons.today_rounded),
        ),
      ],
      selected: {_selectedPeriod},
      onSelectionChanged: (newSelection) {
        setState(() => _selectedPeriod = newSelection.first);
      },
      style: SegmentedButton.styleFrom(
        backgroundColor: _backgroundColor,
        selectedBackgroundColor: _primaryColor,
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Categories',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._mandatoryCategories.map(
              (c) =>
                  _CategoryChip(label: c, isMandatory: true, isSelected: true),
            ),
            ..._optionalCategories.map(
              (c) => _CategoryChip(
                label: c,
                isSelected: _selectedCategories.contains(c),
                onSelected:
                    (selected) => setState(() {
                      selected
                          ? _selectedCategories.add(c)
                          : _selectedCategories.remove(c);
                    }),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
        label: const Text(
          'Generate Smart Plan',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => _generateSmartPlan(),
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isMandatory;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;

  const _CategoryChip({
    required this.label,
    this.isMandatory = false,
    this.isSelected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return ChoiceChip(
      label: Text(label, style: const TextStyle(color: Colors.white)),
      selected: isSelected || isMandatory,
      onSelected: isMandatory ? null : onSelected,
      labelStyle: TextStyle(color: Colors.white),
      selectedColor: Colors.green.shade400,

      backgroundColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.green.shade800),
      ),
    );
  }
}
