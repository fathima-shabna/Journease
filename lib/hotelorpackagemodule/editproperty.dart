import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:journease/hotelorpackagemodule/models/propertyModel.dart';
import 'package:journease/hotelorpackagemodule/firebase/propertylistingfb.dart';

class EditPropertyListingPage extends StatefulWidget {
  final String userId;
  final String propertyId; // Pass propertyId to retrieve specific property details

  const EditPropertyListingPage({
    super.key,
    required this.userId,
    required this.propertyId,
  });

  @override
  _EditPropertyListingPageState createState() => _EditPropertyListingPageState();
}

class _EditPropertyListingPageState extends State<EditPropertyListingPage> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService(); // Instance of FirestoreService

  List<Map<String, dynamic>> rooms = [];
  final ImagePicker _picker = ImagePicker();
  List<String> selectedImageUrls = [];
  PlatformFile? _pickedFile;

  // Controllers for text fields
  final TextEditingController propertyNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController amenitiesController = TextEditingController();
  final TextEditingController attractionsController = TextEditingController();
  final TextEditingController cancellationDateController = TextEditingController(); // For Free Cancellation Date
    final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();
  

  TimeOfDay? checkInTime;
  TimeOfDay? checkOutTime;
  String selectedRoomCategory = 'Resort';
  

  // Dropdown data
  List<String> roomCategory = ['Hotel', 'Resort', 'Apartment', 'Villa', 'Guesthouse'];
  List<int> numberOfRoomsOptions = List.generate(20, (index) => index + 1); // 1 to 20
  List<int> availableRoomsOptions = List.generate(20, (index) => index + 1); // 1 to 20
  List<String> freeCancellationOptions = ['Yes', 'No']; // Free cancellation options

  @override
  void initState() {
    super.initState();
    _loadPropertyDetails();
  }

  // Load property details from Firestore
  Future<void> _loadPropertyDetails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('properties')
          .doc(widget.propertyId)
          .get();

      if (doc.exists) {
        PropertyModel property = PropertyModel.fromMap(doc.data() as Map<String, dynamic>);
        propertyNameController.text = property.propertyName;
        descriptionController.text = property.description;
        addressController.text = property.address;
        cityController.text = property.city;
        countryController.text = property.country;
        licenseController.text = property.license;
        amenitiesController.text = property.amenities;
        attractionsController.text = property.attractions;
        checkInController.text = property.checkInTime;
        checkOutController.text =property.checkOutTime;
        

        // Load rooms
        rooms = property.rooms.map((room) {
          return {
            'title': room.title,
            'size': room.size,
            'view': room.view,
            'bedType': room.bedType,
            'roomType': room.roomType,
            'price': room.price,
            'description': room.description,
            'offer': room.offer,
            'details': room.details,
            'freeCancellation': room.freeCancellation,
            'freeCancellationDate': room.freeCancellationDate != null
                ? DateTime.parse(room.freeCancellationDate!)
                : null,
            'imageUrl': room.imageUrl,
            'numberOfRooms': room.numberOfRooms,
            'availableRooms': room.availableRooms,
          };
        }).toList();

        // Load images
        selectedImageUrls = property.images;

        // Load check-in and check-out times
        if (property.checkInTime != null) {
          final time = TimeOfDay.fromDateTime(DateFormat.jm().parse(property.checkInTime!));
          setState(() {
            checkInTime = time;
          });
        }
        if (property.checkOutTime != null) {
          final time = TimeOfDay.fromDateTime(DateFormat.jm().parse(property.checkOutTime!));
          setState(() {
            checkOutTime = time;
          });
        }
      }
    } catch (error) {
      print("Error loading property details: $error");
    }
  }

  // Function to submit the updated form
  Future<void> submitForm() async {
  if (_formKey.currentState!.validate()) {
    // Create the list of RoomModel objects from the room data
    List<RoomModel> roomList = rooms.map((room) {
      return RoomModel(
        rid: room['title'],
        title: room['title'],
        size: room['size'],
        view: room['view'],
        bedType: room['bedType'],
        roomType: room['roomType'],
        price: room['price'],
        description: room['description'],
        offer: room['offer'],
        details: room['details'],
        freeCancellation: room['freeCancellation'],
        freeCancellationDate: room['freeCancellationDate']?.toString(),
        imageUrl: room['imageUrl'],
        numberOfRooms: room['numberOfRooms'],
        availableRooms: room['availableRooms'],
      );
    }).toList();

    // Create a PropertyModel instance with the collected data
    PropertyModel property = PropertyModel(
      propertyId: widget.propertyId,
      hostId: widget.userId,
      propertyName: propertyNameController.text,
      description: descriptionController.text,
      license: licenseController.text,
      address: addressController.text,
      city: cityController.text,
      country: countryController.text,
      checkInTime: _formatTimeOfDay(checkInTime),
      checkOutTime: _formatTimeOfDay(checkOutTime),
      amenities: amenitiesController.text,
      attractions: attractionsController.text,
      category: selectedRoomCategory,
      images: selectedImageUrls,
      rooms: roomList,
    );

    try {
      // Update the property in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('properties')
          .doc(widget.propertyId)
          .update(property.toMap());

      Navigator.pop(context, property.propertyId);
    } catch (error) {
      print("Error updating property listing: $error");
    }
  }
}

  // Function to pick images
  Future<void> _pickImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      for (XFile image in images) {
        String? downloadUrl = await uploadFile(File(image.path));
        if (downloadUrl != null) {
          setState(() {
            selectedImageUrls.add(downloadUrl);
          });
        }
      }
    }
  }

  // Firebase File Upload
  Future<String?> uploadFile(File file) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('uploads/${file.path.split('/').last}');
      final uploadTask = storageRef.putFile(file);
      await uploadTask;
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error during file upload: $e');
      return null; // Return null in case of an error
    }
  }

  // Function to pick a file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      _pickedFile = result.files.first;
      File file = File(_pickedFile!.path!);
      String? fileUrl = await uploadFile(file);
      if (fileUrl != null) {
        print("File uploaded successfully: $fileUrl");
      }
    }
  }

  // Format time for display
  String _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    final now = DateTime.now();
    final formattedTime = DateFormat.jm().format(DateTime(now.year, now.month, now.day, time.hour, time.minute));
    return formattedTime;
  }

  // Format date for display
  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return DateFormat.yMMMd().format(date);
  }

  // Function to show DatePicker
  Future<void> _selectDate(BuildContext context, {required bool isCancellationDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCancellationDate ? (rooms.first['freeCancellationDate'] ?? DateTime.now()) : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isCancellationDate ? rooms.first['freeCancellationDate'] : DateTime.now())) {
      setState(() {
        if (isCancellationDate) {
          cancellationDateController.text = _formatDate(picked);
          rooms.first['freeCancellationDate'] = picked; // Update the room's free cancellation date
        }
      });
    }
  }

  // Add this function to handle image updates for rooms
Future<void> _editRoomImage(int index) async {
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    String? downloadUrl = await uploadFile(File(image.path));
    if (downloadUrl != null) {
      setState(() {
        rooms[index]['imageUrl'] = downloadUrl; // Update the room's image URL
      });
    }
  }
}

  // Build form UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Property Listing'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: submitForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Property Name
              _buildTextField(propertyNameController, 'Property Name'),
              _buildTextField(descriptionController, 'Description', maxLines: 2),
              _buildDropdown('Room Category', roomCategory, selectedRoomCategory, (value) {
                setState(() {
                  selectedRoomCategory = value ?? roomCategory[0];
                });
              }),

              // License Upload Section
              // _buildTextField(licenseController, 'License'),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     IconButton(
              //       icon: Icon(Icons.file_upload),
              //       onPressed: _pickFile,
              //     ),
              //   ],
              // ),

              // Location Section
              // _sectionHeader('Location'),
              // _buildTextField(addressController, 'Address'),
              // _buildTextField(cityController, 'City'),
              // _buildTextField(countryController, 'Country'),
              _buildTextField(attractionsController, 'Nearby Attractions', maxLines: 2),

              // Room & Pricing Section
              _sectionHeader('Rooms & Pricing'),
              Column(
                children: _buildRoomContainers(),
              ),

              // Check-In / Check-Out Times
              _sectionHeader('Check-In & Check-Out Times'),
              Row(
                children: [
                  Expanded(
                    child: _buildTimePicker('Check-In Time', checkInTime, () => _selectTime(context, true),checkInController),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildTimePicker('Check-Out Time', checkOutTime, () => _selectTime(context, false),checkOutController),
                  ),
                ],
              ),

              // Amenities Section
              _sectionHeader('Amenities'),
              _buildTextField(amenitiesController, 'Description', maxLines: 5),

              // Image Upload Section
              _sectionHeader('Property Images'),
              _buildImagePicker(),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Function to select a time
  Future<void> _selectTime(BuildContext context, bool isCheckIn) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isCheckIn ? (checkInTime ?? TimeOfDay.now()) : (checkOutTime ?? TimeOfDay.now()),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInTime = picked;
        } else {
          checkOutTime = picked;
        }
      });
    }
  }

  // Function to build text fields
  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  // Function to build dropdown
  Widget _buildDropdown(String label, List<String> items, String selectedValue, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: selectedValue,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select $label';
        }
        return null;
      },
    );
  }

  // Function to build the time picker
  Widget _buildTimePicker(String label, TimeOfDay? time, VoidCallback onTap, TextEditingController controller) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: label, hintText: _formatTimeOfDay(time)),
          validator: (value) {
            if (time == null) {
              return 'Please select a time';
            }
            return null;
          },
        ),
      ),
    );
  }

  // Function to build the date picker for Free Cancellation Date
  Widget _buildCancellationDatePicker() {
    return GestureDetector(
      onTap: () => _selectDate(context, isCancellationDate: true),
      child: AbsorbPointer(
        child: TextFormField(
          controller: cancellationDateController,
          decoration: InputDecoration(labelText: 'Free Cancellation Date', hintText: 'Select Date'),
          validator: (value) {
            if (cancellationDateController.text.isEmpty) {
              return 'Please select a cancellation date';
            }
            return null;
          },
        ),
      ),
    );
  }

  // Function to build the image picker
  Widget _buildImagePicker() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: selectedImageUrls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.network(
                  selectedImageUrls[index],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: _pickImage,
          child: Text('Upload Images'),
        ),
      ],
    );
  }

  // Function to build section headers
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  // Function to build room containers
  List<Widget> _buildRoomContainers() {
    List<Widget> roomWidgets = [];
    for (var room in rooms) {
      roomWidgets.add(Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                TextEditingController(text: room['title']),
                'Room Title',
              ),
              _buildTextField(
                TextEditingController(text: room['size']),
                'Room Size',
              ),
              _buildTextField(
                TextEditingController(text: room['view']),
                'View',
              ),
              _buildTextField(
                TextEditingController(text: room['bedType']),
                'Bed Type',
              ),
              _buildTextField(
                TextEditingController(text: room['roomType']),
                'Room Type',
              ),
              _buildTextField(
                TextEditingController(text: room['price']),
                'Price',
              ),
              _buildTextField(
                TextEditingController(text: room['description']),
                'Description',
              ),
              _buildTextField(
                TextEditingController(text: room['offer']),
                'Offer',
              ),
              _buildTextField(
                TextEditingController(text: room['details']),
                'Details',
              ),
              _buildDropdown(
                'Free Cancellation',
                freeCancellationOptions,
                room['freeCancellation'] ?? 'No',
                (value) {
                  setState(() {
                    room['freeCancellation'] = value;
                    // If "Yes" is selected, set cancellation date controller to existing date or empty
                    if (value == 'Yes') {
                      cancellationDateController.text = _formatDate(room['freeCancellationDate']);
                    } else {
                      cancellationDateController.clear(); // Clear if "No" is selected
                    }
                  });
                },
              ),
              if (room['freeCancellation'] == 'Yes') _buildCancellationDatePicker(),
              _buildDropdown(
                'Number of Rooms',
                numberOfRoomsOptions.map((e) => e.toString()).toList(),
                room['numberOfRooms'].toString(),
                (value) {
                  setState(() {
                    room['numberOfRooms'] = int.tryParse(value!);
                  });
                },
              ),
              _buildDropdown(
                'Available Rooms',
                availableRoomsOptions.map((e) => e.toString()).toList(),
                room['availableRooms'].toString(),
                (value) {
                  setState(() {
                    room['availableRooms'] = int.tryParse(value!);
                  });
                },
              ),
              SizedBox(height: 10),
              Image.network(room['imageUrl'] ?? '', width: 100, height: 100, fit: BoxFit.cover),
            ],
          ),
        ),
      ));
    }
    return roomWidgets;
  }
}
