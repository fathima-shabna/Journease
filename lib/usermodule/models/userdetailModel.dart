import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  final String userId;       // Unique identifier for the user
  final String fullName;     // Full name of the user
  final String email;        // Email of the user
  final String phone;        // Phone number of the user

  UserDataModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
  });

  // Factory method to create a UserDataModel from Firestore document data
  factory UserDataModel.fromMap(Map<String, dynamic> data, String userId) {
    return UserDataModel(
      userId: userId,
      fullName: data['name'] ?? '', // Assuming fullName is stored as a single field
      email: data['email'] ?? '',
      phone: data['phoneNumber'] ?? '',
    );
  }

   // Factory method to create a UserModel from Firestore DocumentSnapshot
  factory UserDataModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserDataModel.fromMap(data, doc.id); // Use the document ID as userId
  }

  // Method to convert UserDataModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': fullName, // Store fullName as a single field
      'email': email,
      'phoneNumber': phone,
    };
  }

 // Method to fetch user data from Firestore and create UserDataModel
    Future<UserDataModel?> fromFirestore(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('appusers') // Adjust the collection name as necessary
          .doc(userId)
          .get();

      if (doc.exists) {
        return UserDataModel.fromDocument(doc);
      } else {
        return null; // Return null if the document does not exist
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null; // Handle any errors and return null
    }
  }
}

