import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/features/Pay%20Anyone/model/contact_model.dart';


class PaymentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PayContact contact;
  const PaymentAppBar({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    // Generate initials safely
    final words = contact.displayName.trim().split(' ').where((w) => w.isNotEmpty).toList();
    String initials = words.isNotEmpty ? words.map((l) => l[0]).take(2).join().toUpperCase() : "#";

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: contact.isSavedContact ? const Color(0xFFE8E7ED) : const Color(0xFFE3F2FD),
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: contact.isSavedContact ? Colors.black87 : const Color(0xFF5C5470),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.displayName,
                  style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2.h),
                Text(
                  contact.phoneNumber,
                  style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}