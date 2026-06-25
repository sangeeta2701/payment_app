import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/History/widgets/account_horizobtal_list.dart'; 
import '../models/transaction_model.dart';
import '../widgets/payment_history_header.dart';
import '../widgets/month_group_header.dart';
import '../widgets/transaction_item_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<GroupedTransactions> sampleData = [
    GroupedTransactions(
      monthYear: "June 2026",
      summaryMeta: "Total Received \n₹140",
      isCreditSummary: true,
      transactions: [
        TransactionModel(
          id: "1",
          title: "Mridul",
          emojiSuffix: "😉",
          dateString: "Sent on 14 Jun",
          timestamp: "08:52 PM",
          amount: 450.00,
          type: TransactionType.debit,
          categoryTag: "Money Sent",
          categoryBgColor: const Color(0xFFE8F5E9),
          categoryTextColor: const Color(0xFF2E7D32),
          categoryIcon: Icons.call_made,
          providerLogo: "phonepe",
        ),
        TransactionModel(
          id: "2",
          title: "Hrishitha",
          emojiSuffix: "😉😎 Feb 10",
          dateString: "Received on 12 Jun",
          timestamp: "10:25 PM",
          amount: 75.00,
          type: TransactionType.credit,
          categoryTag: "Money Received",
          categoryBgColor: const Color(0xFFE8F5E9),
          categoryTextColor: const Color(0xFF2E7D32),
          categoryIcon: Icons.call_received,
          providerLogo: "phonepe",
        ),
        
        TransactionModel(
          id: "3",
          title: "Hrishitha",
          emojiSuffix: "😉😎 Feb 10",
          dateString: "Received on 10 Jun",
          timestamp: "08:52 PM",
          amount: 65.00,
          type: TransactionType.credit,
          categoryTag: "Money Received",
          categoryBgColor: const Color(0xFFE8F5E9),
          categoryTextColor: const Color(0xFF2E7D32),
          categoryIcon: Icons.call_received,
          providerLogo: "phonepe",
        ),
      ],
    ),
    GroupedTransactions(
      monthYear: "May 2026",
      summaryMeta: "Total Spent\nRefresh ↻",
      isCreditSummary: false,
      transactions: [
        TransactionModel(
          id: "3",
          title: "Hrishitha",
          emojiSuffix: "😉😎 Feb 10",
          dateString: "Received on 27 May",
          timestamp: "10:44 PM",
          amount: 55.00,
          type: TransactionType.credit,
          categoryTag: "Money Received",
          categoryBgColor: const Color(0xFFE8F5E9),
          categoryTextColor: const Color(0xFF2E7D32),
          categoryIcon: Icons.call_received,
          providerLogo: "phonepe",
        ),
      ],
    ),
  ];

  List<GroupedTransactions> _filteredData = [];
  bool _isSearching = false;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _filteredData = sampleData;
  }

  void _handleSearchToggle(bool searching) {
    setState(() {
      _isSearching = searching;
      if (!searching) {
        _searchQuery = "";
        _filteredData = sampleData;
      }
    });
  }

  void _filterSearch(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      setState(() => _filteredData = sampleData);
      return;
    }

    List<GroupedTransactions> matchedGroups = [];
    for (var group in sampleData) {
      final matchingTXs = group.transactions.where((tx) {
        return tx.title.toLowerCase().contains(query.toLowerCase()) ||
               tx.categoryTag.toLowerCase().contains(query.toLowerCase());
      }).toList();

      if (matchingTXs.isNotEmpty) {
        matchedGroups.add(GroupedTransactions(
          monthYear: group.monthYear,
          summaryMeta: group.summaryMeta,
          isCreditSummary: group.isCreditSummary,
          transactions: matchingTXs,
        ));
      }
    }
    setState(() => _filteredData = matchedGroups);
  }

  @override
  Widget build(BuildContext context) {
    // Top layout light blue gradient finish base
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0E7F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Balance & History",
          style: AppTextStyles.blackContentTextStyle.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Top gradient layout wrapper containing Horizontal Accounts
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFD0E7F9), Color(0xFFF4F9FD)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Text(
                    "Your Accounts",
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const AccountsHorizontalList(),
                SizedBox(height: 16.h),
              ],
            ),
          ),
          
          // Action controls header layer
          PaymentHistoryHeader(
            isSearching: _isSearching,
            onSearchToggle: _handleSearchToggle,
            onSearchChanged: _filterSearch,
          ),

          // Main history transaction ledger list view container
          Expanded(
            child: Container(
              color: Colors.white,
              child: _filteredData.isEmpty 
                  ? _buildEmptyState() 
                  : _buildGroupedListView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedListView() {
    return ListView.builder(
      itemCount: _filteredData.length,
      itemBuilder: (context, groupIndex) {
        final group = _filteredData[groupIndex];
        return Column(
          children: [
            MonthGroupHeader(
              monthTitle: group.monthYear,
              summaryText: group.summaryMeta,
              isCredit: group.isCreditSummary,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: group.transactions.length,
              itemBuilder: (context, txIndex) {
                return TransactionItemTile(transaction: group.transactions[txIndex]);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "No matching transaction items found.",
        style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 13.sp),
      ),
    );
  }
}