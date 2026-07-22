
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:screen_protector/screen_protector.dart'; 

import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Pin/widgest/pin_dots_indicator.dart';
import 'package:payment_app/features/Pin/widgest/pin_keypad.dart';
import 'package:payment_app/features/Transactions/providers/transaction_notifier.dart'; 
import 'package:payment_app/features/Transactions/screen/transaction_details_screen.dart';

enum PinPurpose { payment, checkBalance }

class EnterPinScreen extends ConsumerStatefulWidget {
  final PinPurpose purpose;

  // Payment Mode Fields
  final String? userName;
  final double? amountToPay;
  final String? upiId;

  // Check Balance Mode Fields
  final String? bankName;
  final String? accountNumber;

  const EnterPinScreen({
    super.key,
    this.purpose = PinPurpose.payment,
    this.userName,
    this.amountToPay,
    this.upiId,
    this.bankName,
    this.accountNumber,
  });

  @override
  ConsumerState<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends ConsumerState<EnterPinScreen> {
  String _currentPin = "";
  final int _maxPinLength = 6;
  bool _isProcessing = false;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _enableScreenProtection();
  }

  @override
  void dispose() {
    _disableScreenProtection();
    super.dispose();
  }

  Future<void> _enableScreenProtection() async {
    await ScreenProtector.preventScreenshotOn();
    await ScreenProtector.protectDataLeakageOn();
  }

  Future<void> _disableScreenProtection() async {
    await ScreenProtector.preventScreenshotOff();
    await ScreenProtector.protectDataLeakageOff();
  }

  void _handleKeyPress(String value) {
    if (_isProcessing) return;
    
    setState(() {
      _localError = null;
      if (value == "back") {
        if (_currentPin.isNotEmpty) {
          _currentPin = _currentPin.substring(0, _currentPin.length - 1);
        }
      } else {
        if (_currentPin.length < _maxPinLength) {
          _currentPin += value;
          if (_currentPin.length == _maxPinLength) {
            _onPinComplete();
          }
        }
      }
    });
  }

  void _onPinComplete() {
    if (widget.purpose == PinPurpose.checkBalance) {
      // Return PIN back to caller instead of executing payment pipeline
      Navigator.pop(context, _currentPin);
    } else {
      _submitPaymentPipeline();
    }
  }

  void _submitPaymentPipeline() async {
    setState(() {
      _isProcessing = true;
      _localError = null;
    });

    bool success = await ref.read(transactionProvider.notifier).processDirectWalletPayment(
          receiverName: widget.userName ?? "",
          amount: widget.amountToPay ?? 0.0,
          upiId: widget.upiId ?? "",
          enteredPin: _currentPin,
        );

    if (!mounted) return;

    final txState = ref.read(transactionProvider);

    if (success && txState.transactionId != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionDetailsScreen(
            transactionId: txState.transactionId!,
            receiverName: widget.userName ?? "",
            amount: widget.amountToPay ?? 0.0,
          ),
        ),
        (route) => route.isFirst,
      );
    } else {
      setState(() {
        _isProcessing = false;
        _currentPin = "";
        _localError = txState.errorMessage ?? "Transaction failed. Please check your PIN.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat("#,##,###.00");
    final isBalanceCheck = widget.purpose == PinPurpose.checkBalance;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "ENTER 6-DIGIT UPI PIN",
          style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 14.sp, letterSpacing: 0.5),
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
                  
                  if (isBalanceCheck) ...[
                    Text(
                      widget.bankName ?? "Bank Account",
                      style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                    height4,
                    Text(
                      "A/c No: XX${widget.accountNumber ?? ''}",
                      style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 13.sp),
                    ),
                  ] else ...[
                    Text("Sending money to", style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 13.sp)),
                    height4,
                    Text(widget.userName ?? "", style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 18.sp)),
                    height16,
                    Text(
                      "₹${currencyFormatter.format(widget.amountToPay ?? 0.0)}",
                      style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 36.sp, fontWeight: FontWeight.bold),
                    ),
                  ],

                  height60,
                  Text("ENTER UPI PIN", style: AppTextStyles.headingThemeTextStyle(context).copyWith(fontSize: 12.sp, letterSpacing: 1.0)),
                  height20,
                  
                  PinDotsIndicator(pinLength: _currentPin.length),
                  
                  if (_localError != null) ...[
                    height30,
                    Text(
                      _localError!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.errorTextStyle(context).copyWith(fontSize: 13.sp, fontWeight: FontWeight.w500),
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
          PinKeypad(onKeyTap: _handleKeyPress),
        ],
      ),
    );
  }
}