import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:journease/usermodule/screens/reviewhotelbooking.dart';

class HotelSelectionScreen extends StatefulWidget {
  final String propertyId;
  final String propertyName;
  final String propertyCity;
  final String selectedPlace;
  final String checkInDate;
  final String checkOutDate;
  final int rooms;
  final int guests;
  final int children;

  const HotelSelectionScreen({Key? key, 
  required this.propertyId, 
  required this.selectedPlace, 
  required this.checkInDate, 
  required this.checkOutDate, 
  required this.rooms, 
  required this.guests, 
  required this.children, 
  required this.propertyName, 
  required this.propertyCity}) : super(key: key);

  @override
  State<HotelSelectionScreen> createState() => _HotelSelectionScreenState();
}

class _HotelSelectionScreenState extends State<HotelSelectionScreen> {
  int? selectedRoomIndex;
  String selectedRoomPrice = '';
  String selectedroomTitle = '';
  List<dynamic>? roomsList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    try {
      // Fetch the specific property and its room list using the propertyId from Firestore
      DocumentSnapshot<Map<String, dynamic>> propertySnapshot = await FirebaseFirestore.instance
          .collectionGroup('properties')
          .where('propertyId', isEqualTo: widget.propertyId)
          .get()
          .then((snapshot) => snapshot.docs.first);

      if (propertySnapshot.exists) {
        setState(() {
          roomsList = propertySnapshot.data()?['rooms'];
          isLoading = false;
        });
      } else {
        print("Property does not exist.");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching rooms: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 224, 230),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_rounded)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Room",style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
            Text("${widget.checkInDate} - ${widget.checkOutDate} | ${widget.rooms} room(s), ${widget.guests} guest(s), ${widget.guests} children(s)",style: TextStyle(fontSize: 12,overflow: TextOverflow.fade),),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.edit),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : roomsList == null
              ? const Center(child: Text('No rooms available'))
              : HotelRoomList(
                  roomsList: roomsList!,
                  selectedRoomIndex1: selectedRoomIndex,
                  onRoomSelected: (index, price, roomtitle) {
                    setState(() {
                      selectedRoomIndex = index;
                      selectedRoomPrice = price;
                      selectedroomTitle = roomtitle;
                    });
                  },
                ),
      bottomNavigationBar: BottomAppBar(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedRoomPrice.isNotEmpty ? "₹${selectedRoomPrice} (per night)" : "₹ 0 (per night)",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const Text(
                    "taxes and service fees",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 222, 121, 90)),
                onPressed: selectedRoomIndex != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReviewBookingPage(propertyId: widget.propertyId,selectedRoomPrice: selectedRoomPrice,selectedPlace: widget.selectedPlace,checkInDate: widget.checkInDate,checkOutDate: widget.checkOutDate,rooms: widget.rooms,guests: widget.guests,children: widget.children,roomtitle: selectedroomTitle,propertyCity: widget.propertyCity,propertyName: widget.propertyName,)),
                        );
                      }
                    : null,
                child: const Text("CONTINUE", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HotelRoomList extends StatelessWidget {
  final Function(int, String, String) onRoomSelected;
  final int? selectedRoomIndex1;
  final List<dynamic> roomsList;

  const HotelRoomList({super.key, required this.onRoomSelected, required this. selectedRoomIndex1, required this.roomsList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: roomsList.length,
      itemBuilder: (context, index) {
        var room = roomsList[index];
        bool isSelected = index == selectedRoomIndex1;
        return _buildRoomCard(
          title: room['title'],
          image: room['imageUrl'],
          size: room['size'],
          view: room['view'],
          bed: room['bedType'],
          price: room['price'],
          description: room['description'],
          offer: room['offer'],
          additionalDetails: room['details'],
          isSelected: isSelected,
          freeCancellation: room['freeCancellation'],
          availableRooms: room['availableRooms'],
          onSelect: () => onRoomSelected(index, room['price'],room['title']),
        );
      },
    );
  }

  Widget _buildRoomCard({
    required String title,
    required String image,
    required String size,
    required String view,
    required String bed,
    required String price,
    required String description,
    required String offer,
    String? additionalDetails,
    required bool isSelected,
    required String freeCancellation,
    required int availableRooms,
    required VoidCallback onSelect,
  }) {
    bool isRoomAvailable = availableRooms > 0;
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(image, width: 150, height: 150, fit: BoxFit.cover),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(size),
                    Text(view),
                    Text(bed),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(description, style: TextStyle(color: Colors.grey[600])),
            Text(offer, style: TextStyle(color: Colors.grey[600])),
            if (additionalDetails != null) ...[
              const SizedBox(height: 10),
              Text(additionalDetails, style: TextStyle(color: Colors.grey[600])),
            ],
            const SizedBox(height: 10),
            Text('Free cancellation: $freeCancellation', style: TextStyle(color: Colors.green[700], fontSize: 12)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('₹$price',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                ),
                ElevatedButton(
                  onPressed: onSelect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRoomAvailable? isSelected ? const Color.fromARGB(255, 222, 121, 90) : Colors.grey: Colors.grey
                  ),
                  child: Text(isRoomAvailable ? (isSelected ? "Selected" : "Select") : "No Rooms Available", style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
