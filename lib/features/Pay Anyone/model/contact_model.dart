class PayContact {
  final String displayName;
  final String phoneNumber;
  final bool isSavedContact;
  final String? subtitleInfo; 

  PayContact({
    required this.displayName,
    required this.phoneNumber,
    required this.isSavedContact,
    this.subtitleInfo,
  });
}