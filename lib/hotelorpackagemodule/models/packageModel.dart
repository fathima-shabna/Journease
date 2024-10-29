import 'package:cloud_firestore/cloud_firestore.dart';

class PackageModel {
  final String packageId; // Package ID
  final String hostId;
  final int nights;
  final int days;
  final String title;
  final String destination;
  final String description;
  final List<String> daySummaries;
  final String? arrivalFlight;
  final String? departureFlight;
  final String transportFrom;
  final String transportTo;
  final double pricePerPerson;
  final double offerPrice;
  final double pricePerPerson1;
  final double offerPrice1;
  final DateTime createdAt;
  final DateTime startDate; // New field for start date
  final String? imageUrl;
  final List<Map<String, dynamic>> flightDetails;
   // Image URL

  PackageModel({
    required this.packageId,
    required this.hostId,
    required this.nights,
    required this.days,
    required this.title,
    required this.destination,
    required this.description,
    required this.daySummaries,
    this.arrivalFlight,
    this.departureFlight,
    required this.transportFrom,
    required this.transportTo,
    required this.pricePerPerson,
    required this.offerPrice,
    required this.pricePerPerson1,
    required this.offerPrice1,
    required this.createdAt,
    required this.startDate, // Initialize startDate
    this.imageUrl, 
    required this.flightDetails,
  });

  factory PackageModel.fromMap(Map<String, dynamic> data, String id) {
    return PackageModel(
      packageId: id,
      hostId: data['hostId'],
      nights: data['nights'],
      days: data['days'],
      title: data['title'],
      destination: data['destination'],
      description: data['description'],
      daySummaries: List<String>.from(data['daySummaries']),
      arrivalFlight: data['arrivalFlight'],
      departureFlight: data['departureFlight'],
      transportFrom: data['transportFrom'],
      transportTo: data['transportTo'],
      pricePerPerson: data['pricePerPerson'],
      offerPrice: data['offerPrice'],
      pricePerPerson1: data['pricePerPerson1'],
      offerPrice1: data['offerPrice1'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      startDate: (data['startDate'] as Timestamp).toDate(), // Parse startDate
      imageUrl: data['imageUrl'], 
      flightDetails: List<Map<String, dynamic>>.from(data['flightDetails'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hostId': hostId,
      'nights': nights,
      'days': days,
      'title': title,
      'destination': destination,
      'description': description,
      'daySummaries': daySummaries,
      'arrivalFlight': arrivalFlight,
      'departureFlight': departureFlight,
      'transportFrom': transportFrom,
      'transportTo': transportTo,
      'pricePerPerson': pricePerPerson,
      'offerPrice': offerPrice,
      'pricePerPerson1': pricePerPerson1,
      'offerPrice1': offerPrice1,
      'createdAt': FieldValue.serverTimestamp(),
      'startDate': startDate, // Include startDate in the map
      'imageUrl': imageUrl,
      'flightDetails': flightDetails
    };
  }

  factory PackageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PackageModel(
      packageId: doc.id,
      hostId: data['hostId'],
      nights: data['nights'],
      days: data['days'],
      title: data['title'],
      destination: data['destination'],
      description: data['description'],
      daySummaries: List<String>.from(data['daySummaries']),
      arrivalFlight: data['arrivalFlight'],
      departureFlight: data['departureFlight'],
      transportFrom: data['transportFrom'],
      transportTo: data['transportTo'],
      pricePerPerson: data['pricePerPerson'],
      offerPrice: data['offerPrice'],
      pricePerPerson1: data['pricePerPerson1'],
      offerPrice1: data['offerPrice1'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      startDate: (data['startDate'] as Timestamp).toDate(), // Parse startDate
      imageUrl: data['imageUrl'],
      flightDetails: List<Map<String, dynamic>>.from(data['flightDetails'] ?? []),
    );
  }

  PackageModel copyWith({
    String? packageId,
    String? hostId,
    int? nights,
    int? days,
    String? title,
    String? destination,
    String? description,
    List<String>? daySummaries,
    String? arrivalFlight,
    String? departureFlight,
    String? transportFrom,
    String? transportTo,
    double? pricePerPerson,
    double? offerPrice,
    double? pricePerPerson1,
    double? offerPrice1,
    DateTime? createdAt,
    DateTime? startDate, // Add startDate to copyWith
    String? imageUrl,
    List<Map<String, dynamic>>? flightDetails,
  }) {
    return PackageModel(
      packageId: packageId ?? this.packageId,
      hostId: hostId ?? this.hostId,
      nights: nights ?? this.nights,
      days: days ?? this.days,
      title: title ?? this.title,
      destination: destination ?? this.destination,
      description: description ?? this.description,
      daySummaries: daySummaries ?? this.daySummaries,
      arrivalFlight: arrivalFlight ?? this.arrivalFlight,
      departureFlight: departureFlight ?? this.departureFlight,
      transportFrom: transportFrom ?? this.transportFrom,
      transportTo: transportTo ?? this.transportTo,
      pricePerPerson: pricePerPerson ?? this.pricePerPerson,
      offerPrice: offerPrice ?? this.offerPrice,
      pricePerPerson1: pricePerPerson1 ?? this.pricePerPerson1,
      offerPrice1: offerPrice1 ?? this.offerPrice1,
      createdAt: createdAt ?? this.createdAt,
      startDate: startDate ?? this.startDate, // Set default value for startDate
      imageUrl: imageUrl ?? this.imageUrl,
      flightDetails: flightDetails ?? this.flightDetails,
    );
  }
}
