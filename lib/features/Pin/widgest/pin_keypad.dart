import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';

class PinKeypad extends StatelessWidget {
  final Function(String) onKeyTap;

  const PinKeypad({super.key, required this.onKeyTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        children: [
          _buildRow(["1", "2", "3"]),
          _buildRow(["4", "5", "6"]),
          _buildRow(["7", "8", "9"]),
          _buildRow(["", "0", "back"]),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      children: keys.map((key) {
        return Expanded(
          child: InkWell(
            onTap: key.isEmpty ? null : () => onKeyTap(key),
            child: Container(
              height: 65.h,
              alignment: Alignment.center,
              child: key == "back"
                  ? const Icon(Icons.backspace_outlined, color: Colors.black87)
                  : Text(
                      key,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
            ),
          ),
        );
      }).toList(),
    );
  }
}