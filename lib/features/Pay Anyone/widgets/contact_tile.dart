// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:payment_app/core/theme/app_colors.dart';
// import 'package:payment_app/core/theme/text_stylies.dart';
// import 'package:payment_app/features/Pay%20Anyone/model/contact_model.dart';

// class ContactTile extends StatelessWidget {
//   final PayContact contact;
//   final VoidCallback onTap;

//   const ContactTile({super.key, required this.contact, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     String initials = contact.displayName.isNotEmpty
//         ? contact.displayName.trim().split(' ').map((l) => l[0]).take(2).join().toUpperCase()
//         : "#";

//     return ListTile(
//       onTap: onTap,
//       contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
//       leading: CircleAvatar(
//         radius: 22.r,
//         backgroundColor: contact.isSavedContact ? const Color(0xFFE8E7ED) : const Color(0xFFE3F2FD),
//         child: Text(
//           initials,
//           style: TextStyle(
//             fontSize: 14.sp, 
//             fontWeight: FontWeight.bold, 
//             color: contact.isSavedContact ? Colors.black87 : themeColor,
//           ),
//         ),
//       ),
//       title: Text(
//         contact.displayName,
//         style: AppTextStyles.blackContentTextStyle.copyWith(fontSize: 14.sp, ),
//       ),
//       subtitle: Text(
//         "${contact.phoneNumber} • ${contact.subtitleInfo ?? 'Mobile'}",
//         style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 12.sp),
//       ),
//       trailing: Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey.shade400),
//     );
//   }
// } 


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Pay%20Anyone/model/contact_model.dart';

class ContactTile extends StatelessWidget {
  final PayContact contact;
  final VoidCallback onTap;

  const ContactTile({super.key, required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // FIX: Filters out empty values safely to prevent RangeError crash
    final words = contact.displayName.trim().split(' ').where((w) => w.isNotEmpty).toList();
    
    String initials = "#";
    if (words.isNotEmpty) {
      initials = words.map((l) => l[0]).take(2).join().toUpperCase();
    }

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      leading: CircleAvatar(
        radius: 22.r,
        backgroundColor: contact.isSavedContact ? const Color(0xFFE8E7ED) : const Color(0xFFE3F2FD),
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 14.sp, 
            fontWeight: FontWeight.bold, 
            color: contact.isSavedContact ? Colors.black87 : themeColor,
          ),
        ),
      ),
      title: Text(
        contact.displayName,
        style: AppTextStyles.blackContentTextStyle(context).copyWith(fontSize: 14.sp),
      ),
      subtitle: Text(
        "${contact.phoneNumber} • ${contact.subtitleInfo ?? 'Mobile'}",
        style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 12.sp),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey.shade400),
    );
  }
}