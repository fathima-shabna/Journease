
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:journease/hotelorpackagemodule/firebase/propertylistingfb.dart';
import 'package:journease/hotelorpackagemodule/listproperty.dart';
import 'package:journease/hotelorpackagemodule/models/propertyModel.dart';
import 'package:journease/hotelorpackagemodule/propertyModel.dart';

class PropertyListingPage extends StatefulWidget {
  final String? userId;

  const PropertyListingPage({super.key, required this.userId});
  @override
  _PropertyListingPageState createState() => _PropertyListingPageState();
}

class _PropertyListingPageState extends State<PropertyListingPage> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService(); // Instance of FirestoreService

  // List to store room data dynamically
  List<Map<String, dynamic>> rooms = [
    {
      'title': '', 
      'size': '', 
      'view': '', 
      'bedType': '', 
      'roomType': 'Single', // Default value for Room Type
      'price': '', 
      'description': '', 
      'offer': '', 
      'details': '', 
      'freeCancellation': 'No', // Default value for free cancellation
      'freeCancellationDate': null, // Holds the date if free cancellation is "Yes"
      'imageUrl': null,
      'numberOfRooms': 1, // Number of rooms default to 1
      'availableRooms': 1,
    },
  ];

  final ImagePicker _picker1 = ImagePicker();

  // Function to add a new room
  void _addRoom() {
  final TextEditingController roomTitle1controller = TextEditingController();
  final TextEditingController roomSize1controller = TextEditingController();
  final TextEditingController roomView1controller = TextEditingController();
  final TextEditingController roomBed1controller = TextEditingController();
  final TextEditingController roomPrice1controller = TextEditingController();
  final TextEditingController roomDescription1controller = TextEditingController();
  final TextEditingController roomOffer1controller = TextEditingController();
  final TextEditingController roomAdditional1controller = TextEditingController();
    setState(() {
      rooms.add({
        'title': roomTitle1controller,
        'size': roomSize1controller,
        'view': roomView1controller,
        'bedType': roomBed1controller,
        'roomType': 'Single', // Default value for Room Type
        'price': roomPrice1controller,
        'description': roomDescription1controller,
        'offer': roomOffer1controller,
        'details': roomAdditional1controller,
        'freeCancellation': 'No', // Default value for free cancellation
        'freeCancellationDate': null, // Holds the date if free cancellation is "Yes"
        'imageUrl': null,
        'numberOfRooms': 1, // Number of rooms default to 1
        'availableRooms': 1,
      });
    });
     // Clear the controllers
  roomTitle1controller.clear();
  roomSize1controller.clear();
  roomView1controller.clear();
  roomBed1controller.clear();
  roomPrice1controller.clear();
  roomDescription1controller.clear();
  roomOffer1controller.clear();
  roomAdditional1controller.clear();
  }

  // Function to remove a room
  void _removeRoom(int index) {
    setState(() {
      rooms.removeAt(index);
    });
  }
  // Function to pick a date for free cancellation
  Future<void> _pickFreeCancellationDate(int index) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        rooms[index]['freeCancellationDate'] = pickedDate;
      });
    }
  }



  // Controllers for text fields
  final TextEditingController propertyNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();
  final TextEditingController amenitiesController = TextEditingController();
  final TextEditingController attractionsController = TextEditingController();
  final TextEditingController roomTitlecontroller = TextEditingController();
  final TextEditingController roomSizecontroller = TextEditingController();
  final TextEditingController roomViewcontroller = TextEditingController();
  final TextEditingController roomBedcontroller = TextEditingController();
  final TextEditingController roomPricecontroller = TextEditingController();
  final TextEditingController roomDescriptioncontroller = TextEditingController();
  final TextEditingController roomOffercontroller = TextEditingController();
  final TextEditingController roomAdditionalcontroller = TextEditingController();
  final TextEditingController licenseController = TextEditingController();

  TimeOfDay? checkInTime;
  TimeOfDay? checkOutTime;

    List<String> roomCategory = ['Hotel', 'Resort', 'Apartment','Villa','Guesthouse'];
  String selectedroomCategory = 'Resort';

  // Dropdown and Checkboxes data
  List<String> roomTypes = ['Single', 'Double', 'Suite'];
  String selectedRoomType = 'Single';
  // Map<String, bool> amenities = {
  //   'Wi-Fi': false,
  //   'Pool': false,
  //   'Gym': false,
  //   'Parking': false,
  //   'Restaurant': false,
  // };



   // Function to pick image for a room
  Future<void> _pickImage1(int index) async {
    final XFile? pickedImage1 = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage1 != null) {
      File imageFile = File(pickedImage1.path);
      setState(() {
        rooms[index]['image'] = imageFile;
      });

      String? imageUrl = await uploadFile(imageFile);
      if (imageUrl != null) {
        setState(() {
          rooms[index]['imageUrl'] = imageUrl;
        });
      }
    }
  }

// Image picker variables
List<String> selectedImageUrls = []; // Store download URLs instead of File objects

final ImagePicker _picker = ImagePicker();

// Function to pick and upload multiple images
Future<void> _pickImage() async {
  final List<XFile>? images = await _picker.pickMultiImage();
  if (images != null && images.isNotEmpty) {
    for (XFile image in images) {
      // Upload each image and get the download URL
      String? downloadUrl = await uploadFile(File(image.path));
      if (downloadUrl != null) {
        setState(() {
          selectedImageUrls.add(downloadUrl); // Add the URL to the list
        });
      }
    }
  }
}

// Firebase File Upload
Future<String?> uploadFile(File file) async {
  try {
    // Reference to Firebase Storage with a unique path
    final storageRef = FirebaseStorage.instance.ref().child('uploads/${file.path.split('/').last}');
    
    // Upload the file
    final uploadTask = storageRef.putFile(file);

    // Listen to task events and handle progress, errors, etc.
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      setState(() {
        // Update progress or show loading indicator if needed
      });
    });

    await uploadTask.whenComplete(() {
      print("Upload completed");
    });

    // Get download URL to store in Firestore or use later
    String downloadUrl = await storageRef.getDownloadURL();
    print("File uploaded successfully. Download URL: $downloadUrl");
    
    // Return the download URL
    return downloadUrl;
  } catch (e) {
    print('Error during file upload: $e');
    return null; // Return null in case of an error
  }
}




  PlatformFile? _pickedFile; // Keeps track of the selected file

Future<void> _pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null && result.files.isNotEmpty) {
    _pickedFile = result.files.first;

    File file = File(_pickedFile!.path!);
    
    // Upload the selected file
    String? fileUrl = await uploadFile(file);
    if (fileUrl != null) {
      print("File uploaded successfully: $fileUrl");
    }
  }
}


  // Function to pick time
  Future<void> _selectTime(BuildContext context, bool isCheckIn) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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

  // Format time for display
  String _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    final now = DateTime.now();
    final formattedTime = DateFormat.jm().format(DateTime(now.year, now.month, now.day, time.hour, time.minute));
    return formattedTime;
  }


Future<void> submitForm() async{
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
      propertyId: '', 
      hostId: widget.userId!,
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
      category: selectedroomCategory,
      images: selectedImageUrls, // List of image URLs
      rooms: roomList, // List of RoomModel objects
    );

           try {
        // Add property under the user's document
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId) // Use the userId
            .collection('properties')
            .add(property.toMap());

        
      // Now, update the property with the generated propertyId
      String newPropertyId = docRef.id;
      await docRef.update({'propertyId': newPropertyId});

      // Update local property object with the propertyId
      property = property.copyWith(propertyId: newPropertyId);
        Navigator.pop(context, property.propertyId);
      } catch (error) {
        print("Error creating property listing: $error");
      }
  } 
}
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Your Property',style: TextStyle(fontSize: 16),),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: submitForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Section
              _sectionHeader('Basic Information'),
              _buildTextField(propertyNameController, 'Property Name'),
              _buildTextField(descriptionController, 'Description', maxLines: 3),
              _buildDropdown('Category', roomCategory, selectedroomCategory, (String? value) {
                setState(() {
                  selectedroomCategory = value!;
                });
              }),
              _buildTextField(licenseController, 'License number'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ID proof', style: TextStyle(fontSize: 16)),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: Icon(Icons.add_a_photo),
                  label: Text('Select file'),
                ),
              ],
            ),
            _pickedFile != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child:   _pickedFile != null
                  ? Text('Selected file: ${_pickedFile!.name}')
                  : Text('No file selected.'),                  
                  )
                : Container(),
              
              // Location Section
              _sectionHeader('Location'),
              _buildTextField(addressController, 'Address'),
              _buildTextField(cityController, 'City'),
              _buildTextField(countryController, 'Country'),
              _buildTextField(attractionsController, 'Nearby Attractions',maxLines: 2),
              
              // Room & Pricing Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionHeader('Rooms & Pricing'),
                  ElevatedButton.icon(
                onPressed: _addRoom,
                icon: Icon(Icons.add),
                label: Text('Add a Room'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
                ],
              ),
              // _buildDropdown('Room Type', roomTypes, selectedRoomType, (String? value) {
              //   setState(() {
              //     selectedRoomType = value!;
              //   });
              // }),
              // _buildTextField(priceController, 'Price per Night', keyboardType: TextInputType.number),
              Column(
            children: [
              // List of room containers
              ..._buildRoomContainers(),

              // SizedBox(height: 20), // Spacer

            ],
          ),
               // Check-In / Check-Out
              _sectionHeader('Check-In & Check-Out Times'),
              Row(
                children: [
                  Expanded(
                    child: _buildTimePicker('Check-In Time', checkInTime, () => _selectTime(context, true)),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildTimePicker('Check-Out Time', checkOutTime, () => _selectTime(context, false)),
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

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Submit Listing', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable section header
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Reusable text field widget
  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  // Reusable dropdown widget
  Widget _buildDropdown(String label, List<String> options, String selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: onChanged,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
      ),
    );
  }

  // Time picker widget
  Widget _buildTimePicker(String label, TimeOfDay? time, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: Icon(Icons.access_time),
          ),
          controller: TextEditingController(text: _formatTimeOfDay(time)),
          validator: (value) {
            if (time == null) {
              return 'Please select $label';
            }
            return null;
          },
        ),
      ),);
  }

  // Checklist for amenities
  // Widget _buildAmenitiesChecklist() {
  //   return Column(
  //     children: amenities.keys.map((String key) {
  //       return CheckboxListTile(
  //         title: Text(key),
  //         value: amenities[key],
  //         onChanged: (bool? value) {
  //           setState(() {
  //             amenities[key] = value!;
  //           });
  //         },
  //       );
  //     }).toList(),
  //   );
  // }

  // Image picker section
  Widget _buildImagePicker() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selected Images',
              style: TextStyle(fontSize: 16),
            ),
            TextButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.add_a_photo),
              label: Text('Add Images'),
            ),
          ],
        ),
        selectedImageUrls.isEmpty
            ? Text(
                'No images selected.',
                style: TextStyle(color: Colors.grey),
              )
            : Wrap(
                spacing: 10,
                runSpacing: 10,
                children: selectedImageUrls.map((image) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

  List<Widget> _buildRoomContainers() {
    return List.generate(rooms.length, (index) {
      return _buildRoomContainer(index);
    });
  }

  // Build the room details container for each room
  Widget _buildRoomContainer(int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close button to remove room
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Room ${index + 1}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    _removeRoom(index);
                  },
                ),
              ],
            ),
            
            // Room title field
            _buildTextField1('Room Title', (value) => rooms[index]['title'] = value,roomTitlecontroller),
            
            // Room size, view, and bed type fields
            Row(
              children: [
                Expanded(child: _buildTextField1('Room Size (sqm)', (value) => rooms[index]['size'] = value,roomSizecontroller)),
                SizedBox(width: 10),
                Expanded(child: _buildTextField1('Room View', (value) => rooms[index]['view'] = value,roomViewcontroller)),
              ],
            ),
            _buildTextField1('Type of Bed', (value) => rooms[index]['bedType'] = value,roomBedcontroller),

            // Room type dropdown
            _buildRoomTypeDropdown(index),

            // Number of rooms dropdown inside each container
            _buildRoomCountDropdown(index),
            _buildAvailableRoomsDropdown(index),

            // Price and description fields
            _buildTextField1('Price', (value) => rooms[index]['price'] = value,roomPricecontroller, keyboardType: TextInputType.number),
            _buildTextField1('Description', (value) => rooms[index]['description'] = value,roomDescriptioncontroller, maxLines: 2),
            
            // Offer and additional details
            _buildTextField1('Offer', (value) => rooms[index]['offer'] = value,roomOffercontroller),
            _buildTextField1('Additional Details', (value) => rooms[index]['details'] = value,roomAdditionalcontroller),

            // Free Cancellation dropdown and date picker
            _buildFreeCancellationDropdown(index),
            SizedBox(height: 10,),

            // Room image upload
            Row(
              children: [
                Text('Room Image:', style: TextStyle(fontSize: 16)),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _pickImage1(index),
                  icon: Icon(Icons.add_a_photo),
                  label: Text('Upload Image'),
                ),
              ],
            ),
            rooms[index]['image'] != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Image.file(
                      rooms[index]['image'],
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  // Room Type Dropdown Widget
  Widget _buildRoomTypeDropdown(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        value: rooms[index]['roomType'],
        items: ['Single', 'Double', 'Suite'].map((String roomType) {
          return DropdownMenuItem<String>(
            value: roomType,
            child: Text(roomType),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            rooms[index]['roomType'] = newValue!;
          });
        },
        decoration: InputDecoration(
          labelText: 'Room Type',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // Number of Rooms Dropdown Widget
  Widget _buildRoomCountDropdown(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<int>(
        value: rooms[index]['numberOfRooms'],
        items: List.generate(20, (i) => i + 1).map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value Room(s)'),
          );
        }).toList(),
        onChanged: (int? newValue) {
          setState(() {
            rooms[index]['numberOfRooms'] = newValue!;
          });
        },
        decoration: InputDecoration(
          labelText: 'Number of Rooms',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // Available Rooms Dropdown Widget
  Widget _buildAvailableRoomsDropdown(int index1) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<int>(
        value: rooms[index1]['availableRooms'],
        items: List.generate(20, (a) => a + 1).map((int value1) {
          return DropdownMenuItem<int>(
            value: value1,
            child: Text('$value1 Room(s)'),
          );
        }).toList(),
        onChanged: (int? newValue1) {
          setState(() {
            rooms[index1]['availableRooms'] = newValue1!;
          });
        },
        decoration: InputDecoration(
          labelText: 'Available Rooms',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }


  // Free Cancellation Dropdown and Date Picker
  Widget _buildFreeCancellationDropdown(int index) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: rooms[index]['freeCancellation'],
          items: ['Yes', 'No'].map((String cancellationOption) {
            return DropdownMenuItem<String>(
              value: cancellationOption,
              child: Text(cancellationOption),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              rooms[index]['freeCancellation'] = newValue!;
            });
          },
          decoration: InputDecoration(
            labelText: 'Free Cancellation',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        if (rooms[index]['freeCancellation'] == 'Yes')
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: GestureDetector(
              onTap: () => _pickFreeCancellationDate(index),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Free Cancellation Before',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  controller: TextEditingController(
                    text: rooms[index]['freeCancellationDate'] != null
                        ? "${rooms[index]['freeCancellationDate'].day}/${rooms[index]['freeCancellationDate'].month}/${rooms[index]['freeCancellationDate'].year}"
                        : '',
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Reusable text field widget
  Widget _buildTextField1(String label, ValueChanged<String> onChanged,TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        controller: controller,
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

}

List<PropertyModel> propertydetails = [];
