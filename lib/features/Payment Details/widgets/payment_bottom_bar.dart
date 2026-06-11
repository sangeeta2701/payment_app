import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentBottomBar extends StatelessWidget {
  const PaymentBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 10.h,
        bottom: MediaQuery.of(context).padding.bottom + 10.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F4F9),
                borderRadius: BorderRadius.circular(22.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Message or amount",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          ElevatedButton(
            onPressed: () {
              // Proceed with payment sheet execution flow
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F0C21),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              elevation: 0,
            ),
            child: Text(
              "Pay",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}