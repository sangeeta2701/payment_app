import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Split%20Payment/model/split_models.dart';
import 'package:payment_app/features/Split%20Payment/screens/confirm_split_screen.dart';

class EnterAmountScreen extends StatefulWidget {
  final String groupName;
  final List<UserModel> members;
  const EnterAmountScreen({
    Key? key,
    required this.groupName,
    required this.members,
  }) : super(key: key);

  @override
  State<EnterAmountScreen> createState() => _EnterAmountScreenState();
}

class _EnterAmountScreenState extends State<EnterAmountScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedPaidBy = "You";
  bool _isProceedActive = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      final val = double.tryParse(_amountController.text) ?? 0.0;
      setState(() {
        _isProceedActive = val > 0;
      });
    });
  }

  void _showPaidByBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Paid by",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: const CircleAvatar(child: Text("Y")),
                title: const Text("You"),
                trailing: _selectedPaidBy == "You"
                    ? const Icon(Icons.check, color: successColor)
                    : null,
                onTap: () {
                  setState(() => _selectedPaidBy = "You");
                  Navigator.pop(context);
                },
              ),
              ...widget.members
                  .map(
                    (member) => ListTile(
                      leading: CircleAvatar(child: Text(member.name[0])),
                      title: Text(member.name),
                      trailing: _selectedPaidBy == member.name
                          ? const Icon(Icons.check, color: successColor)
                          : null,
                      onTap: () {
                        setState(() => _selectedPaidBy = member.name);
                        Navigator.pop(context);
                      },
                    ),
                  )
                  .toList(),

                  height30,
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Split expense with ${widget.groupName}",style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             Text("Total Amount", style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 12.sp)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  "₹ ",
                  style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 32, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "0",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Paid by "),
                ActionChip(
                  label: Text(_selectedPaidBy),
                  onPressed: _showPaidByBottomSheet,
                  avatar: const CircleAvatar(radius: 10, child: Text("P")),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isProceedActive
                      ? themeColor
                      : greyColor[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                ),
                onPressed: _isProceedActive
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmSplitScreen(
                              groupName: widget.groupName,
                              members: widget.members,
                              totalAmount: double.parse(_amountController.text),
                              paidBy: _selectedPaidBy,
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  "PROCEED",
                  style: TextStyle(color: whiteColor),
                ),
              ),
            ),
            height30,
          ],
        ),
      ),
    );
  }
}
