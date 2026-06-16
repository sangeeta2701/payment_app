import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';

class ContactSearchField extends StatelessWidget {
  const ContactSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter Mobile Number or Search Contact",
                hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey.shade500),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.contact_page_outlined, color: themeColor),
            onPressed: () {}, // Open device native contacts address book layout
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}