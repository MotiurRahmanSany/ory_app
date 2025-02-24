import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Amount: ৳100',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Payment Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            // Add more payment details here
            Spacer(),
            ElevatedButton(
              onPressed: () => _handlePayment(context),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePayment(BuildContext context) {
    final bool hasSufficientBalance = _checkBalance();

    if (hasSufficientBalance) {
      _addRewardPoints();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaymentSuccessScreen()),
      );
    } else {
      _showInsufficientBalanceDialog(context);
    }
  }

  bool _checkBalance() {
    // Replace with actual balance check logic
    return false;
  }

  void _addRewardPoints() {
    // Replace with actual reward points logic
  }

  void _showInsufficientBalanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Insufficient Balance'),
            content: Text(
              'You do not have enough balance to complete this payment.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Success')),
      body: Center(
        child: Text(
          'Payment Successful! Reward points have been added to your account.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
