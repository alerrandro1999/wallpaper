import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:troca_papel/database/pathImages.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<XFile> selectedImages = [];

  List<File> savedImages = [];

  @override
  void initState() {
    super.initState();
    loadSavedImages();
  }

  void openGallery() async {
    List<XFile>? images = await ImagePicker().pickMultiImage();

    setState(() {
      selectedImages = images;
    });

    await PathImages().saveImage(selectedImages);
  }

  Future<void> loadSavedImages() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String folderPath = '${directory.path}/imagens';

    Directory folder = Directory(folderPath);
    List<File> images =
        await folder.list().map((file) => File(file.path)).toList();

    setState(() {
      savedImages = images;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        backgroundColor: const Color(0xFF0D6847),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: savedImages.length,
          itemBuilder: (BuildContext context, int index) {
            return Image.file(savedImages[index]);
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: openGallery,
          tooltip: 'Increment',
          backgroundColor: const Color(0xFF0D6847),
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
    );
  }
}
