import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ory/features/payment/presentation/payment_controller.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final double _totalAmount = 200.00;

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);
    final paymentNotifier = ref.read(paymentProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.payment, size: 50),
                            const SizedBox(height: 15),
                            const Text(
                              'Payment Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'You can pay using your wallet balance.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'GOT IT',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.account_balance_wallet, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '৳${paymentState.balance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '${paymentState.points} Points',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Total Amount to Pay',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '৳$_totalAmount',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bill Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildPaymentBillInfoTile(
                    title: 'Subtotal',
                    value: '${_totalAmount - 25}',
                  ),
                  const SizedBox(height: 5),
                  _buildPaymentBillInfoTile(title: 'Discount', value: '25.00'),
                  const SizedBox(height: 5),
                  _buildPaymentBillInfoTile(title: 'Tax', value: '5.00'),
                  const SizedBox(height: 5),
                  _buildPaymentBillInfoTile(
                    title: 'Total',
                    value: '$_totalAmount',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Confirm Payment'),
                      content: const Text(
                        'Are you sure you want to pay ৳200.00?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                            ); // Close the confirmation dialog
                            if(paymentState.balance < _totalAmount) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Insufficient Balance'),
                                    content: const Text(
                                      'You do not have enough balance to make this payment.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('CLOSE'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return;
                            }
                            paymentNotifier.makePayment(_totalAmount);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Payment Successful'),
                                  content: _buildPaymentSuccess(),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('CLOSE'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text('PAY NOW'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('PAY NOW'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSuccess() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle, size: 50, color: Colors.green),
        const SizedBox(height: 10),
        const Text(
          'Payment Successful',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Your payment was successful. Thank you for your purchase.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildPaymentBillInfoTile({
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Expanded(child: Text('$title:', style: const TextStyle(fontSize: 16))),
        Text('৳$value', style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
