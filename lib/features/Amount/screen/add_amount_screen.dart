import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Pin/screens/enter_pin_screen.dart';

class AddAmountScreen extends StatefulWidget {
  final bool isFromQR;
  final String userName;
  final String upiId;
  final String? bankingName;
  const AddAmountScreen({
    super.key,
    required this.isFromQR,
    required this.userName,
    required this.upiId,
    this.bankingName,
  });

  @override
  State<AddAmountScreen> createState() => _AddAmountScreenState();
}

class _AddAmountScreenState extends State<AddAmountScreen> {
  final TextEditingController _amountController = TextEditingController(text: '0');
  final TextEditingController _messageController = TextEditingController();
  String amount = '0';
  final double qrLimit = 2000.00;
  final double upiLimit = 10000.00;

  @override
  void dispose() {
    _amountController.dispose();
    _messageController.dispose();
  } 

  @override
  void initState() {
    // TODO: implement initState
    _amountController.addListener((){
      setState(() {
        
      });
    });
  }

  void _onKeyTap(String value) {
    setState(() {
      if (value == "back") {
        if (amount.length > 1) {
          amount = amount.substring(0, amount.length - 1);
        } else {
          amount = "0";
        }
      } else if (value == ".") {
        if (!amount.contains(".")) {
          amount += ".";
        }
      } else {
        if (amount == "0") {
          amount = value;
        } else {
          // Limit length to avoid overflow
          if (amount.replaceFirst('.', '').length < 7) {
            amount += value;
          }
        }
      }
    });
  }

  String _getFormattedAmount() {
    if (amount == "0") return "0";
    final formatter = NumberFormat("#,##,###.##");
    return formatter.format(double.parse(amount));
  }

  String? _getValidationError() {
    double currentAmount = double.tryParse(amount) ?? 0;
    if (currentAmount == 0) return null;

    if (widget.isFromQR && currentAmount > qrLimit) {
      return "You can pay up to Rs. $qrLimit for QRs selected from your photo gallery as per UPI guidelines. Please enter a lower amount to proceed.";
    } else if (!widget.isFromQR && currentAmount > upiLimit) {
      return "You can only send up to Rs. $upiLimit at a time by UPI. Please enter a lower amount.";
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    String? validationError = _getValidationError();
    bool isButtonDisabled = amount == "0" || validationError != null;
    return Scaffold(
    backgroundColor: bgColor,
    // Use an AppBar for the back button so it doesn't overlap content
    appBar: AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: Column(
      children: [
        //***************TOP SECTION (Profile & Details)
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: themeColorLight,
                  child: Text(
                    widget.userName.isNotEmpty ? widget.userName[0] : "?",
                    style: GoogleFonts.inter(fontSize: 24.sp, color: themeColor),
                  ),
                ),
                height16,
                Text(
                  widget.userName,
                  style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 20.sp),
                ),
                if (!widget.isFromQR && widget.bankingName != null) ...[
                  height4,
                  Text("Banking name: ${widget.bankingName}", 
                    style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 14.sp)),
                ],
                height4,
                Text(widget.upiId, style: AppTextStyles.blackContentTextStyle),
                
                SizedBox(height: 50.h),

                //*********************AMOUNT DISPLAY
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, right: 4.w),
                      child: Text("₹", 
                        style: GoogleFonts.inter(fontSize: 30.sp, fontWeight: FontWeight.w400)),
                    ),
                    Text(
                      _getFormattedAmount(),
                      style: GoogleFonts.inter(
                        fontSize: 65.sp, 
                        fontWeight: FontWeight.w600,
                        color: validationError != null ? Colors.grey : Colors.black
                      ),
                    ),
                    

                    
                  ],
                ),
                
                //********************Validation Message
                if (validationError != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
                    child: Text(
                      validationError,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.errorTextStyle.copyWith(fontSize: 12.sp),
                    ),
                  ),

                height20,
                // Add Message
                IntrinsicWidth( 
                    child: Container(
                      constraints: BoxConstraints(minWidth: 120.w, maxWidth: 300.w),
                      child: TextFormField(
                        controller: _messageController,
                        keyboardType: TextInputType.text, // Opens normal keyboard
                        textAlign: TextAlign.center,
                        style: AppTextStyles.blackContentTextStyle,
                        decoration: InputDecoration(
                          hintText: "Add message +",
                          hintStyle: AppTextStyles.greyContentTextStyle,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ),
                  ),
                  height16
              ],
            ),
          ),
        ),

        // *****************BOTTOM SECTION (Button & Keypad)
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: isButtonDisabled ? null : () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
                  ),
                  child: Text("Proceed Securely", 
                    style: AppTextStyles.whiteButtonTextStyle.copyWith(fontSize: 16.sp),),
                ),
              ),
            ),
            height16,
            _buildNumericKeypad(),
          ],
        ),
      ],
    ),
  );
  }

  Widget _buildNumericKeypad() {
    return Container(
      color: Colors.grey.shade100,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        children: [
          _buildKeypadRow(["1", "2", "3"]),
          _buildKeypadRow(["4", "5", "6"]),
          _buildKeypadRow(["7", "8", "9"]),
          _buildKeypadRow(["+", ".", "0", "back"]),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      children: keys.map((key) {
        return Expanded(
          child: InkWell(
            onTap: () => _onKeyTap(key),
            child: Container(
              height: 60.h,
              alignment: Alignment.center,
              child: key == "back"
                  ? const Icon(Icons.backspace_outlined)
                  : Text(key, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w400)),
            ),
          ),
        );
      }).toList(),
    );
  }
}
