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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'profilePicUrl': profilePicUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profilePicUrl: map['profilePicUrl'],
    );
  }
}

class SplitGroupModel {
  final String id;
  final String groupName;
  final String? profilePicUrl;
  final List<UserModel> members;
  final double totalExpense;
  final String paidById;
  final bool isSettled;
  final DateTime createdAt;

  SplitGroupModel({
    required this.id,
    required this.groupName,
    this.profilePicUrl,
    required this.members,
    required this.totalExpense,
    required this.paidById,
    this.isSettled = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupName': groupName,
      'profilePicUrl': profilePicUrl,
      'members': members.map((x) => x.toMap()).toList(),
      'totalExpense': totalExpense,
      'paidById': paidById,
      'isSettled': isSettled,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SplitGroupModel.fromMap(Map<String, dynamic> map) {
    return SplitGroupModel(
      id: map['id'] ?? '',
      groupName: map['groupName'] ?? '',
      profilePicUrl: map['profilePicUrl'],
      members: List<UserModel>.from((map['members'] as List<dynamic>).map((x) => UserModel.fromMap(x as Map<String, dynamic>))),
      totalExpense: (map['totalExpense'] as num).toDouble(),
      paidById: map['paidById'] ?? '',
      isSettled: map['isSettled'] ?? false,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}