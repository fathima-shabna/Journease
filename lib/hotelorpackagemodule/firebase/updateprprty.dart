import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journease/hotelorpackagemodule/models/propertyModel.dart';

class UpdateProperty {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Function to update property data in Firestore
  Future<void> updateProperty(PropertyModel property) async {
    try {
      // Reference to the specific property document in Firestore
      DocumentReference propertyRef = _db.collection('properties').doc(property.propertyId);

      // Update property data in Firestore
      await propertyRef.update(property.toMap());

      print('Property updated successfully');
    } catch (e) {
      print('Error updating property: $e');
      throw e; // Optionally, rethrow the error for further handling
    }
  }
}
