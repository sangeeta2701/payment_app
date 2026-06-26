import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:payment_app/core/theme/app_colors.dart';

class ContactsListSection extends StatefulWidget {
  const ContactsListSection({super.key});

  @override
  State<ContactsListSection> createState() => _ContactsListSectionState();
}

class _ContactsListSectionState extends State<ContactsListSection> {
  List<Contact> _contacts = [];
  bool _isLoading = true;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _fetchDeviceContacts();
  }

  Future<void> _fetchDeviceContacts() async {
    try {
      final status = await Permission.contacts.status;
      
      if (status.isDenied || status.isPermanentlyDenied) {
        final requestStatus = await Permission.contacts.request();
        if (!requestStatus.isGranted) {
          setState(() {
            _permissionDenied = true;
            _isLoading = false;
          });
          return;
        }
      }

      // Read internal hardware storage
      final dynamicContacts = await FastContacts.getAllContacts();
      
      // Filter out contacts that don't have valid phone records
      final validContacts = dynamicContacts
          .where((c) => c.phones.isNotEmpty && c.displayName.trim().isNotEmpty)
          .toList();

      // Sort contacts alphabetically to maintain clear UX
      validContacts.sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));

      setState(() {
        _contacts = validContacts;
        _isLoading = false;
        _permissionDenied = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Generate deterministic avatar styling based on string hash values
  Color _getAvatarBackgroundColor(String name) {
    final List<Color> subtleColors = [
      const Color(0xFFD4E157).withOpacity(0.4),
      const Color(0xFFE1BEE7),
      const Color(0xFFCFD8DC),
      const Color(0xFFFFCCBC),
      const Color(0xFFC8E6C9),
    ];
    return subtleColors[name.hashCode % subtleColors.length];
  }

  Color _getAvatarTextColor(String name) {
    final List<Color> darkColors = [
      const Color(0xFF558B2F),
      const Color(0xFF6A1B9A),
      const Color(0xFF37474F),
      const Color(0xFFD84315),
      const Color(0xFF2E7D32),
    ];
    return darkColors[name.hashCode % darkColors.length];
  }

  String _getInitials(String name) {
    final cleanName = name.replaceAll(RegExp(r'[^\w\s]'), '').trim();
    if (cleanName.isEmpty) return "CN";
    final tokens = cleanName.split(' ');
    if (tokens.length >= 2) {
      return (tokens[0].substring(0, 1) + tokens[1].substring(0, 1)).toUpperCase();
    }
    return cleanName.substring(0, min(2, cleanName.length)).toUpperCase();
  }

  int min(int a, int b) => a < b ? a : b;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 120.h,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (_permissionDenied) {
      return _buildMessageState(
        icon: Icons.contact_page_outlined,
        message: "Contacts permission required to display local device directories.",
        action: TextButton(
          onPressed: () => openAppSettings(),
          child: const Text("Open Settings"),
        ),
      );
    }

    if (_contacts.isEmpty) {
      return _buildMessageState(
        icon: Icons.person_search_outlined,
        message: "No address book entries matching.",
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _contacts.length,
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(left: 72.w),
          child: Divider(color: Colors.grey.shade100, height: 1),
        ),
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          final displayName = contact.displayName;
          final primaryPhoneNumber = contact.phones.first.number;

          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            onTap: () {
            },
            leading: CircleAvatar(
              radius: 22.r,
              backgroundColor: _getAvatarBackgroundColor(displayName),
              child: Text(
                _getInitials(displayName),
                style: TextStyle(
                  color: _getAvatarTextColor(displayName),
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ),
            title: Text(
              displayName,
              style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 14.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Text(
                primaryPhoneNumber,
                style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 12.sp),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageState({required IconData icon, required String message, Widget? action}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(24.r)),
      child: Column(
        children: [
          Icon(icon, size: 36.sp, color: greyColor),
          height8,
          Text(message, textAlign: TextAlign.center, style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 12.sp)),
          if (action != null) ...[height4, action],
        ],
      ),
    );
  }
}