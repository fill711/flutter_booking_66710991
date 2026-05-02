import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'add_product_page.dart';
import 'edit_product_page.dart';
import 'game_crud.dart';

const String baseUrl =
    "http://127.0.0.1/flutter_booking_66710991/php_api/";

class RoomPage extends StatefulWidget {
  final String name;
  const RoomPage({super.key, required this.name});

  @override
  State<RoomPage> createState() => _ProductListState();
}

class _ProductListState extends State<RoomPage> {
  List products = [];
  List filteredProducts = [];

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse("${baseUrl}show_data.php"));

      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body);
          filteredProducts = products;
        });
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    }
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products.where((product) {
        final name = product['room_name']?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}delete_product.php?id=$id"),
      );

      final data = json.decode(response.body);

      if (data["success"] == true) {
        fetchProducts();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ลบสินค้าเรียบร้อย")),
        );
      }
    } catch (e) {
      debugPrint("Delete Error: $e");
    }
  }

  void confirmDelete(dynamic product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text("ยืนยันการลบ"),
        content: Text("ต้องการลบ ${product['room_name']} ?"),
        actions: [
          TextButton(
            child: const Text("ยกเลิก"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("ลบ", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);
              deleteProduct(int.parse(product['id'].toString()));
            },
          ),
        ],
      ),
    );
  }

  void openEdit(dynamic product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProductPage(product: product),
      ),
    ).then((value) => fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),

      appBar: AppBar(
        title: const Text('ROOM & GAME'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFFF6F91),
      ),

      body: Column(
        children: [

          /// 🔥 Header
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

          /// 🔍 Search + Game Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'ค้นหาห้อง...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: filterProducts,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6F91),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.gamepad, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddGamePage(name: ''),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// 📦 LIST
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      String imageUrl =
                          "${baseUrl}images/${product['image']}";

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetail(product: product),
                                ),
                              );
                            },
                            child: Row(
                              children: [

                                /// 🖼 IMAGE
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(15)),
                                  child: Image.network(
                                    imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.image),
                                  ),
                                ),

                                /// 📝 INFO
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['room_name'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          product['location'] ?? '',
                                          style: const TextStyle(
                                              color: Colors.black54),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "รองรับ ${product['capacity']} คน",
                                          style: const TextStyle(
                                            color: Color(0xFFFF6F91),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                /// ⚙️ MENU
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      openEdit(product);
                                    } else {
                                      confirmDelete(product);
                                    }
                                  },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text('แก้ไข'),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('ลบ'),
                                    ),
                                  ],
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

      /// ➕ FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF6F91),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddProductPage(),
            ),
          ).then((value) => fetchProducts());
        },
      ),
    );
  }
}