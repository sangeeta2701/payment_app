class UserModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String? profilePicUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.profilePicUrl,
  });
}

class SplitGroupModel {
  final String id;
  final String groupName;
  final String? profilePicUrl;
  final List<UserModel> members;
  final double totalExpense;
  final String paidById;
  final bool isSettled;

  SplitGroupModel({
    required this.id,
    required this.groupName,
    this.profilePicUrl,
    required this.members,
    required this.totalExpense,
    required this.paidById,
    this.isSettled = false,
  });
}