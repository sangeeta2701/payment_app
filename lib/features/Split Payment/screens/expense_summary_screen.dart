import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/constants/sizedbox.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/features/Split%20Payment/model/split_models.dart';
import 'package:payment_app/features/Split%20Payment/screens/select_members_screen.dart';


class ExpenseSummaryScreen extends StatefulWidget {
  const ExpenseSummaryScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseSummaryScreen> createState() => _ExpenseSummaryScreenState();
}

class _ExpenseSummaryScreenState extends State<ExpenseSummaryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Simulated initial mock groups matching image data architectures
  final List<SplitGroupModel> _settledGroups = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _showSplitExpensesBottomSheet() {
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
                  const Text(
                    "Split expenses with",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search name, number or groups",
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
                    label: const Text(
                      "Create New Group",
                      style: TextStyle(color: themeColor, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  const Text("RECENTS", style: TextStyle(color: greyColor, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: const [
                        ListTile(
                          leading: CircleAvatar(backgroundColor: Colors.amber, child: Text("N")),
                          title: Text("NBC"),
                          subtitle: Text("GROUP"),
                        ),
                        ListTile(
                          leading: CircleAvatar(backgroundColor: lightBlueColor, child: Text("KM")),
                          title: Text("KR Market"),
                          subtitle: Text("GROUP"),
                        ),
                      ],
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
    return Scaffold(
      appBar: AppBar(
        title:  Text("Expense Summary", style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold)),
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
                     Text("₹ 0", style: AppTextStyles.headingBlackTextStyle(context).copyWith(fontSize: 24.sp, fontWeight: FontWeight.bold)),
                     Text("Your net payable amount", style: AppTextStyles.greyContentTextStyle(context).copyWith(fontSize: 12.sp)),
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        child: ListTile(
                          title: Text("${_settledGroups.length} Settled groups"),
                          trailing:  Text("View", style: AppTextStyles.themeButtonTextStyle(context).copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold))
                        ),
                      ),
                    ],
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
                onPressed: _showSplitExpensesBottomSheet,
                child:  Text("SPLIT NEW EXPENSE", style: AppTextStyles.whiteButtonTextStyle(context).copyWith(fontSize: 15.sp, ),
              ),
            ),
          )
      ),
      height30,
      ],
      ),
    );
  }
}