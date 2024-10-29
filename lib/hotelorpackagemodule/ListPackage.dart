import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journease/hotelorpackagemodule/addpackage.dart';
import 'package:journease/hotelorpackagemodule/editpackage.dart';
import 'package:journease/hotelorpackagemodule/models/packageModel.dart';

class PackageListPage extends StatefulWidget {
  final String hostId;

  const PackageListPage({super.key, required this.hostId});

  @override
  _PackageListPageState createState() => _PackageListPageState();
}

class _PackageListPageState extends State<PackageListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String hostId;

  @override
  void initState() {
    super.initState();
    // Get the logged-in user's ID (hostId)
    hostId = _auth.currentUser!.uid;
  }

  Future<List<PackageModel>> fetchPackages() async {
    // Fetch packages where hostId matches the logged-in user's ID
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('packages')
        .where('hostId', isEqualTo: hostId)
        .get();

    return snapshot.docs.map((doc) => PackageModel.fromFirestore(doc)).toList();
  }

  Future<void> deletePackage(String packageId) async {
    try {
      await FirebaseFirestore.instance.collection('packages').doc(packageId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Package deleted successfully!')),
      );
      setState(() {}); // Refresh the list after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting package: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Packages',style: TextStyle(color: Colors.white),),
        backgroundColor: Color.fromARGB(255, 222, 121, 90),
        actions: [
          IconButton(
            icon: Icon(Icons.add,color: Colors.white,),
            onPressed: () async {
              // Navigate to AddPackagePage and refresh when coming back
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddPackagePage(hostId: hostId),
              ));
              setState(() {}); // Refresh the list after returning
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<PackageModel>>(
          future: fetchPackages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error fetching packages'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No packages found.'));
            }

            List<PackageModel> packages = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.separated(
                itemCount: packages.length,
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  PackageModel package = packages[index];
                  return Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Column(
                        children: [
                          // Image Placeholder (you can replace this with an actual image URL)
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(package.imageUrl!), // Placeholder image
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  package.title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${package.nights} Nights | ${package.days} Days',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Destination: ${package.destination}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () {
                                            // Handle edit action
                                            Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => EditPackagePage(
                                                hostId: hostId,
                                                package: package, // Pass the package to edit
                                              ),
                                            )).then((_) => setState(() {})); // Refresh after editing
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            // Show confirmation dialog before deletion
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text('Delete Package'),
                                                content: Text('Are you sure you want to delete this package?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () { Navigator.of(context).pop(); 
                                                    deletePackage(package.packageId);
                                                    },// Cancel
                                                    child: Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      deletePackage(package.packageId); // Pass package ID
                                                      Navigator.of(context).pop(); // Close dialog
                                                    },
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                               
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
