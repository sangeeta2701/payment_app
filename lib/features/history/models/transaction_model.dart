import 'package:flutter/material.dart';

enum TransactionType { debit, credit }

class TransactionModel {
  final String id;
  final String title;
  final String subtitle; // e.g., "2 hours ago", "28 May"
  final double amount;
  final TransactionType type;
  final String? avatarUrl; // For contacts with images
  final IconData? fallbackIcon; // For generic system/merchant icons
  final String bankLogoAsset; // Path to the small bank logo

  TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
    this.avatarUrl,
    this.fallbackIcon,
    required this.bankLogoAsset,
  });
}

class GroupedTransactions {
  final String monthYear; // e.g., "June 2026"
  final List<TransactionModel> transactions;

  GroupedTransactions({required this.monthYear, required this.transactions});
}