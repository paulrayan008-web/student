import 'package:flutter/material.dart';
import 'attendance.dart';
import 'homework.dart';
import 'circular.dart';

class StaffDashboard extends StatelessWidget {
  Widget buildButton(BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.blueAccent],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 8)
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.white),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(fontSize: 18, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Staff Dashboard"),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade200, Colors.indigo.shade200],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(context, "Attendance", Icons.check, AttendancePage()),
            buildButton(context, "Homework", Icons.book, HomeworkPage()),
            buildButton(context, "Circular", Icons.notifications, CircularPage()),
          ],
        ),
      ),
    );
  }
}