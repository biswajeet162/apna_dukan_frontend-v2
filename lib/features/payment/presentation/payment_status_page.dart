import 'package:flutter/material.dart';

class PaymentStatusPage extends StatelessWidget {
  const PaymentStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Status'),
      ),
      body: const Center(
        child: Text('Payment Status Page'),
      ),
    );
  }
}
