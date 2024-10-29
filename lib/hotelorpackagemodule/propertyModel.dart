// import 'dart:io';

// import 'package:file_picker/file_picker.dart';

// class PropertyModel {
//   String name;
//   String description;
//   String license;
//   PlatformFile? idproof;
//   String address;
//   String city;
//   String country;
//   String nearbyAttractions;
//   String checkInTime;
//   String checkOutTime;
//   String amenities;
//   String category;
//   List<File> images;
//   List<RoomModel> rooms;

//   PropertyModel({
//     required this.name,
//     required this.description,
//     required this.license,
//     required this.idproof,
//     required this.address,
//     required this.city,
//     required this.country,
//     required this.nearbyAttractions,
//     required this.checkInTime,
//     required this.checkOutTime,
//     required this.amenities,
//     required this.category,
//     required this.images,
//     required this.rooms,
//   });

//   // Convert PropertyModel to JSON for submission or saving
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'description': description,
//       'license': license,
//       'idproof': idproof?.path,
//       'address': address,
//       'city': city,
//       'country': country,
//       'nearbyAttractions': nearbyAttractions,
//       'checkInTime': checkInTime,
//       'checkOutTime': checkOutTime,
//       'amenities': amenities,
//       'category': category,
//       'images': images.map((image) => image.path).toList(), // Storing image paths
//       'rooms': rooms.map((room) => room.toJson()).toList(),
//     };
//   }
// }

// class RoomModel {
//   String title;
//   String size;
//   String view;
//   String bedType;
//   String roomType;
//   String price;
//   String description;
//   String offer;
//   String details;
//   String freeCancellation;
//   DateTime? freeCancellationDate;
//   File? image;
//   int numberOfRooms;
//   int availableRooms;

//   RoomModel({
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
//     this.freeCancellationDate,
//     this.image,
//     required this.numberOfRooms,
//     required this.availableRooms
//   });

//   // Convert RoomModel to JSON for submission or saving
//   Map<String, dynamic> toJson() {
//     return {
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
//       'freeCancellationDate': freeCancellationDate?.toIso8601String(),
//       'image': image?.path, // Storing image path
//       'numberOfRooms': numberOfRooms,
//       'availableRooms': availableRooms
//     };
//   }
// }
