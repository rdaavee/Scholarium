import 'package:flutter/material.dart';

class UpdateFormScreen extends StatelessWidget {
  static String routeName = 'UpdateFormScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPDATE'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField('First Name', 'Ranier'),
            _buildTextField('Middle Name', 'Tan'),
            _buildTextField('Last Name', 'Arcega'),
            _buildTextField('Email', 'rata.arcega.up@phinmaed.com'),
            _buildTextField('School ID', '03-0000-00001'),
            _buildTextField('Address', 'Pantal, Dagupan City'),
            _buildTextField('Contact No.', '0988 8888 888'),
            _buildTextField('HK Type', ''),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildTextField(String labelText, String initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        controller: TextEditingController(text: initialValue),
      ),
    );
  }
}
