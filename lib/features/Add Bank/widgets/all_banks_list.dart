import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Add%20Bank/models/bankModel.dart';


class AllBanksList extends StatelessWidget {
  final List<BankModel> banksList;
  final Function(BankModel) onBankSelected;

  const AllBanksList({
    super.key,
    required this.banksList,
    required this.onBankSelected,
  });

  @ override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(24.r)),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "All Banks",
              style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 13.sp),
            ),
          ),
          SizedBox(height: 8.h),
          if (banksList.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: const Center(child: Text("No banks match your search")),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: banksList.length,
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: 64.w),
                child: Divider(color: Colors.grey.shade100, height: 1),
              ),
              itemBuilder: (context, index) {
                final bank = banksList[index];
                return ListTile(
                  onTap: () => onBankSelected(bank),
                  leading: CircleAvatar(
                    radius: 18.r,
                    backgroundColor: const Color(0xFFF1F5F9),
                    child: bank.assetPath != null
                        ? Image.asset(bank.assetPath!, width: 20.w)
                        : Icon(bank.fallbackIcon, color: lightBlueColor, size: 18.sp),
                  ),
                  title: Text(
                    bank.name,
                    style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 11.sp),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}