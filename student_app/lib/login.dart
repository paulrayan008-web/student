import 'package:flutter/material.dart';
import 'api_service.dart';
import 'staff_dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  // 🔐 LOGIN FUNCTION
  void login() async {
    print("LOGIN BUTTON CLICKED");

    if (phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter phone number")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var res = await ApiService.staffLogin(phoneController.text);

      print("API RESPONSE: $res");

      if (res['status'] == 'success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => StaffDashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid phone number")),
        );
      }
    } catch (e) {
      print("ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Server not reachable")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Staff Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // 📱 PHONE FIELD
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),

            SizedBox(height: 20),

            // 🔘 BUTTON / LOADING
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: login,
                    child: Text("Login"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                  ),

          ],
        ),
      ),
    );
  }
}