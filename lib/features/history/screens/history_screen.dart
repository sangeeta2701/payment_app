// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:payment_app/core/theme/text_stylies.dart';

// class HistoryScreen extends StatefulWidget {
//   const HistoryScreen({super.key});

//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }

// class _HistoryScreenState extends State<HistoryScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
//         child: Column(
//           children: [
//             Text("Transaction History", style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 14.sp)),
//           ],
//         ),
//       ),
//     );
//   }
// } 



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/features/history/models/transaction_model.dart';
import 'package:payment_app/features/history/widgets/header_section.dart';
import 'package:payment_app/features/history/widgets/month_group_header.dart';
import 'package:payment_app/features/history/widgets/search_bar_row.dart';
import 'package:payment_app/features/history/widgets/transaction_item_tile.dart'; 

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Dummy data representing the image structure
  final List<GroupedTransactions> sampleData = [
    GroupedTransactions(
      monthYear: "June 2026",
      transactions: [
        TransactionModel(
          id: "1",
          title: "ZAVE SHOPPING TEC...",
          subtitle: "2 hours ago",
          amount: 377.86,
          type: TransactionType.debit,
          fallbackIcon: Icons.arrow_outward,
          bankLogoAsset: 'assets/bank_a.png',
        ),
        TransactionModel(
          id: "2",
          title: "Transfer to XXXXXX0123",
          subtitle: "1 day ago",
          amount: 600.00,
          type: TransactionType.debit,
          fallbackIcon: Icons.account_balance_wallet,
          bankLogoAsset: 'assets/bank_b.png',
        ),
      ],
    ),
    GroupedTransactions(
      monthYear: "May 2026",
      transactions: [
        TransactionModel(
          id: "3",
          title: "Received from Boo 🌷❤️",
          subtitle: "28 May",
          amount: 1000.00,
          type: TransactionType.credit,
          avatarUrl: "https://img.magnific.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80", 
          bankLogoAsset: 'assets/bank_a.png',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            const HeaderSection(),
            SizedBox(height: 20.h),
            const SearchBarRow(),
            SizedBox(height: 24.h),
            Expanded(
              child: ListView.builder(
                itemCount: sampleData.length,
                itemBuilder: (context, groupIndex) {
                  final group = sampleData[groupIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MonthGroupHeader(title: group.monthYear),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: group.transactions.length,
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey.shade100,
                          height: 1,
                          indent: 72.w, 
                        ),
                        itemBuilder: (context, txIndex) {
                          return TransactionItemTile(transaction: group.transactions[txIndex]);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}