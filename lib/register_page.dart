import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// 🔥 สำคัญมาก (แก้ localhost)
const String baseUrl = "http://localhost/flutter_booking_66710991/php_api/";
// ถ้าใช้มือถือจริง → เปลี่ยนเป็น IP เครื่องคุณ

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool isLoading = false;

  Future<void> register() async {
    // 🔥 กันกดรัว
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var url = Uri.parse("${baseUrl}register.php");

      var response = await http.post(url, body: {
        "first_name": firstName.text,
        "last_name": lastName.text,
        "phone": phone.text,
        "username": username.text,
        "password": password.text,
      });

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      var data = json.decode(response.body);

      if (data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Register Success")),
        );

        Navigator.pop(context); // 🔥 กลับไปหน้า login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Register Failed")),
        );
      }
    } catch (e) {
      print("ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection Error")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: firstName,
                decoration: InputDecoration(labelText: "First Name"),
              ),
              TextField(
                controller: lastName,
                decoration: InputDecoration(labelText: "Last Name"),
              ),
              TextField(
                controller: phone,
                decoration: InputDecoration(labelText: "Phone"),
              ),
              TextField(
                controller: username,
                decoration: InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: password,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),

              SizedBox(height: 20),

              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: register,
                      child: Text("Register"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}