// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fast_contacts/fast_contacts.dart';
// import 'package:payment_app/core/theme/text_stylies.dart';
// import 'package:payment_app/features/Pay%20Anyone/model/contact_model.dart';
// import 'package:payment_app/features/Pay%20Anyone/widgets/contact_tile.dart';
// import 'package:payment_app/features/Pay%20Anyone/widgets/pay_search_bar.dart';
// import 'package:payment_app/features/Payment%20Details/screens/payment_detail_screen.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:payment_app/core/theme/app_colors.dart';

// class PayAnyoneScreen extends StatefulWidget {
//   const PayAnyoneScreen({super.key});

//   @override
//   State<PayAnyoneScreen> createState() => _PayAnyoneScreenState();
// }

// class _PayAnyoneScreenState extends State<PayAnyoneScreen> {
//   List<PayContact> _deviceContacts = [];
//   List<PayContact> _filteredContacts = [];
//   bool _isLoading = false;
//   bool _permissionDenied = false;
//   String _searchQuery = "";

//   @override
//   void initState() {
//     super.initState();
//     _checkAndRequestPermission();
//   }

//   // Enforces checking permission each time screen mounts
//   Future<void> _checkAndRequestPermission() async {
//     setState(() => _isLoading = true);

//     var status = await Permission.contacts.status;

//     if (status.isGranted) {
//       await _fetchContacts();
//     } else {
//       // Prompt request dialog sequentially
//       var requestStatus = await Permission.contacts.request();
//       if (requestStatus.isGranted) {
//         await _fetchContacts();
//       } else {
//         setState(() {
//           _permissionDenied = true;
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _fetchContacts() async {
//     try {
//       final contacts = await FastContacts.getAllContacts();
//       List<PayContact> parsedList = [];

//       for (var contact in contacts) {
//         if (contact.phones.isNotEmpty) {
//           // Normalize formatting to strip symbols or whitespace safely
//           // String cleanPhone = contact.phones.first.number.replaceAll(RegExp(r'\s+\-+'), '');
//           String cleanPhone = contact.phones.first.number.replaceAll(RegExp(r'[\s\-()]'), '');
//           parsedList.add(PayContact(
//             displayName: contact.displayName,
//             phoneNumber: cleanPhone,
//             isSavedContact: true,
//             subtitleInfo: "Mobile",
//           ));
//         }
//       }

//       setState(() {
//         _deviceContacts = parsedList;
//         _filteredContacts = parsedList;
//         _permissionDenied = false;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _handleSearch(String query) {
//   _searchQuery = query.trim();

//   if (_searchQuery.isEmpty) {
//     setState(() => _filteredContacts = _deviceContacts);
//     return;
//   }

//   final lowercaseQuery = _searchQuery.toLowerCase();

//   // Strip all non-numeric characters from the query to compare raw numbers cleanly
//   final numericQueryOnly = _searchQuery.replaceAll(RegExp(r'[^0-9]'), '');

//   // 1. Match existing contacts by Name OR by clean Phone Number
//   final matches = _deviceContacts.where((contact) {
//     final nameMatch = contact.displayName.toLowerCase().contains(lowercaseQuery);

//     // Clean up saved phone number to remove spaces/hyphens for a uniform match
//     final cleanDevicePhone = contact.phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
//     final phoneMatch = numericQueryOnly.isNotEmpty && cleanDevicePhone.contains(numericQueryOnly);

//     return nameMatch || phoneMatch;
//   }).toList();

//   // 2. Fallback rule: If input is primarily numbers, minimum 4 digits,
//   // and does NOT exactly match any saved contact number, mock an unsaved contact payload.
//   final isNumericInput = RegExp(r'^[0-9+\- ]+$').hasMatch(_searchQuery);

//   bool exactMatchExists = _deviceContacts.any((c) {
//     return c.phoneNumber.replaceAll(RegExp(r'[^0-9]'), '') == numericQueryOnly;
//   });

//   if (matches.isEmpty && isNumericInput && numericQueryOnly.length >= 4 && !exactMatchExists) {
//     matches.add(PayContact(
//       displayName: _searchQuery, // Display the raw typed number as the Title banner
//       phoneNumber: _searchQuery,
//       isSavedContact: false,
//       subtitleInfo: "Proceed to pay direct account",
//     ));
//   }

//   setState(() {
//     _filteredContacts = matches;
//   });
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         backgroundColor: bgColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: blackColor),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Pay Anyone",
//           style: AppTextStyles.blackContentTextStyle.copyWith(fontSize: 16.sp,),
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//               child: PaySearchBar(onChanged: _handleSearch),
//             ),
//             SizedBox(height: 12.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
//               child: Text(
//                 _searchQuery.isEmpty ? "All Contacts" : "Search Results",
//                 style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Expanded(child: _buildBodyContent()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBodyContent() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator.adaptive());
//     }

//     if (_permissionDenied) {
//       return Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 32.w),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.contacts_outlined, size: 54.sp, color: Colors.grey),
//               SizedBox(height: 16.h),
//               Text(
//                 "Contact Permission Required",
//                 style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: blackColor),
//               ),
//               SizedBox(height: 8.h),
//               Text(
//                 "Please enable access to choose from your address book natively.",
//                 textAlign: TextAlign.center,
//                 style: AppTextStyles.greyContentTextStyle.copyWith(fontSize: 12.sp)
//               ),
//               SizedBox(height: 16.h),
//               ElevatedButton(
//                 onPressed: _checkAndRequestPermission,
//                 style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F0C21)),
//                 child: const Text("Grant Access", style: TextStyle(color: whiteColor)),
//               )
//             ],
//           ),
//         ),
//       );
//     }

//     if (_filteredContacts.isEmpty) {
//       return Center(
//         child: Text(
//           "No contacts found",
//           style: TextStyle(color: greyColor, fontSize: 14.sp),
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: _filteredContacts.length,
//       itemBuilder: (context, index) {
//         final contact = _filteredContacts[index];
//         return ContactTile(
//           contact: contact,
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => PaymentDetailsScreen(contact: contact),
//               ),
//              );
//           },
//         );
//       },
//     );
//   }
// }

//updated UI
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Pay%20Anyone/model/contact_model.dart';
import 'package:payment_app/features/Pay%20Anyone/widgets/contact_tile.dart';
import 'package:payment_app/features/Pay%20Anyone/widgets/pay_search_bar.dart';
import 'package:payment_app/features/Pay%20Anyone/widgets/recent_contact_bar.dart';
import 'package:payment_app/features/Payment%20Details/screens/payment_detail_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:payment_app/core/theme/app_colors.dart';

class PayAnyoneScreen extends StatefulWidget {
  const PayAnyoneScreen({super.key});

  @override
  State<PayAnyoneScreen> createState() => _PayAnyoneScreenState();
}

class _PayAnyoneScreenState extends State<PayAnyoneScreen> {
  List<PayContact> _deviceContacts = [];
  List<PayContact> _filteredContacts = [];
  List<PayContact> _recentContacts = []; // Tracks horizontal top list
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

      // 1. Sort all loaded device contacts ALPHABETICALLY by display name
      parsedList.sort(
        (a, b) =>
            a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()),
      );

      setState(() {
        _deviceContacts = parsedList;
        _filteredContacts = parsedList;

        // 2. Mocking historical activity targets (Takes top 5 as recents for mock context)
        _recentContacts = parsedList.take(5).toList();

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

    final isNumericInput = RegExp(r'^[0-9+\- ]+$').hasMatch(_searchQuery);
    bool exactMatchExists = _deviceContacts.any(
      (c) =>
          c.phoneNumber.replaceAll(RegExp(r'[^0-9]'), '') == numericQueryOnly,
    );

    if (matches.isEmpty &&
        isNumericInput &&
        numericQueryOnly.length >= 4 &&
        !exactMatchExists) {
      matches.add(
        PayContact(
          displayName: _searchQuery,
          phoneNumber: _searchQuery,
          isSavedContact: false,
          subtitleInfo: "Proceed to pay direct account",
        ),
      );
    }

    setState(() {
      _filteredContacts = matches;
    });
  }

  void _navigateToDetails(PayContact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentDetailsScreen(contact: contact),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Pay Anyone",
          style: AppTextStyles.blackContentTextStyle.copyWith(fontSize: 16.sp),
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
            Expanded(child: _buildBodyContent()),
          ],
        ),
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

    // Wrap list inside CustomScrollView to elegantly hold both components together
    return CustomScrollView(
      slivers: [
        // 1. Show Horizontal Recents ONLY when search text field query is empty
        if (_searchQuery.isEmpty)
          SliverToBoxAdapter(
            child: RecentContactsBar(
              recentContacts: _recentContacts,
              onContactTap: _navigateToDetails,
            ),
          ),

        // 2. Header text separation row
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              _searchQuery.isEmpty ? "All Contacts" : "Search Results",
              style: AppTextStyles.greyContentTextStyle.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // 3. Main Contacts List Group
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final contact = _filteredContacts[index];
            return ContactTile(
              contact: contact,
              onTap: () => _navigateToDetails(contact),
            );
          }, childCount: _filteredContacts.length),
        ),
      ],
    );
  }

  Widget _buildPermissionView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contacts_outlined, size: 54.sp, color: Colors.grey),
            
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
              style: AppTextStyles.greyContentTextStyle.copyWith(
                fontSize: 12.sp,
              ),
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
