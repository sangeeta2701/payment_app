import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:payment_app/features/Split%20Payment/model/split_models.dart';
import 'package:payment_app/features/Split%20Payment/screens/create_group_details_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/features/Pay%20Anyone/model/contact_model.dart';
import 'package:payment_app/features/Pay%20Anyone/widgets/pay_search_bar.dart';

class SelectMembersScreen extends StatefulWidget {
  const SelectMembersScreen({super.key});

  @override
  State<SelectMembersScreen> createState() => _SelectMembersScreenState();
}

class _SelectMembersScreenState extends State<SelectMembersScreen> {
  List<PayContact> _deviceContacts = [];
  List<PayContact> _filteredContacts = [];
  final List<PayContact> _selectedContacts = [];

  bool _isLoading = false;
  bool _permissionDenied = false;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
    setState(() => _isLoading = true);
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      await _fetchContacts();
    } else {
      var requestStatus = await Permission.contacts.request();
      if (requestStatus.isGranted) {
        await _fetchContacts();
      } else {
        setState(() {
          _permissionDenied = true;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchContacts() async {
    try {
      final contacts = await FastContacts.getAllContacts();
      List<PayContact> parsedList = [];

      for (var contact in contacts) {
        if (contact.phones.isNotEmpty) {
          String cleanPhone = contact.phones.first.number.replaceAll(
            RegExp(r'[\s\-()]'),
            '',
          );
          parsedList.add(
            PayContact(
              displayName: contact.displayName.isEmpty
                  ? "Unknown"
                  : contact.displayName,
              phoneNumber: cleanPhone,
              isSavedContact: true,
              subtitleInfo: "Mobile",
            ),
          );
        }
      }

      parsedList.sort(
        (a, b) =>
            a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()),
      );

      setState(() {
        _deviceContacts = parsedList;
        _filteredContacts = parsedList;
        _permissionDenied = false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _handleSearch(String query) {
    _searchQuery = query.trim();

    if (_searchQuery.isEmpty) {
      setState(() => _filteredContacts = _deviceContacts);
      return;
    }

    final lowercaseQuery = _searchQuery.toLowerCase();
    final numericQueryOnly = _searchQuery.replaceAll(RegExp(r'[^0-9]'), '');

    final matches = _deviceContacts.where((contact) {
      final nameMatch = contact.displayName.toLowerCase().contains(
        lowercaseQuery,
      );
      final cleanDevicePhone = contact.phoneNumber.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );
      final phoneMatch =
          numericQueryOnly.isNotEmpty &&
          cleanDevicePhone.contains(numericQueryOnly);
      return nameMatch || phoneMatch;
    }).toList();

    setState(() {
      _filteredContacts = matches;
    });
  }

  void _toggleContactSelection(PayContact contact) {
    setState(() {
      final isAlreadySelected = _selectedContacts.any(
        (c) => c.phoneNumber == contact.phoneNumber,
      );
      if (isAlreadySelected) {
        _selectedContacts.removeWhere(
          (c) => c.phoneNumber == contact.phoneNumber,
        );
      } else {
        _selectedContacts.add(contact);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? whiteColor : blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Group",
              style: AppTextStyles.blackContentTextStyle(context).copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? whiteColor : blackColor,
              ),
            ),
            Text(
              "Select group members",
              style: AppTextStyles.greyContentTextStyle(
                context,
              ).copyWith(fontSize: 12.sp),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: PaySearchBar(onChanged: _handleSearch),
            ),

            // Selected Contacts Top Pill Bar Layout Hook
            if (_selectedContacts.isNotEmpty) _buildSelectedContactsBar(),

            Expanded(child: _buildBodyContent()),
          ],
        ),
      ),
      bottomNavigationBar: _selectedContacts.isEmpty
          ? null
          : _buildContinueButton(),
    );
  }

  Widget _buildSelectedContactsBar() {
    return Container(
      height: 90.h,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: greyColor.shade200, width: 0.5),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _selectedContacts.length,
        itemBuilder: (context, index) {
          final contact = _selectedContacts[index];
          final initials = contact.displayName
              .substring(0, contact.displayName.length >= 2 ? 2 : 1)
              .toUpperCase();

          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: SizedBox(
              width: 56.w,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 24.r,
                        backgroundColor: Colors.orange.shade700,
                        child: Text(
                          initials,
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        contact.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11.sp),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => _toggleContactSelection(contact),
                      child: CircleAvatar(
                        radius: 9.r,
                        backgroundColor: greyColor.shade400,
                        child: Icon(
                          Icons.close,
                          size: 12.sp,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (_permissionDenied) {
      return _buildPermissionView();
    }

    if (_filteredContacts.isEmpty) {
      return Center(
        child: Text(
          "No contacts found",
          style: TextStyle(color: greyColor, fontSize: 14.sp),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              _searchQuery.isEmpty ? "ALL CONTACTS" : "SEARCH RESULTS",
              style: AppTextStyles.greyContentTextStyle(context).copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final contact = _filteredContacts[index];
            final isSelected = _selectedContacts.any(
              (c) => c.phoneNumber == contact.phoneNumber,
            );
            final initials = contact.displayName
                .substring(0, contact.displayName.length >= 2 ? 2 : 1)
                .toUpperCase();

            return ListTile(
              onTap: () => _toggleContactSelection(contact),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 2.h,
              ),
              leading: CircleAvatar(
                radius: 22.r,
                backgroundColor: Colors.orange.shade100,
                child: Text(
                  initials,
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                contact.displayName,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                contact.phoneNumber,
                style: TextStyle(fontSize: 12.sp, color: greyColor),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
            );
          }, childCount: _filteredContacts.length),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
        top: 8.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.r,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(
              0xFF5E17EB,
            ), // Purple core primary selection theme tint color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
         
          onPressed: () {
            // Map your dynamic list of type PayContact into a list of type UserModel on the fly
            final List<UserModel> convertedMembers = _selectedContacts.map((
              payContact,
            ) {
              return UserModel(
                id: payContact
                    .phoneNumber, // Using phone number as a clean fallback unique key ID
                name: payContact.displayName,
                phoneNumber: payContact.phoneNumber,
                profilePicUrl: null,
              );
            }).toList();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CreateGroupDetailsScreen(selectedMembers: convertedMembers),
              ),
            );
          },
          child: Text(
            "CONTINUE",
            style: TextStyle(
              color: whiteColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contacts_outlined, size: 54.sp, color: greyColor),
            height16,
            Text(
              "Contact Permission Required",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
            height8,
            Text(
              "Please enable access to choose from your address book natively.",
              textAlign: TextAlign.center,
              style: AppTextStyles.greyContentTextStyle(
                context,
              ).copyWith(fontSize: 12.sp),
            ),
            height16,
            ElevatedButton(
              onPressed: _checkAndRequestPermission,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F0C21),
              ),
              child: const Text(
                "Grant Access",
                style: TextStyle(color: whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
