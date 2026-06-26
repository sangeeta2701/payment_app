import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/features/Mobile%20Recharge/widgets/contact_list_section.dart';
import 'package:payment_app/features/Mobile%20Recharge/widgets/quick_rechage_section.dart';

// Modular Child Components
import '../widgets/offers_banner.dart';
import '../widgets/contact_search_field.dart';
import '../widgets/my_number_section.dart';

class MobileRechargeScreen extends StatelessWidget {
  const MobileRechargeScreen({super.key});

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
          icon: const Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Recharge or Pay Mobile Bill",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
              height16,

              // 1. Promo Offers Ribbon
              const OffersBanner(offerCount: 26),
              height16,

              // 2. Main Search Input Textbox
              const ContactSearchField(),
              height20,

              // 3. Quick Data Recharges Header & Row
              Text(
                "Quick Data Recharges",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
              height8,
              const QuickRechargesSection(),
              height20,

              // 4. Primary Personal Number Segment
              Text(
                "My Number",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
              height8,
              const MyNumberSection(),
              height20,

              // 5. Phone Contacts Directory List
              Text(
                "My Contacts",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
              height8,
              const ContactsListSection(),
              height20,
            ],
          ),
        ),
      ),
    );
  }
}
