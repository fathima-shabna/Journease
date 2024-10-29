// import 'package:flutter/material.dart';

// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ShaderMask(
//       shaderCallback: (Rect bounds) {
//         return LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.transparent, Colors.black],
//           stops: [0.5, 1.0],
//         ).createShader(bounds);
//       },
//       blendMode: BlendMode.dstIn,
//       child: Image.network(
//         'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
//         fit: BoxFit.cover,
//       ),
//     );
//   }
// }






// Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextButton(onPressed: (){}, child: Text("Admin?",style: TextStyle(color: Colors.indigo[600]),)),
//                   TextButton(onPressed: (){}, child: Text("Agency?",style: TextStyle(color: Colors.indigo[600]),)),
//                   TextButton(onPressed: (){}, child: Text("Resort?",style: TextStyle(color: Colors.indigo[600]),)),
//                 ],
//               ),
//               SizedBox(height: 10,),
//               Text("or"),
//               SizedBox(height: 10,),
//               Text("User login",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
//               SizedBox(height: 30,),
//               CustomTextFormField(
                
//                 controller: _phoneController,
//                 label: ("Enter your mobile no."),
//                 validator: (value){
//                   if (value.toString().isEmpty) {
//                                   return 'invalid';
//                                 }
//                                 if (value.toString().length != 10) {
//                                   return 'Invalid phone number';
//                                 }
//                                 return null;
//                 }
                
//               ),
//               SizedBox(height: 15,),
//               CustomTextFormField(
//                 controller: _passwordController,
//                 label: ("Enter your password"),
//                 validator: (value){
//                    if (value.toString().isEmpty) {
//                             return 'Please enter your password';
//                           } else if (value.toString().length < 6) {
//                             return 'Password must be at least 6 characters';
//                           }
//                           return null;
//                 },
//                 suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.visibility)),
//               ),
//               SizedBox(height: 20,),
//               ElevatedButton(onPressed: (){}, child: Text("SignIn",style: TextStyle(color: Colors.white,fontSize: 15),),style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.indigo[400]),side: MaterialStatePropertyAll(BorderSide(
//                 color: const Color.fromARGB(255, 82, 99, 198),
                
//                 // width: 1.5
//                 ))),)


//  children: [
//                     buildCard('MOUNTAIN', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRl9mmPDi-Wv0H85qRRj595nt4YTVXvIG3SMA&s'),
//                     buildCard('ROMANTIC', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRbZDsOhpKF3Y0MckHN0pgWexbVpOD459vTA&s'),
//                     buildCard('BEACH', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSO1ISR5MWlYpu6HHP51IIAWISKmL2gdxkh0Q&s'),
//                     buildCard('WEEKEND', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWMlDwwxqJ9AIqEDu_yR6OQsr-rFgPSq1IpQ&s')
//                   ],

// https://e0.pxfuel.com/wallpapers/230/505/desktop-wallpaper-travel-the-world-stock-new-for-your-mobile-tablet-explore-traveling-travel-guides-travel-cities-travel-app-travel-around-the-world-thumbnail.jpg






// class MyApp extends StatelessWidget {
//   MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Drawer Example'),
//         ),
//         drawer: Drawer(
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: [
              
//               ListTile(
//                 leading: Icon(Icons.person),
//                 title: Text('My Account'),
//                 onTap: () {
//                   // Handle the action
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.support),
//                 title: Text('Support'),
//                 onTap: () {
//                   // Handle the action
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.notifications),
//                 title: Text('Notifications'),
//                 onTap: () {
//                   // Handle the action
//                 },
//               ),
//               Divider(),
//               ListTile(
//                 leading: Icon(Icons.card_travel),
//                 title: Text('View/Manage Trips'),
//                 onTap: () {
//                   // Handle the action
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.favorite),
//                 title: Text('Wishlist'),
//                 onTap: () {
//                   // Handle the action
//                 },
//               ),
//               Divider(),
//               ListTile(
//                 leading: Icon(Icons.card_giftcard),
//                 title: Text('Gift Cards'),
//                 onTap: () {
//                   // Handle the action
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.redeem),
//                 title: Text('Rewards'),
//                 onTap: () {
//                   // Handle the action
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.group),
//                 title: Text('Refer & Earn'),
//                 onTap: () {
//                   // Handle the action
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.monetization_on),
//                 title: Text('Holidays Refer & Earn'),
//                 onTap: () {
//                   // Handle the action
//                 },
//               ),
//               Divider(),
//               ListTile(
//                 leading: Icon(Icons.star),
//                 title: Text('MMTBLACK'),
//                 onTap: () {
//                   // Handle the action
//                 },
//               ),
//               Divider(),
//               ListTile(
//                 leading: Icon(Icons.language),
//                 title: Text('Language English'),
//                 onTap: () {
//                   // Handle the action
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.flag),
//                 title: Text('Country'),
//                 onTap: () {
//                   // Handle the action
//                 },
//               ),
//               SizedBox(height: 20.0),  // Replace Spacer with SizedBox or Padding
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         // Handle Rate Us action
//                       },
//                       child: Text('Rate Us'),
//                     ),
//                     Text(" • "),
//                     TextButton(
//                       onPressed: () {
//                         // Handle Privacy Policy action
//                       },
//                       child: Text('Privacy Policy'),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: Center(
//           child: Text('Swipe right to open drawer'),
//         ),
//       ),
//     );
//   }
// }


// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';

// class BannerModel {
//   String id;
//   String? imageUrl;

//   BannerModel({required this.id, this.imageUrl});
// }

// class ManageBannersScreen extends StatefulWidget {
//   @override
//   _ManageBannersScreenState createState() => _ManageBannersScreenState();
// }

// class _ManageBannersScreenState extends State<ManageBannersScreen> {
//   List<BannerModel> banners = [];
//   final picker = ImagePicker();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   @override
//   void initState() {
//     super.initState();
//     fetchBanners();
//   }

//   // Fetch banners from Firestore
//   Future<void> fetchBanners() async {
//     final snapshot = await _firestore.collection('offerbanners').get();
//     setState(() {
//       banners = snapshot.docs
//           .map((doc) => BannerModel(id: doc.id, imageUrl: doc['imageUrl']))
//           .toList();
//     });
//   }

//   // Add or update banner
//   Future<void> showBannerDialog({BannerModel? banner}) async {
//     File? selectedImage;

//     Future<void> _pickImage() async {
//       final pickedFile = await picker.getImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         setState(() {
//           selectedImage = File(pickedFile.path);
//         });
//       }
//     }

//     return showDialog(
//       context: context, // Use the current context
//       builder: (context) {
//         return AlertDialog(
//           title: Text(banner == null ? 'Add Banner' : 'Edit Banner'),
//           content: SingleChildScrollView(
//             child: GestureDetector(
//               onTap: _pickImage,
//               child: Container(
//                 width: double.infinity,
//                 height: 150,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: selectedImage != null
//                     ? Image.file(selectedImage!, fit: BoxFit.cover)
//                     : (banner?.imageUrl != null
//                         ? Image.network(banner!.imageUrl!, fit: BoxFit.cover)
//                         : Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.camera_alt, size: 50, color: Colors.grey[700]),
//                               Text('Tap to select image', style: TextStyle(color: Colors.grey[700])),
//                             ],
//                           )),
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(dialogContext).pop(),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 if (selectedImage != null) {
//                   // Upload image to Firebase Storage
//                   String fileName = basename(selectedImage!.path);
//                   Reference storageRef = _storage.ref().child('banners/$fileName');
//                   UploadTask uploadTask = storageRef.putFile(selectedImage!);

//                   TaskSnapshot taskSnapshot = await uploadTask;
//                   String imageUrl = await taskSnapshot.ref.getDownloadURL();

//                   if (banner == null) {
//                     // Add new banner to Firestore
//                     DocumentReference docRef = await _firestore.collection('offerbanners').add({
//                       'imageUrl': imageUrl,
//                     });

//                     setState(() {
//                       banners.add(BannerModel(id: docRef.id, imageUrl: imageUrl));
//                     });
//                   } else {
//                     // Update existing banner in Firestore
//                     await _firestore.collection('offerbanners').doc(banner.id).update({
//                       'imageUrl': imageUrl,
//                     });

//                     setState(() {
//                       banner.imageUrl = imageUrl;
//                     });
//                   }

//                   Navigator.of(dialogContext).pop();
//                 } else {
//                   // Show snack bar if no image is selected
//                   ScaffoldMessenger.of(dialogContext).showSnackBar(SnackBar(content: Text('Image is required')));
//                 }
//               },
//               child: Text(banner == null ? 'Add' : 'Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Confirm delete banner
//   void _confirmDelete(BannerModel banner) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: Text('Delete Banner'),
//           content: Text('Are you sure you want to delete this banner?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(dialogContext).pop(),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 // Delete banner from Firestore and Firebase Storage
//                 await _firestore.collection('offerbanners').doc(banner.id).delete();
//                 if (banner.imageUrl != null) {
//                   Reference storageRef = _storage.refFromURL(banner.imageUrl!);
//                   await storageRef.delete();
//                 }

//                 setState(() {
//                   banners.remove(banner);
//                 });
//                 Navigator.of(dialogContext).pop();
//               },
//               child: Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Manage Banners'),
//         backgroundColor: Colors.teal,
//       ),
//       body: banners.isEmpty
//           ? Center(child: Text('No banners added. Tap the "+" button to add one.'))
//           : ListView.builder(
//               itemCount: banners.length,
//               itemBuilder: (context, index) {
//                 final banner = banners[index];
//                 return Card(
//                   margin: EdgeInsets.all(10),
//                   child: ListTile(
//                     leading: banner.imageUrl != null
//                         ? Image.network(banner.imageUrl!, width: 70, height: 70, fit: BoxFit.cover)
//                         : Container(width: 70, height: 70, color: Colors.grey[300], child: Icon(Icons.image)),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit, color: Colors.blue),
//                           onPressed: () => showBannerDialog(banner: banner),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => _confirmDelete(banner),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.teal,
//         onPressed: () => showBannerDialog(),
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class BannerModel {
  String id;
  String? imageUrl;

  BannerModel({required this.id, this.imageUrl});
}

class ManageBannersScreen extends StatefulWidget {
  @override
  _ManageBannersScreenState createState() => _ManageBannersScreenState();
}

class _ManageBannersScreenState extends State<ManageBannersScreen> {
  List<BannerModel> banners = [];
  final picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    fetchBanners();
  }

  // Fetch banners from Firestore
  Future<void> fetchBanners() async {
    final snapshot = await _firestore.collection('offerbanners').get();
    setState(() {
      banners = snapshot.docs
          .map((doc) => BannerModel(id: doc.id, imageUrl: doc['imageUrl']))
          .toList();
    });
  }

  // Add or update banner
  Future<void> showBannerDialog({BannerModel? banner,context}) async {
    File? selectedImage;

    Future<void> _pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    }

    showDialog<AlertDialog>(
      context: context, // Correctly using the BuildContext
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(banner == null ? 'Add Banner' : 'Edit Banner'),
          content: SingleChildScrollView(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: selectedImage != null
                    ? Image.file(selectedImage!, fit: BoxFit.cover)
                    : (banner?.imageUrl != null
                        ? Image.network(banner!.imageUrl!, fit: BoxFit.cover)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, size: 50, color: Colors.grey[700]),
                              Text('Tap to select image', style: TextStyle(color: Colors.grey[700])),
                            ],
                          )),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (selectedImage != null) {
                  try {
                    // Upload image to Firebase Storage
                    String fileName = basename(selectedImage!.path);
                    Reference storageRef = _storage.ref().child('banners/$fileName');
                    UploadTask uploadTask = storageRef.putFile(selectedImage!);

                    TaskSnapshot taskSnapshot = await uploadTask;
                    String imageUrl = await taskSnapshot.ref.getDownloadURL();

                    if (banner == null) {
                      // Add new banner to Firestore
                      DocumentReference docRef = await _firestore.collection('offerbanners').add({
                        'imageUrl': imageUrl,
                      });

                      setState(() {
                        banners.add(BannerModel(id: docRef.id, imageUrl: imageUrl));
                      });
                    } else {
                      // Update existing banner in Firestore
                      await _firestore.collection('offerbanners').doc(banner.id).update({
                        'imageUrl': imageUrl,
                      });

                      setState(() {
                        banner.imageUrl = imageUrl;
                      });
                    }

                    Navigator.of(dialogContext).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                } else {
                  // Show snack bar if no image is selected
                  ScaffoldMessenger.of(dialogContext).showSnackBar(SnackBar(content: Text('Image is required')));
                }
              },
              child: Text(banner == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  // Confirm delete banner
  void _confirmDelete(BannerModel banner,context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete Banner'),
          content: Text('Are you sure you want to delete this banner?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Delete banner from Firestore and Firebase Storage
                try {
                  await _firestore.collection('offerbanners').doc(banner.id).delete();
                  if (banner.imageUrl != null) {
                    Reference storageRef = _storage.refFromURL(banner.imageUrl!);
                    await storageRef.delete();
                  }

                  setState(() {
                    banners.remove(banner);
                  });
                } catch (e) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
                Navigator.of(dialogContext).pop();
              },
              child: Text('Delete'),
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
        title: Text('Manage Banners'),
        backgroundColor: Colors.teal,
      ),
      body: banners.isEmpty
          ? Center(child: Text('No banners added. Tap the "+" button to add one.'))
          : ListView.builder(
              itemCount: banners.length,
              itemBuilder: (context, index) {
                final banner = banners[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: banner.imageUrl != null
                        ? Image.network(banner.imageUrl!, width: 70, height: 70, fit: BoxFit.cover)
                        : Container(width: 70, height: 70, color: Colors.grey[300], child: Icon(Icons.image)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => showBannerDialog(banner: banner,context: context),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(banner,context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => showBannerDialog(),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}



