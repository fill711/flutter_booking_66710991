import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl =
    "http://localhost/flutter_booking_66710991/php_api/";

class GameBookingPage extends StatefulWidget {
  final dynamic game;
  final String name;

  const GameBookingPage({
    super.key,
    required this.game,
    required this.name,
  });

  @override
  State<GameBookingPage> createState() => _GameBookingPageState();
}

class _GameBookingPageState extends State<GameBookingPage> {
  DateTime? startTime;
  DateTime? endTime;

  ////////////////////////////////////////////////////////////
  // ✅ CHECK 2 HOURS
  ////////////////////////////////////////////////////////////

  bool isValidDuration(DateTime start, DateTime end) {
    final diff = end.difference(start).inHours;
    return diff <= 2;
  }

  ////////////////////////////////////////////////////////////
  // ✅ PICK DATE TIME
  ////////////////////////////////////////////////////////////

  Future pickStart() async {
    DateTime now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      startTime = DateTime(
          date.year, date.month, date.day, time.hour, time.minute);

      // 🔥 auto set end = +2 ชั่วโมง
      endTime = startTime!.add(const Duration(hours: 2));
    });
  }

  ////////////////////////////////////////////////////////////
  // ✅ BOOK GAME
  ////////////////////////////////////////////////////////////

  Future<void> bookGame() async {
    if (startTime == null || endTime == null) return;

    if (!isValidDuration(startTime!, endTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ จองได้ไม่เกิน 2 ชั่วโมง")),
      );
      return;
    }

    var url = Uri.parse("${baseUrl}booking_game.php");

    var response = await http.post(url, body: {
      "game_id": widget.game['ID'].toString(),
      "username": widget.name,
      "start_time": startTime.toString(),
      "end_time": endTime.toString(),
    });

    var data = json.decode(response.body);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(data["message"])),
    );

    if (data["status"] == "success") {
      Navigator.pop(context);
    }
  }

  ////////////////////////////////////////////////////////////
  // ✅ UI
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game['NAME'] ?? ''),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("เกม: ${widget.game['NAME']}"),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickStart,
              child: const Text("เลือกเวลาเริ่ม"),
            ),

            const SizedBox(height: 10),

            Text("เริ่ม: ${startTime ?? '-'}"),
            Text("สิ้นสุด: ${endTime ?? '-'}"),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: bookGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
              ),
              child: const Text("ยืนยันการจอง"),
            ),
          ],
        ),
      ),
    );
  }
}