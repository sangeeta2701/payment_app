import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Auth/screens/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // State variables for managing loading animations smoothly
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // Helper method to display clean, stylized errors matching your theme
  void _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          style: AppTextStyles.whiteContentTextStyle(context).copyWith(fontSize: 13.sp),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  // Handles the async network verification handshake with Firebase
  void _submitPhoneNumber() async {
    if (!_formKey.currentState!.validate()) return;

    // Turn on the loading indicator overlay
    setState(() => _isLoading = true);
    final String formattedPhone = "+91${_phoneController.text.trim()}";

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        timeout: const Duration(seconds: 30),
        
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Instant Android automatic SMS code retrieval callback handler
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        
        verificationFailed: (FirebaseAuthException e) {
          setState(() => _isLoading = false);
          _showErrorSnackBar(e.message ?? "Authentication failed. Try again.");
        },
        
        codeSent: (String verificationId, int? resendToken) {
          // Turn off loading animation right before we transition away
          setState(() => _isLoading = false);
          
          // Secure route migration carrying token references downstream
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                phoneNumber: _phoneController.text.trim(),
                verificationId: verificationId, // Handing off the key!
              ),
            ),
          );
        },
        
        codeAutoRetrievalTimeout: (String verificationId) {
          if (mounted) setState(() => _isLoading = false);
        },
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar("An unexpected error occurred. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Layer 1: Main Interactive Form Layout UI
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter your mobile number",
                      style: AppTextStyles.headingBlackTextStyle(context).copyWith(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "We'll send a 4-digit OTP to verify your account",
                      style: AppTextStyles.blackContentTextStyle(context).copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    
                    // Input Card Box Layout
                    Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                      child: Row(
                        children: [
                          Text(
                            "+91",
                            style: AppTextStyles.blackContentTextStyle(context).copyWith(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(width: 1, height: 24.h, color: Colors.grey.shade300),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: AppTextStyles.blackContentTextStyle(context).copyWith(fontSize: 15.sp),
                              enabled: !_isLoading, // Disable editing text field while executing network calls
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              decoration: InputDecoration(
                                hintText: "00000 00000",
                                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15.sp),
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your mobile number.";
                                }
                                if (value.length < 10) {
                                  return "Enter a valid 10-digit mobile number.";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    
                    // Proceed Launcher Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitPhoneNumber,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                          elevation: 0,
                        ),
                        child: Text(
                          "Get OTP",
                          style: AppTextStyles.whiteContentTextStyle(context).copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Layer 2: Safety Modal Spinner Shield preventing duplicate submit clicks
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.05),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F0C21)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}