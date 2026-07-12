import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Pay%20Anyone/screens/pay_anyone_screen.dart';

// Modular Child Imports
import '../widgets/transfer_option_card.dart';
import '../widgets/self_transfer_section.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/beneficiary_tile.dart';

class BankTransferScreen extends StatelessWidget {
  const BankTransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fallback constants if app_colors/text_stylies don't have them explicitly

    return Scaffold(
      // backgroundColor: bgColor,
      appBar: AppBar(
        // backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Bank Transfers",
          style: AppTextStyles.blackContentTextStyle(context).copyWith(
            fontSize: 22.sp, 
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Section 1: Core Action Cards ---
              Card(
                elevation: 0,
                color: whiteColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                child: TransferOptionCard(
                      icon: Icons.account_balance_outlined,
                      iconBgColor: const Color(0xFFE8F2FF),
                      iconColor: const Color(0xFF1A6CE8),
                      title: "Transfer to Account",
                      subtitle: "Send money to any Bank instantly",
                      onTap: () {
                        // Navigate to your previous BankTransferForm screen here!
                      },
                    ),
              ),
              SizedBox(height: 12.h),
              Card(
                elevation: 0,
                color: whiteColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                child: TransferOptionCard(
                      icon: Icons.qr_code_scanner, // Custom or generic UPI vector indicator
                      iconBgColor: const Color(0xFFEBF7FF),
                      iconColor: lightBlueColor,
                      title: "Transfer to UPI ID",
                      subtitle: "Send money to Gpay, Phonepe, Bhim or any UPI app",
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const PayAnyoneScreen()));
                      },
                    ),
              ),
              SizedBox(height: 16.h),

              // --- Section 2: Self Transfer Segment ---
              const SelfTransferSection(),
              SizedBox(height: 20.h),

              // --- Section 3: Recents & Saved Beneficiaries ---
              Text(
                "Recents & Saved Beneficiaries",
                style: AppTextStyles.blackContentTextStyle(context).copyWith(
                  fontSize: 15.sp, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Use a deep dark color
                ),
              ),
              
              SizedBox(height: 12.h),
              const SearchBarWidget(),
              SizedBox(height: 16.h),

              // Sample Beneficiary List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 1, // Expand dynamically as per database data
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  return BeneficiaryTile(
                    name: "Hrishitha",
                    emojis: "😉😎",
                    dateStr: "Feb 10",
                    phoneNumber: "+91 7276096809",
                    statusMessage: "65 Received on 10 Jun",
                    avatarColor: const Color(0xFFEAE2FF),
                    onTap: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}