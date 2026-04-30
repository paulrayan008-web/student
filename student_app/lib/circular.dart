import 'package:flutter/material.dart';
import 'api_service.dart';

class CircularPage extends StatefulWidget {
  @override
  _CircularPageState createState() => _CircularPageState();
}

class _CircularPageState extends State<CircularPage> {

  String? selectedClass;
  TextEditingController messageController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List classList = ["6", "7", "8", "9", "10"];

  // 📅 DATE PICKER
  Future pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  // 📤 SEND CIRCULAR
  void sendCircular() async {

    if (selectedClass == null || messageController.text.isEmpty || dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields required")),
      );
      return;
    }

    var res = await ApiService.addCircular(
      selectedClass!,
      messageController.text,
      dateController.text,
    );

    if (res['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Circular Sent")),
      );

      messageController.clear();
      dateController.clear();
      setState(() {
        selectedClass = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Circular")),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [

            // 🔽 CLASS DROPDOWN
            DropdownButton(
              value: selectedClass,
              hint: Text("Select Class"),
              isExpanded: true,
              items: classList.map((c) {
                return DropdownMenuItem(
                  value: c,
                  child: Text("Class $c"),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedClass = val.toString();
                });
              },
            ),

            SizedBox(height: 10),

            // 📅 DATE
            TextField(
              controller: dateController,
              readOnly: true,
              onTap: pickDate,
              decoration: InputDecoration(
                labelText: "Select Date",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),

            // 📝 MESSAGE
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Message",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // 🚀 SEND BUTTON
            ElevatedButton(
              onPressed: sendCircular,
              child: Text("Send Circular"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}