import 'package:flutter/material.dart';
import 'package:flutter_booking_66710991/Login.dart';
import 'package:flutter_booking_66710991/home_page.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meeting Room Booking',
      home: HomePage(),   // ✅ หน้าแรกแสดงรายการห้องประชุม
    );

  }

}