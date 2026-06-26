import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';

class UserProfileHeader extends StatelessWidget {
  final String name;
  final String upiId;
  final bool isVerified;

  const UserProfileHeader({
    super.key,
    required this.name,
    required this.upiId,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Camera-overlay editable avatar stack frame
        Stack(
          children: [
            CircleAvatar(
              radius: 28.r,
              backgroundColor: Colors.grey.shade200,
              child: Icon(Icons.person, size: 36.sp, color: Colors.grey.shade400),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 9.r,
                backgroundColor: whiteColor,
                child: Icon(Icons.camera_alt, size: 11.sp, color: Colors.black54),
              ),
            )
          ],
        ),
        SizedBox(width: 14.w),
        
        // Context Name Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 18.sp,),
                  ),
                  if (isVerified) ...[
                    SizedBox(width: 4.w),
                    Icon(Icons.verified, color: lightBlueColor, size: 16.sp),
                  ]
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Text(
                    "UPI ID: $upiId",
                    // style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                    style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 6.w),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: upiId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("UPI ID copied to clipboard"), duration: Duration(seconds: 1)),
                      );
                    },
                    child: Icon(Icons.copy, size: 14.sp, color: lightBlueColor),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}