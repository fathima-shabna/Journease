import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:journease/hotelorpackagemodule/propertydetails.dart';
import 'package:journease/usermodule/screens/reviewpackagebooking.dart';



class TripDetailsScreen extends StatefulWidget {
  final bool withflight1;
  final String selectedvalue;
  final String selectedvalue2;
  final int rooms;
  final int adults;
  final int children;
  final DateTime startingDate;
  final String packageId; 
  final String userId;
  final String price;
  final String price2;
  
  const TripDetailsScreen({super.key, required this.withflight1, required this.selectedvalue, required this.selectedvalue2, required this.rooms, required this.adults, required this.children, required this.startingDate, required this.packageId, required this.userId, required this.price, required this.price2, });

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  Map<String, dynamic>? packageDetails;
  double? withFlightPrice;
  double? withoutFlightPrice;

  @override
  void initState() {
    super.initState();
    fetchPackageDetails();
  }
    Future<void> fetchPackageDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('packages')
          .doc(widget.packageId)
          .get();

      if (snapshot.exists) {
        setState(() {
          packageDetails = snapshot.data() as Map<String, dynamic>;
          //  withFlightPrice = double.parse(packageDetails!['pricePerPerson']);
          // withoutFlightPrice = double.parse(packageDetails!['pricePerPerson1']);
        });
      } else {
        // Handle case where package doesn't exist
        print("Package not found");
      }
    } catch (e) {
      print("Error fetching package details: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
        if (packageDetails == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_rounded,size: 15,)),
        toolbarHeight: 60,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 222, 121, 90),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.selectedvalue} to ${widget.selectedvalue2}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            // Text(
            //   '6 Sep 2024, 2 Adults, 1 Room',
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: Colors.grey,
            //   ),
            // ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Tab Buttons
          // Container(
          //   color: Colors.grey[200],
          //   padding: EdgeInsets.symmetric(vertical: 10),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       TabButton(label: 'Day Plan', isSelected: true),
          //       TabButton(label: '2 Flights + 2 Transfers'),
          //       TabButton(label: '1 Hotels'),
          //       TabButton(label: '1 Activity'),
          //     ],
          //   ),
          // ),

          // Date Buttons Row
          // Container(
          //   padding: EdgeInsets.symmetric(vertical: 10),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       DateButton(day: 'FRI', date: '6', month: 'SEP', isSelected: true),
          //       DateButton(day: 'SAT', date: '7', month: 'SEP'),
          //       DateButton(day: 'SUN', date: '8', month: 'SEP'),
          //       DateButton(day: 'MON', date: '9', month: 'SEP'),
          //     ],
          //   ),
          // ),

          // Itinerary Details List
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day 1
                    SizedBox(width: 10,),
                                Column(
                                  children: [
                                    ItineraryItem(
  title: widget.withflight1
      ? packageDetails!['flightDetails'].any((flight) => flight['selectedAirport'] == widget.selectedvalue)
          ? packageDetails!['flightDetails']
              .firstWhere((flight) => flight['selectedAirport'] == widget.selectedvalue)['arrivalDetails']
          : 'No flight details available'
      : 'You need reach there by your own',
  icon: Icons.flight,
),

                                    SizedBox(height: 10,),
                                ItineraryItem(
                                  title: packageDetails!['transportFrom'],
                                  icon: Icons.directions_car,
                                ),
                                  ],
                                ),
                    
                    SizedBox(height: 16),
                    TripDetails(
                      title: '${packageDetails!['destination']} (${packageDetails!['nights']} Nights Stay)',
                    ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          DateTime activityDate = widget.startingDate.add(Duration(days: index));
                          String weekday = DateFormat('EEE').format(activityDate);
                          String monthName = DateFormat('MMM').format(activityDate);
                        return Column(
                          children: [
                            DayDetail(
                              day: 'Day ${index + 1}',
                              date: '${monthName} ${activityDate.day}, ${weekday}',
                              activity:
                                  packageDetails!['daySummaries'][index],
                              icon: Icons.hotel,
                            ),
                            SizedBox(height: 10,),
                          ],
                        );
                      
                      },
                      itemCount: packageDetails!['daySummaries'].length,
                      ),
                      Divider(),
                   SizedBox(height: 10,),
                                Column(
                                  children: [
                                    ItineraryItem(
                                  title: packageDetails!['transportTo'],
                                  icon: Icons.directions_car,
                                ),
                                SizedBox(height: 15,),
                                    ItineraryItem(
                                    title: widget.withflight1
                                    ? packageDetails!['flightDetails'].any((flight) => flight['selectedAirport'] == widget.selectedvalue)
                                    ? packageDetails!['flightDetails']
                                    .firstWhere((flight) => flight['selectedAirport'] == widget.selectedvalue)['departureDetails']
                                    : 'No flight details available'
                                    : 'You need go by your own',
                                    icon: Icons.flight,
                                    ),
                                    
                                
                                  ],
                                ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Booking Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(
                        widget.withflight1 ?
                       widget.price
                       :widget.price2,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    
                    Text(
                      'Per person',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewPage(withflight1: true,
                      selectedvalue: widget.selectedvalue, 
                      selectedvalue2: widget.selectedvalue2, 
                      packageId: widget.packageId, 
                      userId: widget.userId, 
                      startingDate: widget.startingDate, 
                      rooms: widget.rooms, 
                      adults: widget.adults, 
                      children: widget.children, 
                    ),));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 222, 121, 90), padding: EdgeInsets.all(16)),
                  child: Text('BOOK NOW', style: TextStyle(fontSize: 16,color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrackingStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.grey, // Grey color for the points
        shape: BoxShape.circle,
      ),
    );
  }
}
// Itinerary Item Widget
class ItineraryItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const ItineraryItem({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey,),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

// Trip Details Section
class TripDetails extends StatelessWidget {
  final String title;

  const TripDetails({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 222, 121, 90),),
        ),
        Divider(),
        
      ],
    );
  }
}

// Day Detail Item
class DayDetail extends StatelessWidget {
  final String day;
  final String date;
  final String activity;
  final IconData icon;

  const DayDetail(
      {required this.day, required this.date, required this.activity, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon(icon, color: Colors.grey),
          Container(
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(day, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
                Text(date, style: TextStyle(color: Colors.grey,fontSize: 12)),
              ],
            ),
          ),
          
          
          SizedBox(width: 16),
          Expanded(
            child: Text(activity),
          ),
        ],
      ),
    );
  }
}
