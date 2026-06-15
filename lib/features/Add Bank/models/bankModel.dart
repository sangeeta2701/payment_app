import 'package:flutter/material.dart';

class BankModel {
  final String id;
  final String name;
  final String? assetPath; 
  final IconData fallbackIcon;
  final bool isPopular;

  BankModel({
    required this.id,
    required this.name,
    this.assetPath,
    this.fallbackIcon = Icons.account_balance,
    required this.isPopular,
  });
}