import 'package:cloud_firestore/cloud_firestore.dart';

class Traveller {
  String fullName;
  int age;
  DateTime dateOfBirth;
  String gender;

  Traveller({
    required this.fullName,
    required this.age,
    required this.dateOfBirth,
    required this.gender,
  });

  // Method to create a Traveller object from a map (for Firestore)
  factory Traveller.fromMap(Map<String, dynamic> map) {
    return Traveller(
      fullName: map['fullName'] ?? '',
      age: map['age'] ?? 0,
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      gender: map['gender'] ?? '',
    );
  }

  // Method to convert a Traveller object to a map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'age': age,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
    };
  }
}
