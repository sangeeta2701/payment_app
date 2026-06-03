import 'package:flutter/material.dart';

class PaymentBottomSheet extends StatefulWidget {
  final List<Map<String, String>> linkedBanks;
  const PaymentBottomSheet({super.key, required this.linkedBanks});

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}