import 'package:flutter/material.dart';
import 'api_service.dart';

class HomeworkPage extends StatefulWidget {
  @override
  _HomeworkPageState createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {

  String? selectedClass;
  String? selectedSubject;

  TextEditingController taskController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  List classList = ["6", "7", "8", "9", "10"];
  List subjectList = ["T", "SS", "E", "M", "SC"];

  // 📅 DATE PICKER
  Future pickDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      controller.text = picked.toString().split(" ")[0];
    }
  }

  // 📤 SAVE HOMEWORK
void saveHomework() async {
  try {
    var res = await ApiService.addHomework(
      selectedClass!,
      selectedSubject!,
      taskController.text,
      dateController.text,
      dueDateController.text,
    );

    print("RESPONSE: $res");

    if (res['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Homework Saved")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? "Error")),
      );
    }

  } catch (e) {
    print("FLUTTER ERROR: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Homework")),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
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

              // 🔽 SUBJECT DROPDOWN
              DropdownButton(
                value: selectedSubject,
                hint: Text("Select Subject"),
                isExpanded: true,
                items: subjectList.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(s),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedSubject = val.toString();
                  });
                },
              ),

              SizedBox(height: 10),

              // 📝 TASK
              TextField(
                controller: taskController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Task",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 10),

              // 📅 DATE SUBMITTED
              TextField(
                controller: dateController,
                readOnly: true,
                onTap: () => pickDate(dateController),
                decoration: InputDecoration(
                  labelText: "Date Submitted",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 10),

              // 📅 DUE DATE
              TextField(
                controller: dueDateController,
                readOnly: true,
                onTap: () => pickDate(dueDateController),
                decoration: InputDecoration(
                  labelText: "Due Date",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              // 🚀 SAVE BUTTON
              ElevatedButton(
                onPressed: saveHomework,
                child: Text("Save Homework"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}