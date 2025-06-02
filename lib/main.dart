import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ory/config/route_path.dart';
import 'package:ory/config/theme_provider.dart';
import 'package:ory/core/common/constants/constants.dart';
import 'package:ory/features/home/presentation/home_screen.dart';
import 'package:ory/features/budget_planner/presentation/budget_planner_screen.dart';
import 'package:ory/features/health_care/presentation/prescription_screen.dart';
import 'package:ory/features/scheduler/presentation/schedule_screen.dart';
import 'package:ory/features/app_recommendation/presentation/recommendation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    throw Exception('Error loading .env file: $e'); // Print error if any
  }

 
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      theme: theme,
      title: Constants.appTitle,
      home: HomeScreen(),
      routes: {
        RoutePath.prescription: (context) => const PrescriptionScreen(),
        RoutePath.workScheduling: (context) => const ScheduleScreen(),
        RoutePath.recommendation: (context) => const RecommendationScreen(),
        RoutePath.makePayment: (context) => const BudgetPlannerScreen(),
      },
    );
  }
}
