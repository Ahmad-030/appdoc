import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/bottomnavcomponents/medicinecomponents/addmedicinetopatient.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/material.dart';

class Medicine extends StatefulWidget {
  @override
  _MedicineState createState() => _MedicineState();
}

class _MedicineState extends State<Medicine> {
  final List<Map<String, String>> users = [
    {'image': 'assets/images/splashscreen.png', 'name': 'Alice', 'subtitle': 'Physical'},
    {'image': 'assets/images/splashscreen.png', 'name': 'Bob', 'subtitle': 'Online'},
    {'image': 'assets/images/splashscreen.png', 'name': 'Charlie', 'subtitle': 'Physical'},
    {'image': 'assets/images/splashscreen.png', 'name': 'Diana', 'subtitle': 'Online'},
    {'image': 'assets/images/splashscreen.png', 'name': 'Eve', 'subtitle': 'Physical'},
  ];

  List<Map<String, String>> filteredUsers = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredUsers = users; // Initially, show all users
  }

  void filterUsers(String query) {
    final results = users.where((user) {
      final nameLower = user['name']!.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    setState(() {
      filteredUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medicine',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.blue,
          automaticallyImplyLeading: false// Replace with `customBlue` from your constant file
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: filterUsers, // Call filterUsers on text change
            ),
          ),
          // List of users
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 180, // Increased height to accommodate the button
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Doctor Image
                              Container(
                                height: 65,
                                width: 65,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/doctorimage.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              // Doctor Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Ayesha Salman",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      "Online",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: customBlue,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Appointment: 10:00 AM To 11:00 AM ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                          fontFamily: 'Poppins',
                                        ),
                                        children: const [
                                          TextSpan(
                                            text: '(Monday)',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox( height: 10,),
                                    // View Report Button
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Addmedicinetopatient()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: customBlue,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12.0,
                                          horizontal: 20.0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: const Text(
                                        'Assign',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
