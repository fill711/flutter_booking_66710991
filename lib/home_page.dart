import 'package:flutter/material.dart';
import 'package:flutter_booking_66710991/Login.dart';
import 'package:flutter_booking_66710991/booking_list.dart';
import 'package:flutter_booking_66710991/game_booking_list.dart';
import 'login_admin.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),

      // 🔹 AppBar (โปร่ง + ลอย)
      appBar: AppBar(
        title: const Text('MEOW BOOKING'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFFFF6F91),
      ),

      // 🔹 Drawer
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(25)),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 180,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6F91), Color(0xFFFFA6C1)],
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Welcome 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFFFF6F91)),
              title: const Text('หน้าแรก'),
              onTap: () => Navigator.pop(context),
            ),

            ListTile(
              leading: const Icon(Icons.calendar_month, color: Color(0xFFFF6F91)),
              title: const Text('ข้อมูลการจอง'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookingList()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.admin_panel_settings, color: Color(0xFFFF6F91)),
              title: const Text('Admin'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginAdmin()),
                );
              },
            ),
          ],
        ),
      ),

      // 🔹 Body
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 🔥 Hero Section (ภาพ + overlay)
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/RoomA.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),

                const Positioned(
                  bottom: 20,
                  left: 30,
                  child: Text(
                    'Room Booking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
IconButton(
  icon: const Icon(Icons.gamepad_sharp),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const GameBookingList(),
      ),
    );
  },
),
            const SizedBox(height: 25),

            // 🧾 ข้อความ
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'จองห้องสันทนาการ & บอร์ดเกม\n',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🎴 Menu Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _menuCard(
                    icon: Icons.meeting_room,
                    title: 'ดูคิว การจองห้อง',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BookingList()),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _menuCard(
                    icon: Icons.gamepad,
                    title: 'เข้าสู่ระบบ Admin',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginAdmin()),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔘 ปุ่ม Login (Gradient)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6F91), Color(0xFFFFA6C1)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'เข้าสู่ระบบ User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 🔹 Widget Card เมนู
  Widget _menuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 35, color: const Color(0xFFFF6F91)),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}