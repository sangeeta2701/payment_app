import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payment_app/features/Split%20Payment/model/split_models.dart';

class SplitRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream listening to groups collection updates ordered by creation timestamp
  Stream<List<SplitGroupModel>> getSplitGroupsStream() {
    return _firestore
        .collection('split_groups')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => SplitGroupModel.fromMap(doc.data())).toList();
    });
  }

  // Create a new group entry doc in Cloud Firestore
  Future<void> saveNewSplitGroup(SplitGroupModel newGroup) async {
    await _firestore
        .collection('split_groups')
        .doc(newGroup.id)
        .set(newGroup.toMap());
  }
}