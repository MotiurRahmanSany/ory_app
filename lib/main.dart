import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ory/config/route_path.dart';
import 'package:ory/config/theme_provider.dart';
import 'package:ory/core/common/constants/constants.dart';
import 'package:ory/features/home/presentation/home_screen.dart';
import 'package:ory/features/payment/presentation/payment_screen.dart';
import 'package:ory/features/prescription/presentation/prescription_screen.dart';
import 'package:ory/features/schedule/presentation/schedule_screen.dart';
import 'package:ory/features/recommendation/presentation/recommendation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
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
        RoutePath.makePayment: (context) => const PaymentScreen(),
      },
    );
  }
}
