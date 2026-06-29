import 'package:flutter/material.dart';


class BankAccountTile extends StatelessWidget {
  final String bankName;
  final String maskedAccount;
  final bool isSelected;
  final ValueChanged<bool> onToggle;

  const BankAccountTile({
    super.key,
    required this.bankName,
    required this.maskedAccount,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}