import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';

class ContactItemModel {
  final String name;
  final String phone;
  final Color avatarBgColor;
  final Color avatarTextColor;

  ContactItemModel({
    required this.name,
    required this.phone,
    required this.avatarBgColor,
    required this.avatarTextColor,
  });
}

class ContactsListSection extends StatelessWidget {
  const ContactsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded dataset directly mapped to match image_591c01.png layout
    final List<ContactItemModel> dynamicMockList = [
      ContactItemModel(
        name: "~Sangeeta Jnr",
        phone: "9109511761",
        avatarBgColor: const Color(0xFFD4E157).withOpacity(0.4),
        avatarTextColor: const Color(0xFF558B2F),
      ),
      ContactItemModel(
        name: "Aabid pravaah",
        phone: "7992285007",
        avatarBgColor: const Color(0xFFE1BEE7),
        avatarTextColor: const Color(0xFF6A1B9A),
      ),
      ContactItemModel(
        name: "Aadarsh Sir Cse",
        phone: "9827155601",
        avatarBgColor: const Color(0xFFCFD8DC),
        avatarTextColor: const Color(0xFF37474F),
      ),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dynamicMockList.length,
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(left: 72.w),
          child: Divider(color: Colors.grey.shade100, height: 1),
        ),
        itemBuilder: (context, index) {
          final item = dynamicMockList[index];
          
          // Generate explicit 2 letter uppercase initials safely
          final cleaningName = item.name.replaceAll(RegExp(r'[^\w\s]'), '').trim();
          final initials = cleaningName.length >= 2 
              ? cleaningName.substring(0, 2).toUpperCase() 
              : cleaningName.isNotEmpty ? cleaningName.substring(0, 1).toUpperCase() : "CN";

          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            onTap: () {},
            leading: CircleAvatar(
              radius: 22.r,
              backgroundColor: item.avatarBgColor,
              child: Text(
                initials,
                style: TextStyle(
                  color: item.avatarTextColor, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 13.sp,
                ),
              ),
            ),
            title: Text(
              item.name,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackColor),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Text(
                item.phone,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
              ),
            ),
          );
        },
      ),
    );
  }
}