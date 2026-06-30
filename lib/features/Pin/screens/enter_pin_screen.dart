import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Pin/widgest/pin_dots_indicator.dart';
import 'package:payment_app/features/Pin/widgest/pin_keypad.dart';


class EnterPinScreen extends StatefulWidget {
  final String userName;
  final double amountToPay;

  const EnterPinScreen({
    super.key,
    required this.userName,
    required this.amountToPay,
  });

  @override
  State<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends State<EnterPinScreen> {
  String _currentPin = "";
  final int _maxPinLength = 6;
  bool _isProcessing = false;
  String? _localError;

  void _handleKeyPress(String value) {
    if (_isProcessing) return;
    
    setState(() {
      _localError = null; // Clear error on key tap
      if (value == "back") {
        if (_currentPin.isNotEmpty) {
          _currentPin = _currentPin.substring(0, _currentPin.length - 1);
        }
      } else {
        if (_currentPin.length < _maxPinLength) {
          _currentPin += value;
          
          // Trigger execution pipeline immediately upon entry completion
          if (_currentPin.length == _maxPinLength) {
            _submitPaymentPipeline();
          }
        }
      }
    });
  }

  void _submitPaymentPipeline() async {
    setState(() => _isProcessing = true);

    try {
      // Mock validation verification check
      if (_currentPin == "123456") { 
        // ➔ SUCCESS: Execute Firestore transaction insert mutation here
        // await PaymentService.executeSecureTransaction(...);
        
        if (!mounted) return;
        Navigator.pop(context); // Clear back stack
      } else {
        // FAILURE state error handling
        setState(() {
          _currentPin = "";
          _isProcessing = false;
          _localError = "Incorrect UPI PIN entered. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _localError = "Transaction failed due to an unexpected connection issue.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat("#,##,###.00");

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "ENTER 6-DIGIT UPI PIN",
          style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 14.sp, letterSpacing: 0.5),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  height30,
                  // Dynamic Recipient metadata context block
                  Text(
                    "Sending money to",
                    style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 13.sp),
                  ),
                  height4,
                  Text(
                    widget.userName,
                    style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 18.sp),
                  ),
                  height16,
                  // Transformed Dynamic Amount Context Header
                  Text(
                    "₹${currencyFormatter.format(widget.amountToPay)}",
                    style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 36.sp, fontWeight: FontWeight.bold),
                  ),
                  height60,

                  // Static Info Context Messaging Panel
                  Text(
                    "ENTER UPI PIN",
                    style: AppTextStyles.headingThemeTextStyle.copyWith(fontSize: 12.sp, letterSpacing: 1.0),
                  ),
                  height20,
                  
                  // Obfuscated filled indicator layer widget
                  PinDotsIndicator(pinLength: _currentPin.length),
                  
                  if (_localError != null) ...[
                    height30,
                    Text(
                      _localError!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.errorTextStyle.copyWith(fontSize: 13.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                  
                  if (_isProcessing) ...[
                    height30,
                    const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
                  ]
                ],
              ),
            ),
          ),
          
          // Bottom Grid Entry Layout Layer
          PinKeypad(onKeyTap: _handleKeyPress),
        ],
      ),
    );
  }
}