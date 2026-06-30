import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';

class PinDotsIndicator extends StatelessWidget {
  final int pinLength;
  final int maxLength;

  const PinDotsIndicator({
    super.key,
    required this.pinLength,
    this.maxLength = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxLength, (index) {
        bool isFilled = index < pinLength;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          width: 16.w,
          height: 16.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? themeColor : transparent,
            border: Border.all(
              color: isFilled ? themeColor : Colors.grey.shade400,
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}