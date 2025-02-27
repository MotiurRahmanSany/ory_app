// Add this state notifier provider
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((
  ref,
) {
  return PaymentNotifier();
});

class PaymentNotifier extends StateNotifier<PaymentState> {
  PaymentNotifier() : super(PaymentState(balance: 1000.0, points: 100));

  void makePayment(double amount) {
    final newBalance = state.balance - amount;
    final newPoints =
        state.points +
        (amount ~/ 10); // 1 point per 10৳ spent means 10% increase in points
    state = PaymentState(balance: newBalance, points: newPoints);
  }
}

class PaymentState {
  final double balance;
  final int points;

  PaymentState({required this.balance, required this.points});
}
