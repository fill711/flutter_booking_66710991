import 'package:flutter/material.dart';
import 'package:flutter_booking_66710991/game_booking_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'add_game.dart';
import 'game_booking_page.dart';

const String baseUrl =
    "http://localhost/flutter_booking_66710991/php_api/";

class GameList extends StatefulWidget {
  final String name;
  const GameList({super.key, required this.name});

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  List games = [];
  List filteredGames = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  ////////////////////////////////////////////////////////////
  // ✅ FETCH GAME
  ////////////////////////////////////////////////////////////

  Future<void> fetchGames() async {
    final response =
        await http.get(Uri.parse("${baseUrl}show_datagame.php"));

    if (response.statusCode == 200) {
      setState(() {
        games = json.decode(response.body);
        filteredGames = games;
      });
    }
  }

  ////////////////////////////////////////////////////////////
  // ✅ SEARCH
  ////////////////////////////////////////////////////////////

  void searchGame(String keyword) {
    final results = games.where((game) {
      final name = (game['NAME'] ?? '').toString().toLowerCase();
      return name.contains(keyword.toLowerCase());
    }).toList();

    setState(() {
      filteredGames = results;
    });
  }

  ////////////////////////////////////////////////////////////
  // ✅ UI
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),

      appBar: AppBar(
        title: const Text("BOARD GAME"),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF6F91),
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
            child: const Text(
              "เลือกบอร์ดเกม 🎲",
              style: TextStyle(
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
                hintText: "ค้นหาเกม...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: searchGame,
            ),
          ),

          const SizedBox(height: 10),

          /// 📦 LIST
          Expanded(
            child: filteredGames.isEmpty
                ? const Center(child: Text("ไม่พบข้อมูลเกม"))
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: filteredGames.length,
                    itemBuilder: (context, index) {
                      final game = filteredGames[index];

                      String imageUrl =
                          "${baseUrl}images/${game['image'] ?? ''}";

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Material(
                          elevation: 6,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),

                            //////////////////////////////////////////////////
                            // 👉 กดเข้า DETAIL
                            //////////////////////////////////////////////////
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GameDetail(
                                    game: game,
                                    name: widget.name,
                                  ),
                                ),
                              );
                            },

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                /// 🖼 IMAGE
                                ClipRRect(
                                  borderRadius:
                                      const BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                  child: Image.network(
                                    imageUrl,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.image),
                                  ),
                                ),

                                /// 📝 INFO
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              game['NAME'] ?? '-',
                                              style: const TextStyle(
                                                fontWeight:
                                                    FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "👥 ${game['CAPACITY'] ?? '-'} คน",
                                              style: const TextStyle(
                                                color:
                                                    Color(0xFFFF6F91),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //////////////////////////////////////////////////
                                      // 🔘 BUTTON "จอง"
                                      //////////////////////////////////////////////////
                                      ElevatedButton(
                                        style: ElevatedButton
                                            .styleFrom(
                                          backgroundColor:
                                              const Color(
                                                  0xFFFF6F91),
                                        ),
                                        child: const Text("จอง"),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  GameBookingPage(
                                                game: game, // ✅ สำคัญ
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

//////////////////////////////////////////////////////////////
// ✅ DETAIL PAGE
//////////////////////////////////////////////////////////////

class GameDetail extends StatelessWidget {
  final dynamic game;
  final String name;

  const GameDetail({super.key, required this.game, required this.name});

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        "${baseUrl}images/${game['image'] ?? ''}";

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text(game['NAME'] ?? ''),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Image.network(
                imageUrl,
                height: 200,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image, size: 100),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              game['NAME'] ?? '-',
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text("รายละเอียด: ${game['INFO'] ?? '-'}"),

            const SizedBox(height: 10),

            Text("เล่นได้: ${game['CAPACITY'] ?? '-'} คน"),

            const SizedBox(height: 20),

            //////////////////////////////////////////////////
            // 🔘 BUTTON "จองเกมนี้"
            //////////////////////////////////////////////////
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
                child: const Text("จองเกมนี้"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GameBookingPage(
                        game: game, // ✅ สำคัญ
                        name: name,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}