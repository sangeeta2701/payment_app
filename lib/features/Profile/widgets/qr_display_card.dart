import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrDisplayCard extends StatelessWidget {
  final String qrPayloadData;

  const QrDisplayCard({super.key, required this.qrPayloadData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFF002E72), width: 4), // Solid tracking color bounding stroke
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: whiteColor,
            ),
            child: QrImageView(
              data: qrPayloadData,
              version: QrVersions.auto,
              size: 240.w,
              gapless: false,
              embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(40, 40)),
            ),
          ),
        ],
      ),
    );
  }
}