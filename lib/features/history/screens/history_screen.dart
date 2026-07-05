import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ➔ IMPORTED RIVERPOD
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/History/widgets/account_horizobtal_list.dart';
import '../models/transaction_model.dart';
import '../providers/history_notifier.dart'; // Import providers
import '../widgets/payment_history_header.dart';
import '../widgets/month_group_header.dart';
import '../widgets/transaction_item_tile.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  bool _isSearching = false;

  void _handleSearchToggle(bool searching) {
    setState(() {
      _isSearching = searching;
      if (!searching) {
        ref.read(historySearchQueryProvider.notifier).state = ""; // Clear state clean
      }
    });
  }

  void _filterSearch(String query) {
    ref.read(historySearchQueryProvider.notifier).state = query.trim();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Read live database stream collections reactively
    final historyStream = ref.watch(historyStreamProvider);
    final searchQuery = ref.watch(historySearchQueryProvider);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Balance & History",
          style: AppTextStyles.blackContentTextStyle.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
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

          PaymentHistoryHeader(
            isSearching: _isSearching,
            onSearchToggle: _handleSearchToggle,
            onSearchChanged: _filterSearch,
          ),

          // 2. Wire up Async patterns gracefully inside our list tree framework
          Expanded(
            child: Container(
              color: whiteColor,
              child: historyStream.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text("Connection error: $err", style: const TextStyle(color: Colors.red))),
                data: (masterGroups) {
                  // Apply filter calculations on server collection variables if search is running
                  final displayedGroups = _applySearchFilter(masterGroups, searchQuery);

                  if (displayedGroups.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _buildGroupedListView(displayedGroups);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Local helper strategy processing character filters cleanly over lists
  List<GroupedTransactions> _applySearchFilter(List<GroupedTransactions> data, String query) {
    if (query.isEmpty) return data;
    
    List<GroupedTransactions> filtered = [];
    for (var group in data) {
      final matches = group.transactions.where((tx) {
        return tx.title.toLowerCase().contains(query.toLowerCase()) ||
               tx.categoryTag.toLowerCase().contains(query.toLowerCase());
      }).toList();

      if (matches.isNotEmpty) {
        filtered.add(
          GroupedTransactions(
            monthYear: group.monthYear,
            summaryMeta: group.summaryMeta,
            isCreditSummary: group.isCreditSummary,
            transactions: matches,
          ),
        );
      }
    }
    return filtered;
  }

  Widget _buildGroupedListView(List<GroupedTransactions> targetedData) {
    return ListView.builder(
      itemCount: targetedData.length,
      itemBuilder: (context, groupIndex) {
        final group = targetedData[groupIndex];
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