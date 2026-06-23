// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:payment_app/core/theme/app_colors.dart';
// import 'package:payment_app/core/theme/text_stylies.dart';
// import 'package:payment_app/features/home/screens/home_screen.dart';

// class OtpScreen extends StatefulWidget {
//   final String phoneNumber;
//   final String verificationId; // Verification ID passed from LoginScreen

//   const OtpScreen({
//     super.key,
//     required this.phoneNumber,
//     required this.verificationId,
//   });

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
//   final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  
//   int _secondsRemaining = 30;
//   Timer? _timer;
//   bool _canResend = false;
//   bool _isVerifying = false;

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var node in _focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }

//   void _startTimer() {
//     setState(() {
//       _secondsRemaining = 30;
//       _canResend = false;
//     });
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_secondsRemaining == 0) {
//         setState(() {
//           _canResend = true;
//           _timer?.cancel();
//         });
//       } else {
//         setState(() {
//           _secondsRemaining--;
//         });
//       }
//     });
//   }

//   void _verifyOtp() async {
//     String otpCode = _controllers.map((controller) => controller.text.trim()).join();
    
//     if (otpCode.length == 4) {
//       setState(() => _isVerifying = true);
      
//       try {
//         // Create an explicit Phone Auth credential using the verified configuration token
//         PhoneAuthCredential credential = PhoneAuthProvider.credential(
//           verificationId: widget.verificationId,
//           smsCode: otpCode,
//         );

//         // Sign the user in with the generated credential token framework
//         await FirebaseAuth.instance.signInWithCredential(credential);

//         if (!mounted) return;
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text("Verification Successful!"),
//             backgroundColor: const Color(0xFF00B15E), 
//             duration: const Duration(seconds: 2),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
//           ),
//         );

//         // Secure wipe routing migration layout clearing state memory
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//           (route) => false, 
//         );
//       } on FirebaseAuthException catch (e) {
//         setState(() => _isVerifying = false);
//         _showNotificationSnackBar(e.message ?? "Invalid OTP entered. Please re-verify.");
//       } catch (e) {
//         setState(() => _isVerifying = false);
//         _showNotificationSnackBar("An error occurred during verification. Try again.");
//       }
//     } else {
//       _showNotificationSnackBar("Please enter a valid 4-digit OTP code");
//     }
//   }

//   void _showNotificationSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.redAccent,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         backgroundColor: transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: themeColor),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Verify Mobile Number",
//                     style: AppTextStyles.headingBlackTextStyle.copyWith(
//                       fontSize: 22.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   Text(
//                     "Enter the 4-digit code sent to +91 ${widget.phoneNumber}",
//                     style: AppTextStyles.blackContentTextStyle.copyWith(
//                       color: Colors.grey.shade600,
//                       fontSize: 13.sp,
//                     ),
//                   ),
//                   SizedBox(height: 32.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: List.generate(4, (index) {
//                       return SizedBox(
//                         width: 56.w,
//                         height: 56.h,
//                         child: TextFormField(
//                           controller: _controllers[index],
//                           focusNode: _focusNodes[index],
//                           keyboardType: TextInputType.number,
//                           textAlign: TextAlign.center,
//                           style: AppTextStyles.headingBlackTextStyle.copyWith(
//                             fontSize: 20.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           inputFormatters: [
//                             FilteringTextInputFormatter.digitsOnly,
//                             LengthLimitingTextInputFormatter(1),
//                           ],
//                           decoration: InputDecoration(
//                             fillColor: whiteColor,
//                             filled: true,
//                             contentPadding: EdgeInsets.zero,
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12.r),
//                               borderSide: BorderSide(color: Colors.grey.shade300),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12.r),
//                               borderSide: BorderSide(color: themeColor, width: 2),
//                             ),
//                           ),
//                           onChanged: (value) {
//                             if (value.isNotEmpty && index < 3) {
//                               _focusNodes[index + 1].requestFocus();
//                             }
//                             if (value.isEmpty && index > 0) {
//                               _focusNodes[index - 1].requestFocus();
//                             }
//                             if (index == 3 && value.isNotEmpty) {
//                               _focusNodes[index].unfocus();
//                             }
//                           },
//                         ),
//                       );
//                     }),
//                   ),
//                   SizedBox(height: 24.h),
//                   Center(
//                     child: _canResend
//                         ? TextButton(
//                             onPressed: _startTimer,
//                             child: Text(
//                               "Resend OTP",
//                               style: AppTextStyles.blackContentTextStyle.copyWith(
//                                 color: themeColor,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13.sp,
//                               ),
//                             ),
//                           )
//                         : Text(
//                             "Resend OTP in 0:$_secondsRemaining",
//                             style: AppTextStyles.blackContentTextStyle.copyWith(
//                               color: Colors.grey.shade500,
//                               fontSize: 13.sp,
//                             ),
//                           ),
//                   ),
//                   const Spacer(),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 48.h,
//                     child: ElevatedButton(
//                       onPressed: _isVerifying ? null : _verifyOtp,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: themeColor,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
//                         elevation: 0,
//                       ),
//                       child: Text(
//                         "Verify & Proceed",
//                         style: AppTextStyles.whiteContentTextStyle.copyWith(
//                           fontSize: 15.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (_isVerifying)
//               const Center(
//                 child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F0C21))),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// } 




import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/home/screens/home_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // ✅ Changed from 4 to 6
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _secondsRemaining = 30;
  Timer? _timer;
  bool _canResend = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 30;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
          _timer?.cancel();
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  Future<void> _createUserProfileInFirestore(User user) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    final docSnapshot = await userDocRef.get();

    if (!docSnapshot.exists) {
      await userDocRef.set({
        'uid': user.uid,
        'phoneNumber': widget.phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'displayName': '',
        'upiId': '${widget.phoneNumber}@payapp',
        'walletBalance': 0.0,
      });
    }
  }

  void _verifyOtp() async {
    String otpCode =
        _controllers.map((controller) => controller.text.trim()).join();

    // ✅ Changed length check from 4 to 6
    if (otpCode.length == 6) {
      setState(() => _isVerifying = true);

      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId,
          smsCode: otpCode,
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          await _createUserProfileInFirestore(userCredential.user!);
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Verification Successful!"),
            backgroundColor: const Color(0xFF00B15E),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r)),
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        setState(() => _isVerifying = false);
        _showNotificationSnackBar(
            e.message ?? "Invalid OTP entered. Please re-verify.");
      } catch (e) {
        setState(() => _isVerifying = false);
        _showNotificationSnackBar(
            "An error occurred during verification. Try again.");
      }
    } else {
      // ✅ Updated error message to say 6-digit
      _showNotificationSnackBar("Please enter a valid 6-digit OTP code");
    }
  }

  void _showNotificationSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
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
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Verify Mobile Number",
                    style: AppTextStyles.headingBlackTextStyle.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Enter the 6-digit code sent to +91 ${widget.phoneNumber}",
                    style: AppTextStyles.blackContentTextStyle.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 44.w,
                        height: 52.h,
                        child: TextFormField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style:
                              AppTextStyles.headingBlackTextStyle.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          decoration: InputDecoration(
                            fillColor: whiteColor,
                            filled: true,
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide:
                                  BorderSide(color: themeColor, width: 2),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              // ✅ Updated max index from 3 to 5
                              _focusNodes[index + 1].requestFocus();
                            }
                            if (value.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                            if (index == 5 && value.isNotEmpty) {
                              // ✅ Updated last index from 3 to 5
                              _focusNodes[index].unfocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: 24.h),
                  Center(
                    child: _canResend
                        ? TextButton(
                            onPressed: _startTimer,
                            child: Text(
                              "Resend OTP",
                              style:
                                  AppTextStyles.blackContentTextStyle.copyWith(
                                color: themeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                            ),
                          )
                        : Text(
                            "Resend OTP in 0:${_secondsRemaining.toString().padLeft(2, '0')}",
                            style:
                                AppTextStyles.blackContentTextStyle.copyWith(
                              color: Colors.grey.shade500,
                              fontSize: 13.sp,
                            ),
                          ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: _isVerifying ? null : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Verify & Proceed",
                        style: AppTextStyles.whiteContentTextStyle.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isVerifying)
              const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF0F0C21))),
              ),
          ],
        ),
      ),
    );
  }
}