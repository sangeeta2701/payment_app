import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/home/widgets/feature_shortcut.dart';
import 'package:payment_app/features/home/widgets/rechargeBill_shortcut.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: themeColorLight,
              child: Text(
                "SG",
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: themeColor,
                ),
              ),
            ),
          ),
          actions: [
            Icon(Icons.search, color: themeColor, size: 20.h),
            width8,
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.notifications_outlined,
                color: themeColor,
                size: 20.h,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "UPI Money Transfer",
                  style: AppTextStyles.headingBlackTextStyle.copyWith(
                    fontSize: 14.sp,
                  ),
                ),
                height12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //****************Shortcuts of the app features***************/
                    featureShortcuts(Icons.qr_code_scanner, "Scan\n Any QR"),
                    featureShortcuts(Icons.people_alt, "Pay\nAnyone"),
                    featureShortcuts(Icons.account_balance, "Bank\nTransfer"),
                    featureShortcuts(Icons.article, "Balance &\nHistory"),
                  ],
                ),

                height30,
                Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recharge & Bill Payments",
                          style: AppTextStyles.headingBlackTextStyle.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        height20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            rechargeBillShortcuts(
                              Icons.phone_android_outlined,
                              "Mobile\nRecharge",
                            ),
                            rechargeBillShortcuts(Icons.tv, "DTH\nRecharge"),
                            rechargeBillShortcuts(
                              Icons.lightbulb_outline,
                              "Electricity\nBill",
                            ),
                            rechargeBillShortcuts(
                              Icons.water_drop_outlined,
                              "Water\nBill",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                height30,
                Container(
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: themeColorLight,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset("assets/images/cashback.png", height: 60.h),
                      Text(
                        "Assured Cashback on your\nfirst transaction",
                        style: AppTextStyles.headingBlackTextStyle.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                height30,
                Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Travel & Tickets",
                          style: AppTextStyles.headingBlackTextStyle.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        height20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            rechargeBillShortcuts(
                              Icons.flight_outlined,
                              "Flight",
                            ),
                            rechargeBillShortcuts(
                              Icons.train_outlined,
                              "Train",
                            ),
                            rechargeBillShortcuts(
                              Icons.directions_bus_outlined,
                              "Bus",
                            ),
                            rechargeBillShortcuts(
                              Icons.domain_outlined,
                              "Hotels",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                height30,
                Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Financial Services",
                          style: AppTextStyles.headingBlackTextStyle.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        height20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            rechargeBillShortcuts(
                              Icons.currency_rupee_outlined,
                              "Loan",
                            ),
                            rechargeBillShortcuts(
                              Icons.directions_car_outlined,
                              "Car\nInsurance",
                            ),
                            rechargeBillShortcuts(
                              Icons.monetization_on_outlined,
                              "Save in\nGolds",
                            ),
                            rechargeBillShortcuts(
                              Icons.bar_chart_outlined,
                              "Stocks",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                height30,
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: themeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          icon: Icon(Icons.qr_code_scanner, color: whiteColor),
          label: Text(
            "Scan QR",
            style: AppTextStyles.whiteContentTextStyle.copyWith(
              fontSize: 12.sp,
            ),
          ),
        ),
      ),
    );
  }
}
