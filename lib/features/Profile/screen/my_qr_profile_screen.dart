import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Profile/widgets/linked_bank_selector.dart';
import 'package:payment_app/features/Profile/widgets/qr_action_controls.dart';
import 'package:payment_app/features/Profile/widgets/qr_display_card.dart';
import 'package:payment_app/features/Profile/widgets/upi_allowance_banner.dart';
import 'package:payment_app/features/Profile/widgets/user_profile_header.dart';



class MyQrProfileScreen extends StatelessWidget {
  const MyQrProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      backgroundColor: bgColor, 
      appBar: AppBar(
        backgroundColor: bgColor, 
        elevation: 0,
        scrolledUnderElevation: 0, 
  surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.black87),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              // 1. Top Brand Asset placement
              Center(
                child: Column(
                  children: [
                    Text(
                      "paytm",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w900,
                        color: themeColor,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      "Accepted Here",
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // 2. User dynamic text header block
              const UserProfileHeader(
                name: "Sangeeta Gupta",
                upiId: "6266520680@paytm",
                isVerified: true,
              ),
              SizedBox(height: 12.h),

              // 3. Status warning prompt action banner
              const UpiAllowanceBanner(),
              SizedBox(height: 16.h),

              // 4. Center QR graphic card frame container
              const QrDisplayCard(qrPayloadData: "upi://pay?pa=6266520680@paytm&pn=Sangeeta%20Gupta"),
              SizedBox(height: 16.h),

              // 5. Active underlying bank metadata connector
              const LinkedBankSelector(
                bankName: "State Bank Of India",
                accountSuffix: "0106",
              ),
              SizedBox(height: 16.h),

              // 6. Action Share row controls buttons
              const QrActionControls(),
              SizedBox(height: 16.h),
              
              // Bottom Promotional Voucher block match
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: const LinearGradient(
                    colors: [lightBlueColor, themeColor],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("EPIC GETAWAYS SALE", 
                          style: AppTextStyles.blackContentTextStyle.copyWith(fontSize: 10.sp, height:1.2)
                          ),
                          SizedBox(height: 4.h),
                          Text("Get 20% off on\ntravel bookings", style: AppTextStyles.whiteContentTextStyle.copyWith(fontSize: 13.sp, height: 1.0)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lightBlueColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      ),
                      // ),
                      child: Text("Book Now →", style: AppTextStyles.whiteButtonTextStyle.copyWith(fontSize: 11.sp)
                      
                    )
                    )
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}