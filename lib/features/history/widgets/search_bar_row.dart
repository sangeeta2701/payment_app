import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';

class SearchBarRow extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged; 

  const SearchBarRow({
    super.key, 
    this.onSearchChanged, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: greyColor.withOpacity(0.3)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.black54, size: 18.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextField(
                      onChanged: onSearchChanged, 
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(color: greyColor, fontSize: 12.sp),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.tune, color: Colors.black87, size: 18.sp),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF5F4F9),
              padding: EdgeInsets.all(12.w),
            ),
          )
        ],
      ),
    );
  }
}