import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl =
    "http://localhost/flutter_booking_66710991/php_api/";

class GameBookingList extends StatefulWidget {
  const GameBookingList({super.key});

  @override
  State<GameBookingList> createState() => _GameBookingListState();
}

class _GameBookingListState extends State<GameBookingList> {
  List bookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  ////////////////////////////////////////////////////////////
  // 📥 FETCH DATA
  ////////////////////////////////////////////////////////////
  Future<void> fetchBookings() async {
    final response =
        await http.get(Uri.parse("${baseUrl}get_game_booking.php"));

    if (response.statusCode == 200) {
      setState(() {
        bookings = json.decode(response.body);
      });
    }
  }

  ////////////////////////////////////////////////////////////
  // ❌ DELETE
  ////////////////////////////////////////////////////////////
  Future<void> deleteBooking(int id) async {
    final response = await http.get(
      Uri.parse("${baseUrl}delete_game_booking.php?id=$id"),
    );

    final data = json.decode(response.body);

    if (data["success"] == true) {
      fetchBookings();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ลบการจองเรียบร้อย")),
      );
    }
  }

  ////////////////////////////////////////////////////////////
  // ⚠ CONFIRM DELETE
  ////////////////////////////////////////////////////////////
  void confirmDelete(dynamic item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("ยืนยัน"),
        content: Text("ลบการจอง ${item['NAME']} ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ยกเลิก"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteBooking(int.parse(item['id'].toString()));
            },
            child: const Text("ลบ", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  // 🎨 UI
  ////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),

      appBar: AppBar(
        title: const Text("รายการจองบอร์ดเกม"),
        backgroundColor: const Color(0xFFFF6F91),
      ),

      body: bookings.isEmpty
          ? const Center(child: Text("ยังไม่มีรายการจอง"))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final item = bookings[index];

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(

                    //////////////////////////////////////////////////
                    // 🏷 GAME NAME
                    //////////////////////////////////////////////////
                    title: Text(
                      item['NAME'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F91),
                      ),
                    ),

                    //////////////////////////////////////////////////
                    // 📝 DETAIL
                    //////////////////////////////////////////////////
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("👤 ${item['username']}"),
                        Text("📅 ${item['booking_date']}"),
                        Text(
                            "⏰ ${item['start_time']} - ${item['end_time']}"),
                      ],
                    ),

                    //////////////////////////////////////////////////
                    // ❌ DELETE
                    //////////////////////////////////////////////////
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => confirmDelete(item),
                    ),
                  ),
                );
              },
            ),
    );
  }
}