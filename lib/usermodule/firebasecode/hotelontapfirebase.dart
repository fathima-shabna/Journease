// import 'package:cloud_firestore/cloud_firestore.dart';

// class HotelOnTap {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Fetch property details using the property ID
//   Future<Map<String, dynamic>?> getPropertyDetails(String propertyId) async {
//     try {
//       // Fetch the document from the 'properties' collection group
//       QuerySnapshot propertySnapshot = await _firestore
//           .collectionGroup('properties')
//           .where('id', isEqualTo: propertyId)
//           .get();

//       if (propertySnapshot.docs.isNotEmpty) {
//         // Assuming only one document matches the propertyId
//         DocumentSnapshot document = propertySnapshot.docs.first;
//         return document.data() as Map<String, dynamic>;
//       }
//     } catch (e) {
//       print('Error fetching property details: $e');
//     }
//     return null; // Return null if no property is found or in case of an error
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class HotelOnTap {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch property details using the property ID (Assuming you have the user ID or path)
  Future<Map<String, dynamic>?> getPropertyDetailsById(String userId, String propertyId) async {
    try {
      // Assuming the properties are nested under a specific user's collection
      DocumentSnapshot document = await _firestore
          .collection('users')
          .doc(userId)
          .collection('properties')
          .doc(propertyId)
          .get();

      if (document.exists) {
        return document.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error fetching property details: $e');
    }
    return null; // Return null if no property is found or in case of an error
  }
}

