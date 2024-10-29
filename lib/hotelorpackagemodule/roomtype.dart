import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RoomListingPage extends StatefulWidget {
  @override
  _RoomListingPageState createState() => _RoomListingPageState();
}

class _RoomListingPageState extends State<RoomListingPage> {
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
      'image': null,
      'numberOfRooms': 1 // Number of rooms default to 1
    },
  ];

  final ImagePicker _picker1 = ImagePicker();

  // Function to add a new room
  void _addRoom() {
    setState(() {
      rooms.add({
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
        'image': null,
        'numberOfRooms': 1 // Number of rooms default to 1
      });
    });
  }

  // Function to remove a room
  void _removeRoom(int index) {
    setState(() {
      rooms.removeAt(index);
    });
  }

  // Function to pick image for a room
  Future<void> _pickImage1(int index) async {
    final XFile? pickedImage1 = await _picker1.pickImage(source: ImageSource.gallery);
    if (pickedImage1 != null) {
      setState(() {
        rooms[index]['image'] = File(pickedImage1.path);
      });
    }
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

  // Function to submit the form and process the room data
  void _submitRooms() {
    print('Rooms Submitted: $rooms');
    // Process the form data here, e.g., submit to a backend or further processing
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submission Successful'),
          content: Text('You have submitted ${rooms.length} room(s).'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Rooms'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // List of room containers
              ..._buildRoomContainers(),

              // Add Room button
              ElevatedButton.icon(
                onPressed: _addRoom,
                icon: Icon(Icons.add),
                label: Text('Add a Room'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              SizedBox(height: 20), // Spacer

              // Submit Button
              ElevatedButton(
                onPressed: _submitRooms,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build list of room containers dynamically
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
            _buildTextField1('Room Title', (value) => rooms[index]['title'] = value),
            
            // Room size, view, and bed type fields
            Row(
              children: [
                Expanded(child: _buildTextField1('Room Size (sqm)', (value) => rooms[index]['size'] = value)),
                SizedBox(width: 10),
                Expanded(child: _buildTextField1('Room View', (value) => rooms[index]['view'] = value)),
              ],
            ),
            _buildTextField1('Type of Bed', (value) => rooms[index]['bedType'] = value),

            // Room type dropdown
            _buildRoomTypeDropdown(index),

            // Number of rooms dropdown inside each container
            _buildRoomCountDropdown(index),

            // Price and description fields
            _buildTextField1('Price', (value) => rooms[index]['price'] = value, keyboardType: TextInputType.number),
            _buildTextField1('Description', (value) => rooms[index]['description'] = value, maxLines: 2),
            
            // Offer and additional details
            _buildTextField1('Offer', (value) => rooms[index]['offer'] = value),
            _buildTextField1('Additional Details', (value) => rooms[index]['details'] = value),

            // Free Cancellation dropdown and date picker
            _buildFreeCancellationDropdown(index),

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
        items: List.generate(10, (i) => i + 1).map((int value) {
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
  Widget _buildTextField1(String label, ValueChanged<String> onChanged,
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
        onChanged: onChanged,
      ),
    );
  }
}
