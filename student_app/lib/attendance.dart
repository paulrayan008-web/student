import 'package:flutter/material.dart';
import 'api_service.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String? selectedClass;
  List students = [];

  List attendanceData = [];

  List classList = ["6", "7", "8", "9", "10"];

  void loadStudents() async {
    if (selectedClass == null) return;

    var res = await ApiService.getStudentsByClass(selectedClass!);

    setState(() {
      students = res;

      attendanceData = students.map((s) {
        return {
          "regno": s['regno'],
          "name": s['name'],
          "phone": s['phone'],
          "class": selectedClass,
          "status": "Present"
        };
      }).toList();
    });
  }

  void saveAttendance() async {
    var res = await ApiService.saveAttendance(attendanceData);

    if (res['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Attendance Saved")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance")),
      body: Column(
        children: [

          // 🔽 CLASS DROPDOWN
          Padding(
            padding: EdgeInsets.all(10),
            child: DropdownButton(
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
                loadStudents();
              },
            ),
          ),

          // 📋 STUDENT LIST
          Expanded(
            child: ListView.builder(
              itemCount: attendanceData.length,
              itemBuilder: (context, index) {
                var s = attendanceData[index];

                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text("${s['name']} (${s['regno']})"),
                    subtitle: Text("📞 ${s['phone']}"),
                    trailing: DropdownButton(
                      value: s['status'],
                      items: ["Present", "Absent"].map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          attendanceData[index]['status'] = val;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // 💾 SAVE BUTTON
          ElevatedButton(
            onPressed: saveAttendance,
            child: Text("Save Attendance"),
          ),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}