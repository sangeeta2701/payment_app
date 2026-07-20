
//updated one with dynamic data
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/core/utils/app_snackbar.dart';
import 'package:payment_app/features/Split%20Payment/model/split_models.dart';
import 'package:payment_app/features/Split%20Payment/repository/split_repository.dart';

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
    final int totalPeopleCount = members.length + 1;
    final double splitShare = totalAmount / totalPeopleCount;
    final SplitRepository splitRepository = SplitRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Confirm Split",
          style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text("Total Amount", style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 12.sp, height: 1.5)),
                Text("₹ ${totalAmount.toStringAsFixed(2)}", style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 20.sp, height: 1.5, fontWeight: FontWeight.bold)),
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
              onPressed: () async {
                try {
                  // Construct a payload object containing metadata for the new transaction group
                  final dynamicGroup = SplitGroupModel(
                    id: DateTime.now().microsecondsSinceEpoch.toString(), // Generates a unique document reference key ID string
                    groupName: groupName,
                    members: members,
                    totalExpense: totalAmount,
                    paidById: paidBy,
                    isSettled: false,
                    createdAt: DateTime.now(),
                  );

                  // Async write to Cloud Firestore
                  await splitRepository.saveNewSplitGroup(dynamicGroup);

                  if (context.mounted) {
                    
                    AppSnackbar.show(
                      context,
                      "Group '$groupName' split confirmed & saved successfully!",
                    );
                    // Returns to the primary home view, triggering an automatic refresh through the active stream pipe channel
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                } catch (e) {
                  if (context.mounted) {
                     
                    AppSnackbar.show(
                      context,
                      "Failed to save split data. Details: $e",
                    );
                  }
                }
              },
              child: Text("Confirm to Split", style: AppTextStyles.whiteButtonTextStyle(context).copyWith(fontSize: 15.sp)),
            ),
          ),
          height30,
        ],
      ),
    );
  }
}