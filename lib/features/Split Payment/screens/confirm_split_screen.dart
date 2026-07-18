import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Split%20Payment/model/split_models.dart';

class ConfirmSplitScreen extends StatelessWidget {
  final String groupName;
  final List<UserModel> members;
  final double totalAmount;
  final String paidBy;

  const ConfirmSplitScreen({
    Key? key,
    required this.groupName,
    required this.members,
    required this.totalAmount,
    required this.paidBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Math Logic: Split equally including "You"
    final int totalPeopleCount = members.length + 1;
    final double splitShare = totalAmount / totalPeopleCount;

    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Split")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text("Total Amount", style: TextStyle(color: greyColor)),
                Text("₹ ${totalAmount.toStringAsFixed(2)}", style:  AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 20.sp)),
                Text("Paid by $paidBy", style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 12.sp)),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$totalPeopleCount Selected", style: AppTextStyles.blackContentTextStyle(context).copyWith(fontSize: 14.sp)),
                Text("Split Equally", style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 12.sp)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.orange, child: Text("Y")),
                  title: const Text("You"),
                  trailing: Text("₹ ${splitShare.toStringAsFixed(2)}", style: AppTextStyles.blackContentTextStyle(context).copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                ),
                ...members.map((member) => ListTile(
                  leading: CircleAvatar(child: Text(member.name[0])),
                  title: Text(member.name),
                  trailing: Text("₹ ${splitShare.toStringAsFixed(2)}", style: AppTextStyles.blackContentTextStyle(context).copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                )).toList(),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: themeColor, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Group '$groupName' split confirmed & notifications dispatched!")),
                );

                // Clear the stack back out to the home dashboard securely
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child:  Text("Confirm to Split", style: AppTextStyles.whiteButtonTextStyle(context).copyWith(fontSize: 15.sp)),
            ),
          )
        ],
      ),
    );
  }
}