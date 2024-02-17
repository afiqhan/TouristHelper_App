import 'package:flutter/material.dart';

class ViewLocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'This is the detailed information about the location. You can add more details, images, or any other relevant information here.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            // Add more widgets or information as needed
          ],
        ),
      ),
    );
  }
}
