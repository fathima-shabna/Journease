// import 'package:flutter/material.dart';



// class SimpleTrackingScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Simple Order Tracking'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             SimpleTrackingWidget(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SimpleTrackingWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       child: Row(
//         children: [
//           // Vertical Line with 2 Dots
//           Column(
//             children: [
//               TrackingStep(),
//               // Line between the dots
//               Container(
//                 width: 1,
//                 height: 40,
//                 color: Colors.grey[400],
//               ),
//               TrackingStep(),
//             ],
//           ),

//           // Space between the line and text
//           SizedBox(width: 16),

//           // Labels for the 2 steps
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 12.0),
//                   child: Text(
//                     'Step 1',
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 12.0),
//                   child: Text(
//                     'Step 2',
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TrackingStep extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 10,
//       height: 10,
//       decoration: BoxDecoration(
//         color: Colors.grey, // Grey color for the points
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';


class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            Text('Select Payment Mode', style: TextStyle(fontSize: 16)),
            Text('Due now: ₹14,160', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip Secure Card
              // Card(
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text('Trip Secure | One plan, Many benefits',
              //             style: TextStyle(fontWeight: FontWeight.bold)),
              //         SizedBox(height: 8),
              //         Text(
              //             'Covers medical expenses, loss of valuables, hotel cancellations, emergency assistance & more.'),
              //         Align(
              //           alignment: Alignment.bottomRight,
              //           child: ElevatedButton(
              //             onPressed: () {},
              //             child: Text('ADD @79'),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(height: 16),
              
              // Pay with Rewards
              // Card(
              //   child: ListTile(
              //     leading: Icon(Icons.card_giftcard),
              //     title: Text('Pay with Rewards'),
              //     subtitle: Text('Yes Bank, Zillion & more partners'),
              //     trailing: OutlinedButton(
              //       onPressed: () {},
              //       child: Text('CHECK'),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 16),
              
              // Other Pay Options
              Text(' Pay Options',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 8),
              
              // List of Payment Options
              PaymentOption(
                icon: Icons.credit_card,
                title: 'Credit/Debit/ATM Card',
                subtitle: 'Visa, MasterCard, Amex, Rupay And More',
                onTap: () {},
              ),
              PaymentOption(
                icon: Icons.account_balance_wallet,
                title: 'UPI Options',
                subtitle: '+ more',
                onTap: () {},
              ),
              PaymentOption(
                icon: Icons.book_online,
                title: 'Book Now Pay Later',
                subtitle: 'Tripmoney, Lazypay, Simpl, ICICI, HDFC',
                onTap: () {},
              ),
              PaymentOption(
                icon: Icons.account_balance,
                title: 'Net Banking',
                subtitle: 'All Major Banks Available',
                onTap: () {},
              ),
              PaymentOption(
                icon: Icons.card_giftcard,
                title: 'Gift Cards & e-wallets',
                subtitle: 'MMT Gift cards, Mobikwik & More',
                onTap: () {},
              ),
              PaymentOption(
                icon: Icons.payment,
                title: 'EMI',
                subtitle: 'Credit/Debit Card EMI available',
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.green,
                  ),
                  child: Text('NO COST EMI', style: TextStyle(color: Colors.white)),
                ),
                onTap: () {},
              ),
              PaymentOption(
                icon: Icons.account_balance_wallet_outlined,
                title: 'GooglePay',
                subtitle: 'Pay with Google Pay',
                onTap: () {},
              ),
              
              // Agreement Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "By proceeding, I understand and agree with the Privacy Policy, "
                  "User Agreement and Terms of Service of MakeMyTrip.",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// PaymentOption Widget for each payment option row
class PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 32, color: Color.fromARGB(255, 222, 121, 90)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}