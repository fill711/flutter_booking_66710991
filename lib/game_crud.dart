import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'add_game.dart';
import 'edit_game_page.dart';

//////////////////////////////////////////////////////////////
// ✅ CONFIG
//////////////////////////////////////////////////////////////

const String baseUrl =
    "http://localhost/flutter_booking_66710991/php_api/"; 
// 🔥 ใช้ 10.0.2.2 ถ้าเป็น emulator

//////////////////////////////////////////////////////////////
// ✅ HELPER (แก้ปัญหา key ไม่ตรง)
//////////////////////////////////////////////////////////////

String getName(p) => p['NAME'] ?? p['name'] ?? '';
String getLoca(p) => p['LOCATION'] ?? p['location'] ?? '';
String getCapacity(p) => p['CAPACITY'] ?? p['capacity'] ?? '';
String getInfo(p) => p['INFO'] ?? p['info'] ?? '';
String getImage(p) => p['image'] ?? p['IMAGE'] ?? '';

//////////////////////////////////////////////////////////////
// ✅ PRODUCT LIST PAGE
//////////////////////////////////////////////////////////////

class AddGamePage extends StatefulWidget {
  final String name;
  const AddGamePage({super.key, required this.name});

  @override
  State<AddGamePage> createState() => _AddGamePageState();
}

class _AddGamePageState extends State<AddGamePage> {
  List products = [];
  List filteredProducts = [];

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  ////////////////////////////////////////////////////////////
  // ✅ FETCH DATA
  ////////////////////////////////////////////////////////////

  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse("${baseUrl}show_datagame.php"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          products = data;
          filteredProducts = data;
        });

        print("DATA: $data"); // 🔥 debug
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    }
  }

  ////////////////////////////////////////////////////////////
  // ✅ SEARCH
  ////////////////////////////////////////////////////////////

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products.where((product) {
        final name = getName(product).toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

  ////////////////////////////////////////////////////////////
  // ✅ DELETE
  ////////////////////////////////////////////////////////////

  Future<void> deleteProduct(int id) async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}delete_game.php?ID=$id"),
      );

      final data = json.decode(response.body);

      if (data["success"] == true) {
        fetchProducts();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ลบบอร์ดเกมเรียบร้อย")),
        );
      }
    } catch (e) {
      debugPrint("Delete Error: $e");
    }
  }

  ////////////////////////////////////////////////////////////
  // ✅ CONFIRM DELETE
  ////////////////////////////////////////////////////////////

  void confirmDelete(dynamic product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("ยืนยันการลบ"),
        content: Text("ต้องการลบ ${getName(product)} ?"),
        actions: [
          TextButton(
            child: const Text("ยกเลิก"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("ลบ"),
            onPressed: () {
              Navigator.pop(context);
              deleteProduct(int.parse(product['ID'].toString()));
            },
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  // ✅ OPEN EDIT PAGE
  ////////////////////////////////////////////////////////////

  void openEdit(dynamic product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditGAMEPage(product: product),
      ),
    ).then((value) => fetchProducts());
  }

  ////////////////////////////////////////////////////////////
  // ✅ UI
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: const Text('แก้ไขบอร์ดเกม '),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [

          /// 🔍 SEARCH
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Game',
                prefixIcon: const Icon(Icons.search, color: Colors.pink),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: filterProducts,
            ),
          ),

          /// 📦 LIST
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      String imageUrl =
                          "${baseUrl}images/${getImage(product)}";

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: Image.network(
                            imageUrl,
                            width: 60,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image),
                          ),
                          title: Text(getName(product)),
                          subtitle: Text(getInfo(product)),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') openEdit(product);
                              if (value == 'delete') confirmDelete(product);
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                  value: 'edit', child: Text('แก้ไข')),
                              PopupMenuItem(
                                  value: 'delete', child: Text('ลบ')),
                            ],
                          ),
                          onTap: () {
  print("CLICK: $product"); // 👈 ใส่ตรงนี้

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ProductDetail(product: product),
    ),
  );
}
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      /// ➕ ADD
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const InsertGamePage(),
            ),
          ).then((value) => fetchProducts());
        },
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// ✅ DETAIL PAGE
//////////////////////////////////////////////////////////////

class ProductDetail extends StatelessWidget {
  final dynamic product;

  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        "${baseUrl}images/${getImage(product)}";

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text(getName(product)),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🖼 IMAGE
            Center(
              child: Image.network(
                imageUrl,
                height: 200,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image, size: 100),
              ),
            ),

            const SizedBox(height: 20),

            /// 🏷 NAME
            Text(
              getName(product),
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            /// 📝 INFO
            Text("รายละเอียด: ${getInfo(product)}"),

            const SizedBox(height: 10),

            /// 👥 CAPACITY
            Text("เล่นได้มากสุด: ${getCapacity(product)} คน"),

                    /// 📝 Location
           

            const SizedBox(height: 10),

            /// 👥 CAPACITY
           
            
            
          ],
        ),
      ),
    );
  }
}