import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Medbody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var medlist = [
      {
        'name': 'Panadol',
        'description':
        'Medicine is a field focused on diagnosing, treating, and preventing diseases to improve and maintain human health. It involves various practices and substances, such as medications, therapies, and procedures.',
        'date': '11/13/2024'
      },
      {
        'name': 'Disprin',
        'description':
        'A common medication used to relieve pain, reduce inflammation, and lower fever. Often used for headaches, arthritis, and muscle pain.',
        'date': '11/13/2024'
      },
      {
        'name': 'Disprin',
        'description':
        'A common medication used to relieve pain, reduce inflammation, and lower fever. Often used for headaches, arthritis, and muscle pain.',
        'date': '11/13/2024'
      },
      {
        'name': 'Disprin',
        'description':
        'A common medication used to relieve pain, reduce inflammation, and lower fever. Often used for headaches, arthritis, and muscle pain.',
        'date': '11/13/2024'
      },
      {
        'name': 'Disprin',
        'description':
        'A common medication used to relieve pain, reduce inflammation, and lower fever. Often used for headaches, arthritis, and muscle pain.',
        'date': '11/13/2024'
      },
      {
        'name': 'Disprin',
        'description':
        'A common medication used to relieve pain, reduce inflammation, and lower fever. Often used for headaches, arthritis, and muscle pain.',
        'date': '11/13/2024'
      },
      {
        'name': 'Disprin',
        'description':
        'A common medication used to relieve pain, reduce inflammation, and lower fever. Often used for headaches, arthritis, and muscle pain.',
        'date': '11/13/2024'
      }
      // Add more items as needed
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: medlist.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of items per row
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.75, // Adjusted for content fit
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Shadow color
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medlist[index]['name']!,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        medlist[index]['description']!,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontSize: 14,
                          height: 1.5, // Adjusts line spacing for equal distribution
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    medlist[index]['date']!,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: customBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
