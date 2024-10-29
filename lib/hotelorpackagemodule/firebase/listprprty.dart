import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journease/hotelorpackagemodule/models/propertyModel.dart';

class GetToList {
  // Assuming you have a collection for users in Firestore
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  // Get property listings as a stream for a specific user
  Stream<List<PropertyModel>> getPropertyListings(String? userId) {
    return userCollection
        .doc(userId)
        .collection('properties')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return PropertyModel.fromMap(data).copyWith(propertyId: doc.id); // Set the document ID here
          }).toList();
        });
  }

  // Delete a property by its name or ID
  Future<void> deleteProperty(String propertyName, String? userId) async {
    QuerySnapshot query = await userCollection
        .doc(userId)
        .collection('properties')
        .where('propertyName', isEqualTo: propertyName)
        .get();

    if (query.docs.isNotEmpty) {
      await query.docs.first.reference.delete();
    }
  }
}

