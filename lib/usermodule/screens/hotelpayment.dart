// import 'package:flutter/material.dart';


// class PaymentPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new_rounded,size: 14,),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Select Payment Mode', style: TextStyle(fontSize: 16)),
//             Text('Due now: ₹14,160', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
//           ],
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Trip Secure Card
//               // Card(
//               //   child: Padding(
//               //     padding: const EdgeInsets.all(8.0),
//               //     child: Column(
//               //       crossAxisAlignment: CrossAxisAlignment.start,
//               //       children: [
//               //         Text('Trip Secure | One plan, Many benefits',
//               //             style: TextStyle(fontWeight: FontWeight.bold)),
//               //         SizedBox(height: 8),
//               //         Text(
//               //             'Covers medical expenses, loss of valuables, hotel cancellations, emergency assistance & more.'),
//               //         Align(
//               //           alignment: Alignment.bottomRight,
//               //           child: ElevatedButton(
//               //             onPressed: () {},
//               //             child: Text('ADD @79'),
//               //           ),
//               //         )
//               //       ],
//               //     ),
//               //   ),
//               // ),
//               // SizedBox(height: 16),
              
//               // Pay with Rewards
//               // Card(
//               //   child: ListTile(
//               //     leading: Icon(Icons.card_giftcard),
//               //     title: Text('Pay with Rewards'),
//               //     subtitle: Text('Yes Bank, Zillion & more partners'),
//               //     trailing: OutlinedButton(
//               //       onPressed: () {},
//               //       child: Text('CHECK'),
//               //     ),
//               //   ),
//               // ),
//               // SizedBox(height: 16),
              
//               // Other Pay Options
//               Text(' Pay Options',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: 16)),
//               SizedBox(height: 8),
              
//               // List of Payment Options
//               PaymentOption(
//                 icon: Icons.credit_card,
//                 title: 'Credit/Debit/ATM Card',
//                 subtitle: 'Visa, MasterCard, Amex, Rupay And More',
//                 onTap: () {},
//               ),
//               PaymentOption(
//                 icon: Icons.account_balance_wallet,
//                 title: 'UPI Options',
//                 subtitle: '+ more',
//                 onTap: () {},
//               ),
//               PaymentOption(
//                 icon: Icons.book_online,
//                 title: 'Book Now Pay Later',
//                 subtitle: 'Tripmoney, Lazypay, Simpl, ICICI, HDFC',
//                 onTap: () {},
//               ),
//               PaymentOption(
//                 icon: Icons.account_balance,
//                 title: 'Net Banking',
//                 subtitle: 'All Major Banks Available',
//                 onTap: () {},
//               ),
//               PaymentOption(
//                 icon: Icons.card_giftcard,
//                 title: 'Gift Cards & e-wallets',
//                 subtitle: 'MMT Gift cards, Mobikwik & More',
//                 onTap: () {},
//               ),
//               PaymentOption(
//                 icon: Icons.payment,
//                 title: 'EMI',
//                 subtitle: 'Credit/Debit Card EMI available',
//                 trailing: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 4.0),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: Colors.green,
//                   ),
//                   child: Text('NO COST EMI', style: TextStyle(color: Colors.white)),
//                 ),
//                 onTap: () {},
//               ),
//               PaymentOption(
//                 icon: Icons.account_balance_wallet_outlined,
//                 title: 'GooglePay',
//                 subtitle: 'Pay with Google Pay',
//                 onTap: () {},
//               ),
              
//               // Agreement Section
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 16.0),
//                 child: Text(
//                   "By proceeding, I understand and agree with the Privacy Policy, "
//                   "User Agreement and Terms of Service of MakeMyTrip.",
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // PaymentOption Widget for each payment option row
// class PaymentOption extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final Widget? trailing;
//   final VoidCallback onTap;

//   const PaymentOption({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     this.trailing,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, size: 32, color: Color.fromARGB(255, 222, 121, 90)),
//       title: Text(title),
//       subtitle: Text(subtitle),
//       trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: onTap,
//     );
//   }
// }

import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final double totalAmount;
  final Function(double totalAmount) onPaymentSuccess;
  String hostId;

  PaymentPage({super.key, required this.totalAmount, required this.onPaymentSuccess,required this.hostId});

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
              onPaymentSuccess(totalAmount);
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

