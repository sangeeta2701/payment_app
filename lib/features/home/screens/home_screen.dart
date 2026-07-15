
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:payment_app/core/constants/sizedbox.dart';
// import 'package:payment_app/core/theme/app_colors.dart';
// import 'package:payment_app/core/theme/text_stylies.dart';
// import 'package:payment_app/core/theme/theme_provider.dart';
// import 'package:payment_app/features/Bank%20Transfer/screen/bank_transfer_screen.dart';
// import 'package:payment_app/features/Mobile%20Recharge/screens/mobile_rechage_screen.dart';
// import 'package:payment_app/features/Pay%20Anyone/screens/pay_anyone_screen.dart';
// import 'package:payment_app/features/Profile/screen/my_qr_profile_screen.dart';
// import 'package:payment_app/features/history/screens/history_screen.dart';
// import 'package:payment_app/features/Home/widgets/add_bank_bottom_sheet.dart';
// import 'package:payment_app/features/Home/widgets/feature_shortcut.dart';
// import 'package:payment_app/features/Home/widgets/rechargeBill_shortcut.dart';
// import 'package:payment_app/features/scan/screens/scan_screen.dart';
// import 'package:payment_app/features/Add%20Bank/providers/bank_notifier.dart';
// import 'package:payment_app/features/biometrics/security_provider.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
  
//   @override
//   @override
// void initState() {
//   super.initState();
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     final securityState = ref.read(securityProvider);
//     //Only trigger if not already attempted this session
//     if (!securityState.hasAttemptedAuth) {
//       _executeSecurityGateChallenge();
//     }
//   });
// }

// Future<void> _executeSecurityGateChallenge() async {
//   if (!mounted) return;
//   bool isAuthSuccess =
//       await ref.read(securityProvider.notifier).verifyIdentity();
//   if (!isAuthSuccess && mounted) {
//     _showLockBottomSheetOverlay();
//   }
// }

//   void _showLockBottomSheetOverlay() {
//     if (!mounted) return;
    
//     showModalBottomSheet(
//       context: context,
//       isDismissible: false, 
//       enableDrag: false,    
//       backgroundColor: Theme.of(context).cardColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(16.w),
//                 decoration: BoxDecoration(
//                   color: lightBlueColor.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.security_rounded,
//                   size: 40.sp,
//                   color: themeColor,
//                 ),
//               ),
//               height16,
//               Text(
//                 "Wallet App Locked",
//                 style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 18.sp),
//               ),
//               height8,
//               Text(
//                 "Identity verification is required to safely access account details and execute financial transactions.",
//                 textAlign: TextAlign.center,
//                 style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 12.sp, height: 1.4),
//               ),
//               height24,
//               ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: themeColor,
//                   minimumSize: Size(double.infinity, 48.h),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
//                   elevation: 0,
//                 ),
//                 onPressed: () async {
//                   bool success = await ref.read(securityProvider.notifier).verifyIdentity();
//                   if (success && context.mounted) {
//                     Navigator.pop(context); 
//                   }
//                 },
//                 icon: const Icon(Icons.fingerprint, color: whiteColor),
//                 label: Text(
//                   "Unlock App",
//                   style: AppTextStyles.whiteButtonTextStyle(context).copyWith(fontSize: 15.sp),
//                 ),
//               ),
//               height12,
//             ],
//           ),
//         );
//       },
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     final securityState = ref.watch(securityProvider);
//     final isUnlocked = securityState.isUnlocked;

//     // ➔ FIXED GATEWAY HOOK: Theme switches will no longer pass this check 
//     // because securityState.hasAttemptedAuth survives widget tree context redrawing safely!
//     if (!isUnlocked && !securityState.hasAttemptedAuth) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _executeSecurityGateChallenge();
//       });
//     }

//     ref.listen<AsyncValue<bool>>(userAccountStatusStreamProvider, (previous, next) {
//       next.whenData((isLinked) {
//         if (!isLinked && isUnlocked && mounted) {
//           showAddBankBottomSheet(context);
//         }
//       });
//     });

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: (Theme.of(context).brightness == Brightness.dark 
//           ? SystemUiOverlayStyle.light 
//           : SystemUiOverlayStyle.dark).copyWith(
//         statusBarColor: transparent,
//       ),
//       // Mask visibility behind an opacity fade and ignore pointer hits if currently locked
//       child: Opacity(
//         opacity: isUnlocked ? 1.0 : 0.15,
//         child: IgnorePointer(
//           ignoring: !isUnlocked,
//           child: Scaffold(
//             appBar: AppBar(
//               backgroundColor: transparent,
//               elevation: 0,
//               surfaceTintColor: transparent,
//               leading: Padding(
//                 padding: const EdgeInsets.only(left: 16.0),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => const MyQrProfileScreen()));
//                   },
//                   child: CircleAvatar(
//                     radius: 20.r,
//                     backgroundColor: themeColorLight,
//                     child: Text(
//                       "SG",
//                       style: GoogleFonts.inter(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w400,
//                         color: themeColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               actions: [
//                 Icon(
//                   Icons.search, 
//                   color: Theme.of(context).brightness == Brightness.dark ? whiteColor : themeColor, 
//                   size: 20.h,
//                 ),
//                 width8,
//                 Icon(
//                   Icons.notifications_outlined,
//                   color: Theme.of(context).brightness == Brightness.dark ? whiteColor : themeColor,
//                   size: 20.h,
//                 ),
//                 width8,
//                 IconButton(
//                   onPressed: () {
//                     ref.read(themeModeProvider.notifier).toggleTheme();
//                   },
//                   icon: Icon(
//                     ref.watch(themeModeProvider) == ThemeMode.light
//                         ? Icons.dark_mode_outlined
//                         : Icons.light_mode_outlined,
//                     color: Theme.of(context).brightness == Brightness.dark ? whiteColor : themeColor,
//                     size: 20.h,
//                   ),
//                 ),
//                 width12
//               ],
//             ),
//             body: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "UPI Money Transfer",
//                       style: AppTextStyles.headingBlackTextStyle(context).copyWith(
//                         fontSize: 14.sp,
//                       ),
//                     ),
//                     height12,
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         featureShortcuts(Icons.qr_code_scanner, "Scan\n Any QR", (){
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanScreen()));
//                         }, context),
//                         featureShortcuts(Icons.people_alt, "Pay\nAnyone", (){
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => const PayAnyoneScreen()));
//                         }, context),
//                         featureShortcuts(Icons.account_balance, "Bank\nTransfer", (){
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => const BankTransferScreen()));
//                         }, context),
//                         featureShortcuts(Icons.article, "Balance &\nHistory", (){
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
//                         }, context),
//                       ],
//                     ),
          
//                     height20,
//                     // ➔ DYNAMIC THEME FIX: Swapped hardcoded 'whiteColor' for Theme context rules
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).cardColor,
//                         borderRadius: BorderRadius.all(Radius.circular(12.r)),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 16,
//                           horizontal: 10,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Recharge & Bill Payments",
//                               style: AppTextStyles.headingBlackTextStyle(context).copyWith(
//                                 fontSize: 14.sp,
//                               ),
//                             ),
//                             height20,
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 rechargeBillShortcuts(
//                                   Icons.phone_android_outlined,
//                                   "Mobile\nRecharge",
//                                   () {
//                                     Navigator.push(context, MaterialPageRoute(builder: (context) => const MobileRechargeScreen()));
//                                   },
//                                   context
//                                 ),
//                                 rechargeBillShortcuts(Icons.tv, "DTH\nRecharge", () {}, context),
//                                 rechargeBillShortcuts(Icons.lightbulb_outline, "Electricity\nBill", () {}, context),
//                                 rechargeBillShortcuts(Icons.water_drop_outlined, "Water\nBill", () {}, context),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     height20,
//                     Container(
//                       height: 80.h,
//                       decoration: BoxDecoration(
//                         color: themeColorLight,
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Image.asset("assets/images/cashback.png", height: 60.h),
//                           Text(
//                             "Assured Cashback on your\nfirst transaction",
//                             style: AppTextStyles.headingBlackTextStyle(context).copyWith(
//                               fontSize: 14.sp,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     height20,
//                     // ➔ DYNAMIC THEME FIX: Swapped hardcoded 'whiteColor' for Theme context rules
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).cardColor,
//                         borderRadius: BorderRadius.all(Radius.circular(12.r)),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 16,
//                           horizontal: 10,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Travel & Tickets",
//                               style: AppTextStyles.headingBlackTextStyle(context).copyWith(
//                                 fontSize: 14.sp,
//                               ),
//                             ),
//                             height12,
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 rechargeBillShortcuts(Icons.flight_outlined, "Flight", () {}, context),
//                                 rechargeBillShortcuts(Icons.train_outlined, "Train", () {}, context),
//                                 rechargeBillShortcuts(Icons.directions_bus_outlined, "Bus", () {}, context),
//                                 rechargeBillShortcuts(Icons.domain_outlined, "Hotels", () {}, context),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     height20,
//                     // ➔ DYNAMIC THEME FIX: Swapped hardcoded 'whiteColor' for Theme context rules
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).cardColor,
//                         borderRadius: BorderRadius.all(Radius.circular(12.r)),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 16,
//                           horizontal: 10,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Financial Services",
//                               style: AppTextStyles.headingBlackTextStyle(context).copyWith(
//                                 fontSize: 14.sp,
//                               ),
//                             ),
//                             height12,
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 rechargeBillShortcuts(Icons.currency_rupee_outlined, "Loan", () {}, context),
//                                 rechargeBillShortcuts(Icons.directions_car_outlined, "Car\nInsurance", () {}, context),
//                                 rechargeBillShortcuts(Icons.monetization_on_outlined, "Save in\nGolds", () {}, context),
//                                 rechargeBillShortcuts(Icons.bar_chart_outlined, "Stocks", () {}, context),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     height90,
//                   ],
//                 ),
//               ),
//             ),
//             floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//             floatingActionButton: FloatingActionButton.extended(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanScreen()));
//               },
//               backgroundColor: themeColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.r),
//               ),
//               icon: Icon(Icons.qr_code_scanner, color: whiteColor),
//               label: Text(
//                 "Scan QR",
//                 style: AppTextStyles.whiteContentTextStyle(context).copyWith(
//                   fontSize: 12.sp,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// } 



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:payment_app/features/Add%20Bank/providers/bank_notifier.dart';
import 'package:payment_app/features/biometrics/security_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  // Single flag to prevent both sheets from showing simultaneously
  bool _bankSheetScheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final securityState = ref.read(securityProvider);
      if (!securityState.hasAttemptedAuth) {
        _executeSecurityGateChallenge();
      }
    });
  }

  Future<void> _executeSecurityGateChallenge() async {
    if (!mounted) return;

    bool isAuthSuccess =
        await ref.read(securityProvider.notifier).verifyIdentity();

    if (!isAuthSuccess && mounted) {
      //Show lock sheet only if biometric failed
      _showLockBottomSheetOverlay();
    } else if (isAuthSuccess && mounted) {
      // If biometric passed instantly (e.g. face ID),
      // trigger bank check right away after a short delay
      _checkAndShowAddBankSheet();
    }
  }

  //  shows add bank sheet only after unlock + delay
  Future<void> _checkAndShowAddBankSheet() async {
    if (_bankSheetScheduled || !mounted) return;
    _bankSheetScheduled = true;

    // Wait for biometric/lock sheet to fully close before showing next sheet
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final bankStatusAsync = ref.read(userAccountStatusStreamProvider);
    bankStatusAsync.whenData((isLinked) {
      if (!isLinked && mounted) {
        showAddBankBottomSheet(context);
      }
    });

    // Reset so it can show again if needed (e.g. user dismisses without linking)
    _bankSheetScheduled = false;
  }

  void _showLockBottomSheetOverlay() {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: lightBlueColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.security_rounded,
                  size: 40.sp,
                  color: themeColor,
                ),
              ),
              height16,
              Text(
                "Wallet App Locked",
                style: AppTextStyles.headingBlackTextStyle(context)
                    .copyWith(fontSize: 18.sp),
              ),
              height8,
              Text(
                "Identity verification is required to safely access account details and execute financial transactions.",
                textAlign: TextAlign.center,
                style: AppTextStyles.greyContentTextStyle(context)
                    .copyWith(fontSize: 12.sp, height: 1.4),
              ),
              height24,
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r)),
                  elevation: 0,
                ),
                onPressed: () async {
                  bool success = await ref
                      .read(securityProvider.notifier)
                      .verifyIdentity();
                  if (success && context.mounted) {
                    Navigator.pop(context);
                    _checkAndShowAddBankSheet();
                  }
                },
                icon: const Icon(Icons.fingerprint, color: whiteColor),
                label: Text(
                  "Unlock App",
                  style: AppTextStyles.whiteButtonTextStyle(context)
                      .copyWith(fontSize: 15.sp),
                ),
              ),
              height12,
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final securityState = ref.watch(securityProvider);
    final isUnlocked = securityState.isUnlocked;
    ref.listen<SecurityState>(securityProvider, (previous, next) {
      final justUnlocked =
          (previous?.isUnlocked == false) && next.isUnlocked;
      if (justUnlocked && mounted) {
        _checkAndShowAddBankSheet();
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (Theme.of(context).brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark)
          .copyWith(
        statusBarColor: transparent,
      ),
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.15,
        child: IgnorePointer(
          ignoring: !isUnlocked,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: transparent,
              elevation: 0,
              surfaceTintColor: transparent,
              leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MyQrProfileScreen()));
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
                Icon(
                  Icons.search,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? whiteColor
                      : themeColor,
                  size: 20.h,
                ),
                width8,
                Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? whiteColor
                      : themeColor,
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
                    color: Theme.of(context).brightness == Brightness.dark
                        ? whiteColor
                        : themeColor,
                    size: 20.h,
                  ),
                ),
                width12
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "UPI Money Transfer",
                      style: AppTextStyles.headingBlackTextStyle(context)
                          .copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                    height12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        featureShortcuts(
                            Icons.qr_code_scanner, "Scan\n Any QR", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ScanScreen()));
                        }, context),
                        featureShortcuts(Icons.people_alt, "Pay\nAnyone",
                            () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PayAnyoneScreen()));
                        }, context),
                        featureShortcuts(
                            Icons.account_balance, "Bank\nTransfer", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BankTransferScreen()));
                        }, context),
                        featureShortcuts(
                            Icons.article, "Balance &\nHistory", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HistoryScreen()));
                        }, context),
                      ],
                    ),
                    height20,
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                      ? bgColor
                      : whiteColor,
                        borderRadius:
                            BorderRadius.all(Radius.circular(12.r)),
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
                              style: AppTextStyles.headingBlackTextStyle(
                                      context)
                                  .copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                            height20,
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                rechargeBillShortcuts(
                                    Icons.phone_android_outlined,
                                    "Mobile\nRecharge", () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MobileRechargeScreen()));
                                }, context),
                                rechargeBillShortcuts(
                                    Icons.tv, "DTH\nRecharge", () {},
                                    context),
                                rechargeBillShortcuts(
                                    Icons.lightbulb_outline,
                                    "Electricity\nBill",
                                    () {},
                                    context),
                                rechargeBillShortcuts(
                                    Icons.water_drop_outlined,
                                    "Water\nBill",
                                    () {},
                                    context),
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
                          Image.asset("assets/images/cashback.png",
                              height: 60.h),
                          Text(
                            "Assured Cashback on your\nfirst transaction",
                            style: AppTextStyles.headingBlackTextStyle(
                                    context)
                                .copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    height20,
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                      ? bgColor
                      : whiteColor,
                        borderRadius:
                            BorderRadius.all(Radius.circular(12.r)),
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
                              style: AppTextStyles.headingBlackTextStyle(
                                      context)
                                  .copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                            height12,
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                rechargeBillShortcuts(
                                    Icons.flight_outlined, "Flight", () {},
                                    context),
                                rechargeBillShortcuts(
                                    Icons.train_outlined, "Train", () {},
                                    context),
                                rechargeBillShortcuts(
                                    Icons.directions_bus_outlined,
                                    "Bus",
                                    () {},
                                    context),
                                rechargeBillShortcuts(
                                    Icons.domain_outlined,
                                    "Hotels",
                                    () {},
                                    context),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    height20,
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                      ? bgColor
                      : whiteColor,
                        borderRadius:
                            BorderRadius.all(Radius.circular(12.r)),
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
                              style: AppTextStyles.headingBlackTextStyle(
                                      context)
                                  .copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                            height12,
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                rechargeBillShortcuts(
                                    Icons.currency_rupee_outlined,
                                    "Loan",
                                    () {},
                                    context),
                                rechargeBillShortcuts(
                                    Icons.directions_car_outlined,
                                    "Car\nInsurance",
                                    () {},
                                    context),
                                rechargeBillShortcuts(
                                    Icons.monetization_on_outlined,
                                    "Save in\nGolds",
                                    () {},
                                    context),
                                rechargeBillShortcuts(
                                    Icons.bar_chart_outlined,
                                    "Stocks",
                                    () {},
                                    context),
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScanScreen()));
              },
              backgroundColor: themeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              icon: Icon(Icons.qr_code_scanner, color: whiteColor),
              label: Text(
                "Scan QR",
                style: AppTextStyles.whiteContentTextStyle(context)
                    .copyWith(
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}