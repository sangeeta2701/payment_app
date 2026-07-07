import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Add%20Bank/models/bankModel.dart';

class PopularBanksGrid extends StatelessWidget {
  final List<BankModel> popularBanks;
  final Function(BankModel) onBankSelected;

  const PopularBanksGrid({
    super.key,
    required this.popularBanks,
    required this.onBankSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.all(14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Popular Banks",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F1F1F),
            ),
          ),
          SizedBox(height: 12.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: popularBanks.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 14.h,
              crossAxisSpacing: 10.w,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final bank = popularBanks[index];
              return InkWell(
                onTap: () => onBankSelected(bank),
                child: Column(
                  children: [
                    // Inside your ListTile/Grid view item builders:
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: const Color(0xFFF1F5F9),
                      child: bank.assetPath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                bank.assetPath!,
                                width: 24.w,
                                height: 24.h,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.account_balance,
                                      size: 18.sp,
                                      color: lightBlueColor,
                                    ),
                              ),
                            )
                          : Icon(
                              Icons.account_balance,
                              color: lightBlueColor,
                              size: 18.sp,
                            ),
                    ),
                    height8,
                    Text(
                      bank.name,
                      textAlign: TextAlign.center,
                      // maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.blackContentTextStyle.copyWith(
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
