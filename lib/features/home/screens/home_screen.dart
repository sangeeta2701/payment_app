import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ➔ IMPORTED RIVERPOD
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/core/theme/theme_provider.dart';
import 'package:payment_app/features/Bank%20Transfer/screen/bank_transfer_screen.dart';
import 'package:payment_app/features/Mobile%20Recharge/screens/mobile_rechage_screen.dart';
import 'package:payment_app/features/Pay%20Anyone/screens/pay_anyone_screen.dart';
import 'package:payment_app/features/Profile/screen/my_qr_profile_screen.dart';
import 'package:payment_app/features/history/screens/history_screen.dart';
import 'package:payment_app/features/Home/widgets/add_bank_bottom_sheet.dart';
import 'package:payment_app/features/Home/widgets/feature_shortcut.dart';
import 'package:payment_app/features/Home/widgets/rechargeBill_shortcut.dart';
import 'package:payment_app/features/scan/screens/scan_screen.dart';
import 'package:payment_app/features/Add%20Bank/providers/bank_notifier.dart'; // ➔ IMPORT YOUR NOTIFIER

// ➔ CHANGED TO ConsumerStatefulWidget
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  

  @override
  Widget build(BuildContext context) {
    // ➔ LISTEN TO USER BANK ONBOARDING STATUS REACTIVELY
    ref.listen<AsyncValue<bool>>(userAccountStatusStreamProvider, (previous, next) {
      next.whenData((isLinked) {
        if (!isLinked && mounted) {
          showAddBankBottomSheet(context);
        }
      });
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: transparent,
      ),
      child: Scaffold(
        // backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: transparent,
          elevation: 0,
          surfaceTintColor: transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyQrProfileScreen()));
              },
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
          ),
         actions: [
    // ➔ DYNAMIC CONTRAST FIX: Switch icons to White in Dark Mode, and baseline themeColor in Light Mode!
    Icon(
      Icons.search, 
      color: Theme.of(context).brightness == Brightness.dark ?whiteColor : themeColor, 
      size: 20.h,
    ),
    width8,
    Icon(
      Icons.notifications_outlined,
      color: Theme.of(context).brightness == Brightness.dark ? whiteColor : themeColor,
      size: 20.h,
    ),
    width8,
    IconButton(
      onPressed: () {
        ref.read(themeModeProvider.notifier).toggleTheme();
      },
      icon: Icon(
        ref.watch(themeModeProvider) == ThemeMode.light
            ? Icons.dark_mode_outlined
            : Icons.light_mode_outlined,
        color: Theme.of(context).brightness == Brightness.dark ? whiteColor : themeColor,
        size: 20.h,
      ),
    ),
    width12
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
                  style: AppTextStyles.headingBlackTextStyle(context).copyWith(
                    fontSize: 14.sp,
                  ),
                ),
                height12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    featureShortcuts(Icons.qr_code_scanner, "Scan\n Any QR", (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanScreen()));
                    }, context),
                    featureShortcuts(Icons.people_alt, "Pay\nAnyone", (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PayAnyoneScreen()));
                    }, context),
                    featureShortcuts(Icons.account_balance, "Bank\nTransfer", (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const BankTransferScreen()));
                    }, context),
                    featureShortcuts(Icons.article, "Balance &\nHistory", (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
                    }, context),
                  ],
                ),
      
                height20,
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
                          style: AppTextStyles.headingBlackTextStyle(context).copyWith(
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
                              () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const MobileRechargeScreen()));
                              },
                              context
                            ),
                            rechargeBillShortcuts(Icons.tv, "DTH\nRecharge", () {
                              // Handle tap event for DTH Recharge
                            }, context),
                            rechargeBillShortcuts(
                              Icons.lightbulb_outline,
                              "Electricity\nBill",
                              () {
                                // Handle tap event for Electricity Bill
                              },
                              context
                            ),
                            rechargeBillShortcuts(
                              Icons.water_drop_outlined,
                              "Water\nBill",
                              () {
                                // Handle tap event for Water Bill
                              },
                              context
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                height20,
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
                        style: AppTextStyles.headingBlackTextStyle(context).copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                height20,
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
                          style: AppTextStyles.headingBlackTextStyle(context).copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        height12,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            rechargeBillShortcuts(
                              Icons.flight_outlined,
                              "Flight",
                              () {
                                // Handle tap event for Flight
                              },
                              context
                            ),
                            rechargeBillShortcuts(
                              Icons.train_outlined,
                              "Train",
                              () {
                                // Handle tap event for Train
                              },
                              context
                            ),
                            rechargeBillShortcuts(
                              Icons.directions_bus_outlined,
                              "Bus",
                              () {
                                // Handle tap event for Bus
                              },
                              context
                            ),
                            rechargeBillShortcuts(
                              Icons.domain_outlined,
                              "Hotels",
                              () {
                                // Handle tap event for Hotels
                              },
                              context
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                height20,
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
                          style: AppTextStyles.headingBlackTextStyle(context).copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        height12,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            rechargeBillShortcuts(
                              Icons.currency_rupee_outlined,
                              "Loan",
                              () {
                                // Handle tap event for Loan
                              },
                              context
                            ),
                            rechargeBillShortcuts(
                              Icons.directions_car_outlined,
                              "Car\nInsurance",
                              () {
                                // Handle tap event for Car Insurance
                              },
                              context
                            ),
                            rechargeBillShortcuts(
                              Icons.monetization_on_outlined,
                              "Save in\nGolds",
                              () {
                                // Handle tap event for Golds
                              },
                              context
                            ),
                            rechargeBillShortcuts(
                              Icons.bar_chart_outlined,
                              "Stocks",
                              () {
                                // Handle tap event for Stocks
                              },
                              context
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                height90,
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanScreen()));
          },
          backgroundColor: themeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          icon: Icon(Icons.qr_code_scanner, color: whiteColor),
          label: Text(
            "Scan QR",
            style: AppTextStyles.whiteContentTextStyle(context).copyWith(
              fontSize: 12.sp,
            ),
          ),
        ),
      ),
    );
  }
}