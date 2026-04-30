import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  // 🔗 CHANGE THIS

  static String baseUrl = "http://10.146.131.116:5000";
  // emulator → 10.0.2.2
  // real device → use your PC IP (e.g., 192.168.1.5:5000)

  // =========================
  // ✅ STAFF LOGIN
  // =========================
static Future<Map<String, dynamic>> staffLogin(String phone) async {
  var res = await http.post(
    Uri.parse("$baseUrl/staff_login"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"phone": phone}),
  );

  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return jsonDecode(res.body);
}
  // =========================
  // ✅ ATTENDANCE
  // =========================

 // GET STUDENTS BY CLASS
static Future<List> getStudentsByClass(String className) async {
  var res = await http.get(
    Uri.parse("$baseUrl/get_students_by_class/$className"),
  );
  return jsonDecode(res.body);
}

// SAVE ATTENDANCE
static Future saveAttendance(List data) async {
  var res = await http.post(
    Uri.parse("$baseUrl/add_attendance_bulk"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(data),
  );

  return jsonDecode(res.body);
}
  // =========================
  // ✅ HOMEWORK
  // =========================

static Future addHomework(
  String className,
  String subject,
  String task,
  String dateSubmitted,
  String dueDate,
) async {

  var res = await http.post(
    Uri.parse("$baseUrl/add_homework"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "class": className,
      "subject": subject,
      "task": task,
      "date_submitted": dateSubmitted,
      "due_date": dueDate
    }),
  );

  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  return jsonDecode(res.body);
}
  // =========================
  // ✅ CIRCULAR
  // =========================

  static Future addCircular(String className, String message, String date) async {
  var res = await http.post(
    Uri.parse("$baseUrl/add_circular"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "class": className,
      "message": message,
      "date": date
    }),
  );

  return jsonDecode(res.body);
}
  }
