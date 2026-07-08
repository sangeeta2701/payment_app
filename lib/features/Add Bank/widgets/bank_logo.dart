import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';

class BankLogo extends StatelessWidget {
  final String? assetPath;
  final String bankName;
  final double size;

  const BankLogo({
    super.key,
    this.assetPath,
    required this.bankName,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20.r,
      backgroundColor: const Color(0xFFF1F5F9),
      child: assetPath != null && assetPath!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                assetPath!,
                width: size.w,
                height: size.h,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => _buildFallback(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: size.w,
                    height: size.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                },
              ),
            )
          : _buildFallback(),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: 24.w,
      height: 24.h,
      decoration: BoxDecoration(
        color: lightBlueColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        Icons.account_balance,
        color: lightBlueColor,
        size: 18.sp,
      ),
    );
  }
}