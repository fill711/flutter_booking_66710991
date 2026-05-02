import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

const String baseUrl =
    "http://127.0.0.1/flutter_booking_66710991/php_api/";

class EditGAMEPage extends StatefulWidget {
  final dynamic product;

  const EditGAMEPage({super.key, required this.product});

  @override
  State<EditGAMEPage> createState() => _EditGAMEPageState();
}

class _EditGAMEPageState extends State<EditGAMEPage> {

  late TextEditingController nameController;
  late TextEditingController infoController;
  late TextEditingController capacityController;

  XFile? selectedImage;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.product['NAME'].toString());

    infoController =
        TextEditingController(text: widget.product['INFO'].toString());

    capacityController =
        TextEditingController(text: widget.product['CAPACITY'].toString());
  }

  ////////////////////////////////////////////////////////////
  // ✅ PICK IMAGE
  ////////////////////////////////////////////////////////////

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile;
      });
    }
  }

  ////////////////////////////////////////////////////////////
  // ✅ UPDATE PRODUCT + IMAGE
  ////////////////////////////////////////////////////////////

  Future<void> updateProduct() async {
    try {

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${baseUrl}update_game_image.php"),
      );

      ////////////////////////////////////////////////////////
      // ✅ Fields
      ////////////////////////////////////////////////////////

      request.fields['ID'] = widget.product['ID'].toString();
      request.fields['NAME'] = nameController.text;
      request.fields['INFO'] = infoController.text;
      request.fields['CAPACITY'] = capacityController.text;
      request.fields['old_image'] = widget.product['image'];

      ////////////////////////////////////////////////////////
      // ✅ Image (ถ้ามี)
      ////////////////////////////////////////////////////////

      if (selectedImage != null) {

        if (kIsWeb) {

          final bytes = await selectedImage!.readAsBytes();

          request.files.add(
            http.MultipartFile.fromBytes(
              'image',
              bytes,
              filename: selectedImage!.name,
            ),
          );

        } else {

          request.files.add(
            await http.MultipartFile.fromPath(
              'image',
              selectedImage!.path,
            ),
          );
        }
      }

      ////////////////////////////////////////////////////////
      // ✅ Send
      ////////////////////////////////////////////////////////

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      final data = json.decode(responseData);

      if (data["success"] == true) {

        Navigator.pop(context, true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("แก้ไขเรียบร้อย")),
        );
      }

    } catch (e) {
      debugPrint("Update Error: $e");
    }
  }

  ////////////////////////////////////////////////////////////
  // ✅ UI
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    String imageUrl =
        "${baseUrl}images/${widget.product['image']}";

    return Scaffold(
      appBar: AppBar(title: const Text("แก้ไขบอร์ดเกม")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: SingleChildScrollView(
          child: Column(
            children: [

              //////////////////////////////////////////////////
              // 🖼 IMAGE PREVIEW
              //////////////////////////////////////////////////

              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: selectedImage == null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported),
                        )
                      : kIsWeb
                          ? Image.network(
                              selectedImage!.path,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(selectedImage!.path),
                              fit: BoxFit.cover,
                            ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "ชื่อบอร์ดเกม"),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: infoController,
                decoration: const InputDecoration(labelText: "คำอธิบาย"),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: capacityController,
                decoration: const InputDecoration(labelText: "จำนวนคน"),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updateProduct,
                  child: const Text("บันทึก"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}