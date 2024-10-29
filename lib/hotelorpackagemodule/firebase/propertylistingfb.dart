// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:io';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Function to upload image to Firebase Storage
//   Future<String> uploadImageToFirebase(File imageFile, String folderName) async {
//     try {
//       String fileName = imageFile.path.split('/').last;
//       final storageRef = FirebaseStorage.instance.ref().child('$folderName/$fileName');
//       UploadTask uploadTask = storageRef.putFile(imageFile);
//       TaskSnapshot taskSnapshot = await uploadTask;
//       String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//       return downloadUrl;
//     } catch (e) {
//       print('Error uploading image: $e');
//       return '';
//     }
//   }

//   // Function to create a new property listing
//   Future<void> createPropertyListing(Map<String, dynamic> propertyData) async {
//     try {
//       await _firestore.collection('propertylist').add(propertyData);
//       print('Property listing created successfully');
//     } catch (e) {
//       print('Error creating property listing: $e');
//     }
//   }

//   // Function to upload multiple images and return the URLs
//   Future<List<String>> uploadMultipleImages(List<File> images, String folderName) async {
//     List<String> imageUrls = [];
//     for (File image in images) {
//       String imageUrl = await uploadImageToFirebase(image, folderName);
//       if (imageUrl.isNotEmpty) {
//         imageUrls.add(imageUrl);
//       }
//     }
//     return imageUrls;
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journease/hotelorpackagemodule/models/propertyModel.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Function to upload property data to Firestore
  Future<void> createPropertyListing(PropertyModel property) async {
    try {
      // Add property data to the 'properties' collection
      await _db.collection('properties').add(property.toMap());
      print('Property uploaded successfully.');
    } catch (e) {
      print('Error uploading property: $e');
      throw e;
    }
  }
}
