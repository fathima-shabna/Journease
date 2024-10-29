

import 'package:flutter/material.dart';

class PackagePaymentPage extends StatelessWidget {
  final double totalAmount;
  final Function() onPaymentSuccess;
  String userId;

  PackagePaymentPage({super.key, required this.totalAmount, required this.onPaymentSuccess,required this.userId});

  @override
  Widget build(BuildContext context) {
    // Create a TextEditingController to handle the amount input
    final TextEditingController amountController = TextEditingController();
    amountController.text = totalAmount.toStringAsFixed(2); // Set the default value to the passed amount

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,size: 14,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Continue With Payment', style: TextStyle(fontSize: 16)),
            Text('Due now: ₹${totalAmount}', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Amount input field
            TextField(
              readOnly: true,
              controller: amountController,
              // keyboardType: TextInputType.number,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
                labelText: 'Amount',
                prefixText: '\u{20B9} ',
                prefixStyle: TextStyle(fontSize: 18),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.green[50], // Light green background
              ),
            ),
            SizedBox(height: 20), // Space between input and button
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () async {
            // Simulate payment success
            bool paymentSuccessful = true;

            if (paymentSuccessful) {
              // Call the callback function to save booking details
              onPaymentSuccess();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment successful")));
              // Navigate back or to a confirmation page
              Navigator.pop(context);
              
            } else {
              
            }
          },
          child: Text('Complete Payment',style: TextStyle(color: Colors.white),),
        ),
          ],
        ),
      ),
    );
  }
}

