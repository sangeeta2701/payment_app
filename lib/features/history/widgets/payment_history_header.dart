import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentHistoryHeader extends StatelessWidget {
  final bool isSearching;
  final Function(bool) onSearchToggle;
  final ValueChanged<String> onSearchChanged;

  const PaymentHistoryHeader({
    super.key,
    required this.isSearching,
    required this.onSearchToggle,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          if (!isSearching) ...[
            Text(
              "Payment History",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black87),
              onPressed: () => onSearchToggle(true),
            ),
          ] else ...[
            Expanded(
              child: Container(
                height: 38.h,
                decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(18.r)),
                child: TextField(
                  onChanged: onSearchChanged,
                  // autoFocus: true,
                  decoration: InputDecoration(
                    hintText: "Search transactions...",
                    hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, size: 18),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => onSearchToggle(false),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ],
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}