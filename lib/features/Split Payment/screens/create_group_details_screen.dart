import 'package:flutter/material.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/features/Split%20Payment/model/split_models.dart';
import 'package:payment_app/features/Split%20Payment/screens/enter_amount_screen.dart';


class CreateGroupDetailsScreen extends StatefulWidget {
  final List<UserModel> selectedMembers;
  const CreateGroupDetailsScreen({Key? key, required this.selectedMembers}) : super(key: key);

  @override
  State<CreateGroupDetailsScreen> createState() => _CreateGroupDetailsScreenState();
}

class _CreateGroupDetailsScreenState extends State<CreateGroupDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isButtonActive = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        _isButtonActive = _nameController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create new group")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: greyColor[200],
                  child: const Icon(Icons.add_a_photo, color: greyColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Group name",
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: themeColor)),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Group Members: You + ${widget.selectedMembers.length}", style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: widget.selectedMembers.length,
              itemBuilder: (context, index) {
                final member = widget.selectedMembers[index];
                return Column(
                  children: [
                    CircleAvatar(radius: 24, child: Text(member.name[0])),
                    Text(member.name, overflow: TextOverflow.ellipsis),
                  ],
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isButtonActive ? themeColor : greyColor[300],
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _isButtonActive ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnterAmountScreen(
                      groupName: _nameController.text,
                      members: widget.selectedMembers,
                    ),
                  ),
                );
              } : null,
              child: Text("CREATE", style: TextStyle(color: _isButtonActive ? whiteColor : greyColor)),
            ),
          )
        ],
      ),
    );
  }
}