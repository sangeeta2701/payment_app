import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import '../model/contact_model.dart';

class RecentContactsBar extends StatelessWidget {
  final List<PayContact> recentContacts;
  final Function(PayContact) onContactTap;

  const RecentContactsBar({
    super.key,
    required this.recentContacts,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    if (recentContacts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          child: Text(
            "Recents",
            style: AppTextStyles.greyContentTextStyle.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 85.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            itemCount: recentContacts.length,
            itemBuilder: (context, index) {
              final contact = recentContacts[index];
              final words = contact.displayName.trim().split(' ').where((w) => w.isNotEmpty).toList();
              final initials = words.isNotEmpty ? words.map((l) => l[0]).take(2).join().toUpperCase() : "#";
              final firstName = words.isNotEmpty ? words.first : contact.displayName;

              return GestureDetector(
                onTap: () => onContactTap(contact),
                child: Container(
                  width: 70.w,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 24.r,
                        backgroundColor: const Color(0xFFE8E7ED),
                        child: Text(
                          initials,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        firstName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.blackContentTextStyle.copyWith(fontSize: 11.sp),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(thickness: 1, color: Color(0xFFF0F0F2)),
      ],
    );
  }
}