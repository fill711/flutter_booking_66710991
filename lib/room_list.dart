import 'package:flutter/material.dart';
import 'package:flutter_booking_66710991/home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'booking_page.dart';
import 'booking_list.dart';

const String baseUrl = "http://localhost/flutter_booking_66710991/php_api/";

class RoomList extends StatefulWidget {
  final String name;

  const RoomList({super.key, required this.name});

  @override
  State<RoomList> createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  List rooms = [];
  List filteredRooms = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    final response =
        await http.get(Uri.parse("${baseUrl}get_rooms.php"));

    if (response.statusCode == 200) {
      setState(() {
        rooms = json.decode(response.body);
        filteredRooms = rooms;
      });
    }
  }

  void searchRoom(String keyword) {
    final results = rooms.where((room) {
      final name = room['room_name'].toString().toLowerCase();
      return name.contains(keyword.toLowerCase());
    }).toList();

    setState(() {
      filteredRooms = results;
    });
  }

  void logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text("ยืนยัน"),
        content: const Text("ต้องการออกจากระบบหรือไม่?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ยกเลิก"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomePage(),
                ),
                (route) => false,
              );
            },
            child: const Text("ออกจากระบบ",
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),

      appBar: AppBar(
        title: const Text("ROOM BOOKING"),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF6F91),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BookingList(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),

      body: Column(
        children: [

          /// 🔥 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF6F91),
                  Color(0xFFFFA6C1),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Text(
              "สวัสดี ${widget.name} 👋",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// 🔍 SEARCH
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "ค้นหาห้อง...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: searchRoom,
            ),
          ),

          const SizedBox(height: 10),

          /// 📦 ROOM LIST
          Expanded(
            child: filteredRooms.isEmpty
                ? const Center(child: Text("ไม่พบข้อมูลห้อง"))
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: filteredRooms.length,
                    itemBuilder: (context, index) {
                      final room = filteredRooms[index];

                      String imageUrl =
                          "${baseUrl}images/${room['image'] ?? ''}";

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Material(
                          elevation: 6,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookingPage(
                                    room: room,
                                    name: widget.name,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                /// 🖼 IMAGE + OVERLAY
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          const BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                      child: Image.network(
                                        imageUrl,
                                        height: 160,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.image),
                                      ),
                                    ),

                                    Container(
                                      height: 160,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top:
                                                    Radius.circular(20)),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black
                                                .withOpacity(0.3),
                                            Colors.transparent,
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: Text(
                                        room['room_name'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                /// 📝 INFO
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text(
                                              "📍 ${room['location']}",
                                              style: const TextStyle(
                                                  color:
                                                      Colors.black54),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "👥 ${room['capacity']} คน",
                                              style: const TextStyle(
                                                color:
                                                    Color(0xFFFF6F91),
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      /// 🔘 BUTTON
                                      ElevatedButton(
                                        style: ElevatedButton
                                            .styleFrom(
                                          backgroundColor:
                                              const Color(
                                                  0xFFFF6F91),
                                          shape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius
                                                    .circular(10),
                                          ),
                                        ),
                                        child: const Text("จอง"),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  BookingPage(
                                                room: room,
                                                name: widget.name,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}