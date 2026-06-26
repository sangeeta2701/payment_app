import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';

class QrActionControls extends StatelessWidget {
  const QrActionControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.share_outlined,
            label: "Share",
            onTap: () {},
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            icon: Icons.add_to_home_screen_outlined,
            label: "Add QR to Ho...",
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18.sp, color: const Color(0xFF2C3E50)),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: const Color(0xFF2C3E50)),
            )
          ],
        ),
      ),
    );
  }
}