import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/History/widgets/account_horizobtal_list.dart';

import '../models/transaction_model.dart';
import '../providers/account_balance_provider.dart';
import '../providers/history_notifier.dart';
import '../widgets/month_group_header.dart';
import '../widgets/payment_history_header.dart';
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
        ref.read(historySearchQueryProvider.notifier).state = ""; // Clear state cleanly
      }
    });
  }

  void _filterSearch(String query) {
    ref.read(historySearchQueryProvider.notifier).state = query.trim();
  }

  @override
  Widget build(BuildContext context) {
    //  Read live database stream & search queries
    final historyStream = ref.watch(historyStreamProvider);
    final searchQuery = ref.watch(historySearchQueryProvider);

    // Read live account balance provider
    final accountsMap = ref.watch(accountBalanceProvider);

    // Dynamic calculations for Total Balance header summary
    double totalBalance = 0;
    int fetchedCount = 0;
    accountsMap.forEach((_, data) {
      if (data.state == BalanceState.fetched && data.balance != null) {
        totalBalance += data.balance!;
        fetchedCount++;
      }
    });

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? whiteColor : blackColor;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Balance & History",
          style: AppTextStyles.blackContentTextStyle(context).copyWith(
            fontSize: 18.sp,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Accounts Section Wrapper Container
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [whiteColor, Color(0xFFF8FAFC)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header displaying Total Balance matching reference UI
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Accounts",
                            style: AppTextStyles.headingBlackTextStyle(context).copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (fetchedCount > 0) ...[
                            SizedBox(height: 4.h),
                            Text(
                              "Total Balance: ₹${totalBalance.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        "($fetchedCount of ${accountsMap.length} accounts)",
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                height8,
                const AccountsHorizontalList(),
                height16,
              ],
            ),
          ),

          // Search & Filter Header Toolbar
          PaymentHistoryHeader(
            isSearching: _isSearching,
            onSearchToggle: _handleSearchToggle,
            onSearchChanged: _filterSearch,
          ),

          // Transaction Stream History View
          Expanded(
            child: Container(
              color: whiteColor,
              child: historyStream.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text(
                    "Connection error: $err",
                    style: const TextStyle(color: redColor, fontSize: 14),
                  ),
                ),
                data: (masterGroups) {
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

  // Filter strategy processing character query over list items
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
        style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 13.sp),
      ),
    );
  }
}