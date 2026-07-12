
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/core/theme/app_colors.dart';

class AppTextStyles {
  // Pull dynamic colors using BuildContext to support Theme variations smoothly
  static TextStyle headingThemeTextStyle(BuildContext context) => GoogleFonts.inter(
        fontWeight: FontWeight.w600, 
        color: themeColor,
      );

  static TextStyle headingBlackTextStyle(BuildContext context) => GoogleFonts.inter(
        fontWeight: FontWeight.w600, 
        color: blackColor,
      );

  static TextStyle blackContentTextStyle(BuildContext context) => GoogleFonts.inter(
        fontWeight: FontWeight.w400, 
        color: blackColor,
        height: 0.5,
      );

  static TextStyle greyContentTextStyle(BuildContext context) => GoogleFonts.inter(
        fontWeight: FontWeight.w400, 
        color: greyColor,
      );

  static TextStyle whiteContentTextStyle(BuildContext context) => GoogleFonts.inter(
        fontWeight: FontWeight.w400, 
        color: whiteColor,
      );

  static TextStyle blackDescriptionTextStyle(BuildContext context) => GoogleFonts.inter(
        fontWeight: FontWeight.w400, 
        color: blackColor,
      );

  static TextStyle errorTextStyle(BuildContext context) => GoogleFonts.inter(
        fontWeight: FontWeight.w400, 
        color: redColor,
      );

  static TextStyle whiteButtonTextStyle(BuildContext context) => GoogleFonts.inter(
        fontWeight: FontWeight.w600, 
        color: whiteColor,
      );
}