import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journease/hotelorpackagemodule/models/propertyModel.dart';

class ViewProperty {
  final CollectionReference propertyCollection = FirebaseFirestore.instance.collection('properties');

  Future<PropertyModel?> getPropertyById(String propertyId) async {
    try {
      DocumentSnapshot snapshot = await propertyCollection.doc(propertyId).get();
      if (snapshot.exists) {
        return PropertyModel.fromMap(snapshot.data() as Map<String, dynamic>); // Pass the ID here
      } else {
        print("Property not found with ID: $propertyId");
        return null;
      }
    } catch (e) {
      print("Error fetching property details: $e");
      return null;
    }
  }
}
