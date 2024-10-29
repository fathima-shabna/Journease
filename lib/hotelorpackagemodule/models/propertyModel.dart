// class PropertyModel {
//   final String id; // Unique property ID
//   final String name;
//   final String description;
//   final String license;
//   final String idProof;
//   final String address;
//   final String city;
//   final String country;
//   final List<String> amenities;
//   final List<String> nearbyAttractions;
//   final String checkInTime;
//   final String checkOutTime;
//   final String category;
//   final List<String> images; // List of image URLs
//   final List<RoomModel> rooms; // List of RoomModel

//   PropertyModel({
//     required this.id, // Required field for property ID
//     required this.name,
//     required this.description,
//     required this.license,
//     required this.idProof,
//     required this.address,
//     required this.city,
//     required this.country,
//     required this.amenities,
//     required this.nearbyAttractions,
//     required this.checkInTime,
//     required this.checkOutTime,
//     required this.category,
//     required this.images,
//     required this.rooms,
//   });

//   // Factory method to create a PropertyModel from Firebase map
//   factory PropertyModel.fromMap(Map<String, dynamic> data) {
//     var roomList = (data['rooms'] as List)
//         .map((room) => RoomModel.fromMap(room))
//         .toList();

//     return PropertyModel(
//       id: data['id'] ?? '', // Use provided property ID or empty string
//       name: data['name'] ?? '',
//       description: data['description'] ?? '',
//       license: data['license'] ?? '',
//       idProof: data['idProof'] ?? '',
//       address: data['address'] ?? '',
//       city: data['city'] ?? '',
//       country: data['country'] ?? '',
//       amenities: List<String>.from(data['amenities'] ?? []),
//       nearbyAttractions: List<String>.from(data['nearbyAttractions'] ?? []),
//       checkInTime: data['checkInTime'] ?? '',
//       checkOutTime: data['checkOutTime'] ?? '',
//       category: data['category'] ?? '',
//       images: List<String>.from(data['images'] ?? []),
//       rooms: roomList,
//     );
//   }

//   // Convert PropertyModel instance to map (for saving to Firebase)
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id, // Property ID included in the map
//       'name': name,
//       'description': description,
//       'license': license,
//       'idProof': idProof,
//       'address': address,
//       'city': city,
//       'country': country,
//       'amenities': amenities,
//       'nearbyAttractions': nearbyAttractions,
//       'checkInTime': checkInTime,
//       'checkOutTime': checkOutTime,
//       'category': category,
//       'images': images,
//       'rooms': rooms.map((room) => room.toMap()).toList(), // Rooms converted to maps
//     };
//   }
// }

// class RoomModel {
//   final String id; // Unique room ID
//   final String title;
//   final String size;
//   final String view;
//   final String bedType;
//   final String roomType;
//   final String price;
//   final String description;
//   final String offer;
//   final String details;
//   final String freeCancellation;
//   final String? freeCancellationDate; // Nullable field if no date provided
//   final String imageUrl;
//   final int numberOfRooms;
//   final int availableRooms;

//   RoomModel({
//     required this.id, // Required field for room ID
//     required this.title,
//     required this.size,
//     required this.view,
//     required this.bedType,
//     required this.roomType,
//     required this.price,
//     required this.description,
//     required this.offer,
//     required this.details,
//     required this.freeCancellation,
//     this.freeCancellationDate, // Can be null
//     required this.imageUrl,
//     required this.numberOfRooms,
//     required this.availableRooms,
//   });

//   // Factory method to create a RoomModel from Firebase map
//   factory RoomModel.fromMap(Map<String, dynamic> data) {
//     return RoomModel(
//       id: data['id'] ?? '', // Use provided room ID or empty string
//       title: data['title'] ?? '',
//       size: data['size'] ?? '',
//       view: data['view'] ?? '',
//       bedType: data['bedType'] ?? '',
//       roomType: data['roomType'] ?? '',
//       price: data['price'] ?? '',
//       description: data['description'] ?? '',
//       offer: data['offer'] ?? '',
//       details: data['details'] ?? '',
//       freeCancellation: data['freeCancellation'] ?? 'No',
//       freeCancellationDate: data['freeCancellationDate'],
//       imageUrl: data['imageUrl'] ?? '',
//       numberOfRooms: data['numberOfRooms'] ?? 1,
//       availableRooms: data['availableRooms'] ?? 1,
//     );
//   }

//   // Convert RoomModel instance to map (for saving to Firebase)
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id, // Room ID included in the map
//       'title': title,
//       'size': size,
//       'view': view,
//       'bedType': bedType,
//       'roomType': roomType,
//       'price': price,
//       'description': description,
//       'offer': offer,
//       'details': details,
//       'freeCancellation': freeCancellation,
//       'freeCancellationDate': freeCancellationDate,
//       'imageUrl': imageUrl,
//       'numberOfRooms': numberOfRooms,
//       'availableRooms': availableRooms,
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

enum ApprovalStatus {
  approved,
  rejected,
  pending,  // You can add other statuses like "Pending" if needed
}

class PropertyModel {
  String propertyId; // Unique identifier for the property
  String hostId;
  String propertyName;
  String description;
  String license;
  String address;
  String city;
  String country;
  String checkInTime;
  String checkOutTime;
  String amenities;
  String attractions;
  String category;
  List<String> images;
  List<RoomModel> rooms;
  ApprovalStatus approvalStatus;

  PropertyModel({
    required this.propertyId, // Constructor should accept an ID
    required this.hostId,
    required this.propertyName,
    required this.description,
    required this.license,
    required this.address,
    required this.city,
    required this.country,
    required this.checkInTime,
    required this.checkOutTime,
    required this.amenities,
    required this.attractions,
    required this.category,
    required this.images,
    required this.rooms,
    this.approvalStatus = ApprovalStatus.pending,
  });

  // Convert PropertyModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'propertyId': propertyId,
      'hostId': hostId,
      'propertyName': propertyName,
      'description': description,
      'license': license,
      'address': address,
      'city': city,
      'country': country,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'amenities': amenities,
      'attractions': attractions,
      'category': category,
      'images': images,
      'rooms': rooms.map((room) => room.toMap()).toList(),
      'approvalStatus': approvalStatus.toString().split('.').last,
    };
  }

  // Factory method to create PropertyModel from a Map
  factory PropertyModel.fromMap(Map<String, dynamic> data) {
    return PropertyModel(
      propertyId: data['propertyId'], // Use the provided document ID
      hostId: data['hostId'],
      propertyName: data['propertyName'] ?? '',
      description: data['description'] ?? '',
      license: data['license'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      checkInTime: data['checkInTime'] ?? '',
      checkOutTime: data['checkOutTime'] ?? '',
      amenities: data['amenities'] ?? '',
      attractions: data['attractions'] ?? '',
      category: data['category'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      rooms: (data['rooms'] as List<dynamic>?)
          ?.map((roomData) => RoomModel.fromMap(roomData as Map<String, dynamic>))
          .toList() ?? [],
      approvalStatus: ApprovalStatus.values.firstWhere(
        (e) => e.toString().split('.').last == data['approvalStatus'],
        orElse: () => ApprovalStatus.pending,
      ),
    );
  }

  // Method to create a copy of the PropertyModel with updated values
  PropertyModel copyWith({
    String? propertyId,
    String? hostId,
    String? propertyName,
    String? description,
    String? license,
    String? address,
    String? city,
    String? country,
    String? checkInTime,
    String? checkOutTime,
    String? amenities,
    String? attractions,
    String? category,
    List<String>? images,
    List<RoomModel>? rooms,
    ApprovalStatus? approvalStatus,
  }) {
    return PropertyModel(
      propertyId: propertyId ?? this.propertyId,
      hostId: hostId ?? this.hostId,
      propertyName: propertyName ?? this.propertyName,
      description: description ?? this.description,
      license: license ?? this.license,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      amenities: amenities ?? this.amenities,
      attractions: attractions ?? this.attractions,
      category: category ?? this.category,
      images: images ?? this.images,
      rooms: rooms ?? this.rooms,
      approvalStatus: approvalStatus ?? this.approvalStatus,
    );
  }
}


class RoomModel {
  String rid; // Unique identifier for the room
  String title;
  String size;
  String view;
  String bedType;
  String roomType;
  String price;
  String description;
  String offer;
  String details;
  String freeCancellation;
  String? freeCancellationDate;
  String? imageUrl;
  int numberOfRooms;
  int availableRooms;

  RoomModel({
    required this.rid, // Constructor should accept an ID
    required this.title,
    required this.size,
    required this.view,
    required this.bedType,
    required this.roomType,
    required this.price,
    required this.description,
    required this.offer,
    required this.details,
    required this.freeCancellation,
    this.freeCancellationDate,
    this.imageUrl,
    required this.numberOfRooms,
    required this.availableRooms,
  });

  // Convert RoomModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'rid': rid, // Include the ID in the map
      'title': title,
      'size': size,
      'view': view,
      'bedType': bedType,
      'roomType': roomType,
      'price': price,
      'description': description,
      'offer': offer,
      'details': details,
      'freeCancellation': freeCancellation,
      'freeCancellationDate': freeCancellationDate,
      'imageUrl': imageUrl,
      'numberOfRooms': numberOfRooms,
      'availableRooms': availableRooms,
    };
  }

  // Factory method to create RoomModel from a Map
  factory RoomModel.fromMap(Map<String, dynamic> data) {
    return RoomModel(
      rid: data['rid'] ?? '', // Use the provided room ID
      title: data['title'] ?? '',
      size: data['size'] ?? '',
      view: data['view'] ?? '',
      bedType: data['bedType'] ?? '',
      roomType: data['roomType'] ?? '',
      price: data['price'] ?? '',
      description: data['description'] ?? '',
      offer: data['offer'] ?? '',
      details: data['details'] ?? '',
      freeCancellation: data['freeCancellation'] ?? '',
      freeCancellationDate: data['freeCancellationDate'],
      imageUrl: data['imageUrl'],
      numberOfRooms: data['numberOfRooms'] ?? 0,
      availableRooms: data['availableRooms'] ?? 0,
    );
  }

  // Method to create a copy of the RoomModel with updated values
  RoomModel copyWith({
    required String rid,
    String? title,
    String? size,
    String? view,
    String? bedType,
    String? roomType,
    String? price,
    String? description,
    String? offer,
    String? details,
    String? freeCancellation,
    String? freeCancellationDate,
    String? image,
    int? numberOfRooms,
    int? availableRooms,
  }) {
    return RoomModel(
      rid: rid ?? this.rid,
      title: title ?? this.title,
      size: size ?? this.size,
      view: view ?? this.view,
      bedType: bedType ?? this.bedType,
      roomType: roomType ?? this.roomType,
      price: price ?? this.price,
      description: description ?? this.description,
      offer: offer ?? this.offer,
      details: details ?? this.details,
      freeCancellation: freeCancellation ?? this.freeCancellation,
      freeCancellationDate: freeCancellationDate ?? this.freeCancellationDate,
      imageUrl: image ?? this.imageUrl,
      numberOfRooms: numberOfRooms ?? this.numberOfRooms,
      availableRooms: availableRooms ?? this.availableRooms,
    );
  }
}




