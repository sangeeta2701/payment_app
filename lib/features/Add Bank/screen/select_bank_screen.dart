
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/features/Add%20Bank/models/bankModel.dart';
import 'package:payment_app/features/Add%20Bank/providers/bank_notifier.dart';
import 'package:payment_app/features/Add%20Bank/widgets/account_verification_sheet.dart';
import 'package:payment_app/features/Add%20Bank/widgets/all_banks_list.dart';
import 'package:payment_app/features/Add%20Bank/widgets/popular_banks_grid.dart';


class SelectBankScreen extends ConsumerStatefulWidget {
  const SelectBankScreen({super.key});

  @override
  ConsumerState<SelectBankScreen> createState() => _SelectBankScreenState();
}

class _SelectBankScreenState extends ConsumerState<SelectBankScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = "";

final List<BankModel> _allBanksMaster = [
    BankModel(
      id: "1", 
      name: "SBI Bank", 
      isPopular: true, 
      assetPath: "https://vignette.wikia.nocookie.net/logopedia/images/d/d4/State_Bank_of_India_logo.png"
    ),
    BankModel(
      id: "2", 
      name: "HDFC Bank", 
      isPopular: true, 
      assetPath: "https://cdn.worldvectorlogo.com/logos/hdfc-bank-logo.svg"
    ),
    BankModel(
      id: "3", 
      name: "Canara Bank", 
      isPopular: true, 
      assetPath: "https://www.canarabank.com/media/1053/canara-logo.png"
    ),
    BankModel(
      id: "4", 
      name: "ICICI Bank", 
      isPopular: true, 
      assetPath: "https://companieslogo.com/img/orig/ICICIBANK.NS-8e9da563.png"
    ),
    BankModel(
      id: "5", 
      name: "Kotak Bank", 
      isPopular: true, 
      assetPath: "https://companieslogo.com/img/orig/KOTAKBANK.NS-904128dd.png"
    ),
    BankModel(
      id: "6", 
      name: "Axis Bank", 
      isPopular: true, 
      assetPath: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Axis_Bank_Logo.svg/2560px-Axis_Bank_Logo.svg.png"
    ),
  ];

  List<BankModel> _popularBanks = [];
  List<BankModel> _allBanksSorted = [];

@override
void initState() {
  super.initState();
  _processAndSortLists();
  
  //Temp debug — remove after confirming
  final user = FirebaseAuth.instance.currentUser;
  debugPrint("**********************=== AUTH CHECK ===");
  debugPrint("**********************User is null: ${user == null}");
  debugPrint("**********************UID: ${user?.uid}");
  debugPrint("**********************Phone: ${user?.phoneNumber}");
}

  void _processAndSortLists() {
    _popularBanks = _allBanksMaster.where((bank) => bank.isPopular).toList();
    _allBanksSorted = List.from(_allBanksMaster);
    _allBanksSorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  void _onSearchChanged(String query) {
    setState(() {
      _currentQuery = query.trim().toLowerCase();
    });
  }

  void _verifyAndLinkAccount(BankModel bank) {
    // ➔ Access the notifier cleanly using the modern Riverpod 'ref' parameter
    ref.read(bankProvider.notifier).resetStatus();
    ref.read(bankProvider.notifier).findLinkedBankAccounts(bank);

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) {
        return AccountVerificationSheet(selectedBank: bank);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayAllBanks = _allBanksSorted.where((b) => b.name.toLowerCase().contains(_currentQuery)).toList();
    final displayPopularBanks = _popularBanks.where((b) => b.name.toLowerCase().contains(_currentQuery)).toList();

    return Scaffold(
      // backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        // backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text("Help", style: TextStyle(color: Colors.black87, fontSize: 12.sp, fontWeight: FontWeight.w600)),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentQuery.isEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  "Add Your Bank Account for\nUPI Payments",
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1F1F1F), height: 1.3),
                ),
              ),
            ],
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Container(
                height: 46.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.black54, size: 20.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: "Enter the Bank Name",
                          hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      if (_currentQuery.isEmpty && displayPopularBanks.isNotEmpty) ...[
                        PopularBanksGrid(
                          popularBanks: displayPopularBanks,
                          onBankSelected: _verifyAndLinkAccount,
                        ),
                        SizedBox(height: 16.h),
                      ],
                      AllBanksList(
                        banksList: displayAllBanks,
                        onBankSelected: _verifyAndLinkAccount,
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}