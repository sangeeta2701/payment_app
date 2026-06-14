import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';

class AccountsHorizontalList extends StatelessWidget {
  const AccountsHorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 145.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          // Card 1: State Bank of India Account Card
          _buildAccountCard(
            gradientColors: [const Color(0xFF004B93), const Color(0xFF0066C4)],
            title: "SBI Bank",
            subtitle: "A/c No: 0106",
            actionLabel: "Check Balance",
            logoWidget: const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Icon(Icons.account_balance, size: 14, color: Color(0xFF0066C4)),
            ),
          ),
          SizedBox(width: 12.w),
          
          // Card 2: UPI Lite Fast Account card
          _buildAccountCard(
            gradientColors: [const Color(0xFF3B7EFF), const Color(0xFF5CA3FF)],
            title: "UPI Lite",
            subtitle: "",
            actionLabel: "Activate",
            logoWidget: const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.amber,
              child: Icon(Icons.flash_on, size: 14, color: Colors.white),
            ),
          ),
          SizedBox(width: 12.w),
          
          // Card 3: Paytm Bank / Secondary mock container element
          Container(
            width: 150.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
              color: Colors.white.withOpacity(0.6),
            ),
            child: Center(
              child: Text("Paytm Wallet", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAccountCard({
    required List<Color> gradientColors,
    required String title,
    required String subtitle,
    required String actionLabel,
    required Widget logoWidget,
  }) {
    return Container(
      width: 160.w,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: gradientColors[0].withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle, style: TextStyle(color: whiteColor, fontSize: 11.sp)),
                ],
              ),
              logoWidget,
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.85),
              foregroundColor: blackColor,
              elevation: 0,
              minimumSize: Size(double.infinity, 32.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              padding: EdgeInsets.zero,
            ),
            child: Text(actionLabel, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}