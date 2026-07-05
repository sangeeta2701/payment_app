import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

/// Reactive dynamic streaming pipeline watching matching transactional records
final historyStreamProvider = StreamProvider<List<GroupedTransactions>>((ref) {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('transactions')
      .where('combinedRoomId', arrayContains: user.uid)
      .snapshots()
      .map((snapshot) {
        // 1. Map raw document entities into pristine structural models
        final List<TransactionModel> allTransactions = snapshot.docs.map((doc) {
          final data = doc.data();
          final timestampField = data['timestamp'] as Timestamp?;
          final DateTime dateTime = timestampField != null ? timestampField.toDate() : DateTime.now();

          // Evaluate dynamically whether current profile spent or earned the asset value
          final bool isDebit = data['senderId'] == user.uid;
          
          return TransactionModel(
            id: doc.id,
            title: isDebit ? (data['receiverName'] ?? "Unknown") : (data['senderName'] ?? "Self"),
            emojiSuffix: "",
            dateString: DateFormat('dd MMM').format(dateTime),
            timestamp: DateFormat('hh:mm a').format(dateTime),
            amount: (data['amount'] as num? ?? 0).toDouble(),
            type: isDebit ? TransactionType.debit : TransactionType.credit,
            categoryTag: isDebit ? "Money Sent" : "Money Received",
            categoryBgColor: const Color(0xFFE8F5E9),
            categoryTextColor: const Color(0xFF2E7D32),
            categoryIcon: isDebit ? Icons.call_made : Icons.call_received,
            providerLogo: data['bankName'] ?? "UPI Bank",
            rawDateTime: dateTime, // Needed for operational sort loops
          );
        }).toList();

        // 2. Sort comprehensively by real chronological timestamp metric profiles
        allTransactions.sort((a, b) => b.rawDateTime.compareTo(a.rawDateTime));

        // 3. Cluster collection rows into distinct Month/Year segments
        final Map<String, List<TransactionModel>> groupsMap = {};
        for (var tx in allTransactions) {
          final String monthKey = DateFormat('MMMM yyyy').format(tx.rawDateTime);
          groupsMap.putIfAbsent(monthKey, () => []).add(tx);
        }

        // 4. Generate metadata metrics definitions dynamically
        final List<GroupedTransactions> finalGroupedList = [];
        groupsMap.forEach((monthYear, txList) {
          double totalReceived = 0;
          double totalSpent = 0;

          for (var tx in txList) {
            if (tx.type == TransactionType.credit) {
              totalReceived += tx.amount;
            } else {
              totalSpent += tx.amount;
            }
          }

          final String summaryMeta = totalReceived >= totalSpent 
              ? "Total Received \n₹${totalReceived.toInt()}"
              : "Total Spent \n₹${totalSpent.toInt()}";

          finalGroupedList.add(
            GroupedTransactions(
              monthYear: monthYear,
              summaryMeta: summaryMeta,
              isCreditSummary: totalReceived >= totalSpent,
              transactions: txList,
            ),
          );
        });

        return finalGroupedList;
      });
});

/// Client-Side Query Search State Tracker Provider
final historySearchQueryProvider = StateProvider<String>((ref) => "");