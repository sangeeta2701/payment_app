import 'package:flutter/material.dart';

enum TransactionType { debit, credit }

class TransactionModel {
  final String id;
  final String title;
  final String? emojiSuffix;
  final String dateString;
  final String timestamp;
  final double amount;
  final TransactionType type;
  final String categoryTag; // e.g., "Money Received", "Shopping"
  final Color categoryBgColor;
  final Color categoryTextColor;
  final IconData? categoryIcon;
  final String providerLogo; // PhonePe, SBI badge identifiers
  final DateTime rawDateTime;

  TransactionModel({
    required this.id,
    required this.title,
    this.emojiSuffix,
    required this.dateString,
    required this.timestamp,
    required this.amount,
    required this.type,
    required this.categoryTag,
    required this.categoryBgColor,
    required this.categoryTextColor,
    this.categoryIcon,
    required this.providerLogo,
    required this.rawDateTime,
  });
}

class GroupedTransactions {
  final String monthYear;
  final String summaryMeta; // e.g., "Total Received ₹140" or "Total Spent"
  final bool isCreditSummary;
  final List<TransactionModel> transactions;

  GroupedTransactions({
    required this.monthYear,
    required this.summaryMeta,
    required this.isCreditSummary,
    required this.transactions,
  });
}