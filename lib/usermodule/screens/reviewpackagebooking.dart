import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journease/usermodule/screens/packagepayment.dart';

class ReviewPage extends StatefulWidget {
  final bool withflight1;
  final String selectedvalue;
  final String selectedvalue2;
  final int rooms;
  final int adults;
  final int children;
  final DateTime startingDate;
  final String packageId;
  final String userId;
  

  const ReviewPage({
    super.key,
    required this.selectedvalue,
    required this.selectedvalue2,
    required this.rooms,
    required this.adults,
    required this.startingDate,
    required this.packageId,
    required this.userId,
    required this.children, required this.withflight1,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  List<Map<String, dynamic>> _travellerDetails = [];
   Map<String, dynamic>? packageData;

  @override
  void initState() {
    super.initState();
    _initializeTravellerDetails();
    _fetchPackageDetails();
  }

  void _initializeTravellerDetails() {
    // Initialize traveller details list with empty values for each traveller
    for (int i = 0; i < widget.adults + widget.children; i++) {
      _travellerDetails.add({'fullName': '', 'age': 0, 'gender': 'Male'});
    }
  }

  Future<void> _fetchPackageDetails() async {
    try {
      // Fetch package details from Firestore using the packageId
      DocumentSnapshot packageSnapshot = await FirebaseFirestore.instance
          .collection('packages')
          .doc(widget.packageId)
          .get();

      if (packageSnapshot.exists) {
        setState(() {
          packageData = packageSnapshot.data() as Map<String, dynamic>;
        });
        //  packageData = packageSnapshot.data() as Map<String, dynamic>;
        // Process the fetched package details if needed
        print("Package details: $packageData");
      } else {
        print("Package not found");
      }
    } catch (e) {
      print("Error fetching package details: $e");
    }
  }

  Future<void> _storeBookingDetails() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Get the current logged-in hostId
        String hostId = FirebaseAuth.instance.currentUser?.uid ?? '';

        // Create a new booking document
        DocumentReference bookingRef = FirebaseFirestore.instance.collection('packagebookings').doc();

        await bookingRef.set({
          'userId': widget.userId,
          'hostId': packageData!['hostId'],
          'packageId': widget.packageId,
          'travellerDetails': _travellerDetails,
          'contactInfo': {
            'email': _emailController.text,
            'mobile': _mobileController.text,
            'city': _cityController.text,
            'state': _stateController.text,
            'address': _addressController.text,
          },
          'bookingDate': Timestamp.now(),
        });

        print("Booking details stored successfully");

        // Navigate back or show a success message
      } catch (e) {
        print("Error storing booking details: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
     if (packageData == null) {
      return Center(child: CircularProgressIndicator());
    }
    double totalPrice = packageData!['pricePerPerson']*(widget.adults + widget.children);
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Page', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 222, 121, 90),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPackageInfo(),
              SizedBox(height: 16),
              _buildTravellerDetailsSection(),
              SizedBox(height: 16),
              _buildContactInformation(),
              SizedBox(height: 16),
              _buildBookingButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 160,
              decoration: BoxDecoration(image: DecorationImage(
                              image: NetworkImage(packageData!['imageUrl'] ?? ''),
                              fit: BoxFit.cover,
                            )),),
                        SizedBox(height: 8),    
            Text( packageData!['title'] ?? 'No Title Available', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            
            SizedBox(height: 8),
            Text('${packageData!['nights']} Nights ${packageData!['destination']}'),
            SizedBox(height: 16),
            Row(
              children: [
                Text('${widget.startingDate.toLocal()}'.split(' ')[0], style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Text('to'),
                SizedBox(width: 8),
                Text('${widget.startingDate.add(Duration(days: 3)).toLocal()}'.split(' ')[0], style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Text('${widget.adults} Travellers: ${widget.adults} Adults, ${widget.children} Children / From ${widget.selectedvalue}'),
            SizedBox(height: 8),
            Text(widget.withflight1?'Total Amount: ₹${packageData!['pricePerPerson']*(widget.adults + widget.children)}':'Total Amount: ₹${packageData!['pricePerPerson1']*(widget.adults + widget.children)}',style: TextStyle(fontWeight: FontWeight.bold),)

          ],
        ),
      ),
    );
  }

  Widget _buildTravellerDetailsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Traveller Details', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildTravellerList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTravellerList() {
    return Column(
      children: List.generate(widget.adults + widget.children, (index) {
        return _buildTravellerItem(index);
      }),
    );
  }

  Widget _buildTravellerItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Traveller ${index + 1}'),
          TextFormField(
            decoration: InputDecoration(labelText: 'Full Name'),
            onChanged: (value) {
              _travellerDetails[index]['fullName'] = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _travellerDetails[index]['age'] = int.parse(value);
            },
          ),
          DropdownButtonFormField<String>(
            value: _travellerDetails[index]['gender'],
            items: ['Male', 'Female'].map((String gender) {
              return DropdownMenuItem(value: gender, child: Text(gender));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _travellerDetails[index]['gender'] = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactInformation() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact Information', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildContactFormField('Email ID', _emailController),
            _buildContactFormField('Mobile', _mobileController),
            _buildContactFormField('City', _cityController),
            _buildContactFormField('State', _stateController),
            _buildContactFormField('Address', _addressController),
          ],
        ),
      ),
    );
  }

  Widget _buildContactFormField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  Widget _buildBookingButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 222, 121, 90)),
        onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => PackagePaymentPage(totalAmount: packageData!['pricePerPerson']*(widget.adults + widget.children), onPaymentSuccess: _storeBookingDetails, userId: widget.userId),)),
        child: Text('Proceed to Pay',style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
