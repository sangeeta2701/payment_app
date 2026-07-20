


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Split%20Payment/model/split_models.dart';
import 'package:payment_app/features/Split%20Payment/screens/select_members_screen.dart';
import 'package:payment_app/features/Split%20Payment/repository/split_repository.dart';

class ExpenseSummaryScreen extends StatefulWidget {
  const ExpenseSummaryScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseSummaryScreen> createState() => _ExpenseSummaryScreenState();
}

class _ExpenseSummaryScreenState extends State<ExpenseSummaryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SplitRepository _splitRepository = SplitRepository();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _showSplitExpensesBottomSheet(List<SplitGroupModel> existingGroups) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: greyColor[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                   Text(
                    "Split expenses with",
                    style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                  height16,
                  TextField(
                    style: AppTextStyles.blackContentTextStyle(context).copyWith(fontSize: 14.sp),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search name, number or groups",
                      hintStyle: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 12.sp),
                      filled: true,
                      fillColor: greyColor[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SelectMembersScreen()),
                      );
                    },
                    icon: const Icon(Icons.group_add, color: themeColor),
                    label:  Text(
                      "Create New Group",
                      style: AppTextStyles.themeButtonTextStyle(context).copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                   Text("RECENT GROUPS", style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: existingGroups.isEmpty
                        ?  Center(child: Text("No active split groups found", style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 14.sp)))
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: existingGroups.length,
                            itemBuilder: (context, index) {
                              final group = existingGroups[index];
                              final fallbackInitial = group.groupName.isNotEmpty ? group.groupName[0].toUpperCase() : 'G';
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF5E17EB).withOpacity(0.1),
                                  child: Text(fallbackInitial, style:  AppTextStyles.themeButtonTextStyle(context).copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                                ),
                                title: Text(group.groupName, style: AppTextStyles.blackContentTextStyle(context).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                                subtitle: Text("${group.members.length + 1} members • ₹${group.totalExpense.toStringAsFixed(0)} total"),
                                trailing: Icon(Icons.chevron_right_rounded, color: greyColor[400]),
                              );
                            },
                          ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SplitGroupModel>>(
      stream: _splitRepository.getSplitGroupsStream(),
      builder: (context, snapshot) {
        final groups = snapshot.data ?? [];
        
        // Dynamic balance calculation
        double totalBalance = 0.0;
        for (var group in groups) {
          if (!group.isSettled) {
            totalBalance += group.totalExpense / (group.members.length + 1);
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Expense Summary", style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: greyColor[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Split Balance", style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 12.sp)),
                        Text("₹ ${totalBalance.toStringAsFixed(2)}", style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 24.sp, fontWeight: FontWeight.bold)),
                        Text("Your net active pool amount", style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 12.sp)),
                      ],
                    ),
                    const CircleAvatar(backgroundColor: Colors.orange, radius: 12)
                  ],
                ),
              ),
              TabBar(
                controller: _tabController,
                labelColor: themeColor,
                unselectedLabelColor: greyColor,
                indicatorColor: themeColor,
                tabs: const [
                  Tab(text: "Groups"),
                  Tab(text: "People"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Dynamic Groups Display List
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: groups.isEmpty
                          ? Center(child: Text("No active groups. Tap button below to split!", style: AppTextStyles.greyContentTextStyle(context)))
                          : ListView.builder(
                              itemCount: groups.length,
                              itemBuilder: (context, index) {
                                final item = groups[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 6.h),
                                  elevation: 1,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: themeColor,
                                      child: Text(item.groupName[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                                    ),
                                    title: Text(item.groupName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text("Paid by: ${item.paidById}"),
                                    trailing: Text(
                                      "₹ ${item.totalExpense.toStringAsFixed(2)}",
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    Center(child: Text("No individual entries yet", style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 14.sp))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    onPressed: () => _showSplitExpensesBottomSheet(groups),
                    child: Text("SPLIT NEW EXPENSE", style: AppTextStyles.whiteButtonTextStyle(context).copyWith(fontSize: 15.sp)),
                  ),
                ),
              ),
              height30,
            ],
          ),
        );
      },
    );
  }
}