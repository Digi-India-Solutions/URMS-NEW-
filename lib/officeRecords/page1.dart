import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddressTracePage extends StatefulWidget {
  @override
  State<AddressTracePage> createState() => _AddressTracePageState();
}

class _AddressTracePageState extends State<AddressTracePage> {
  String? traced; // 'yes' or 'no'

  // Image files for YES form
  File? yesImage1;
  File? yesImage2;

  // Image files for NO form
  File? noImage1;
  File? noImage2;

  final picker = ImagePicker();

  Future<void> pickImage(bool isYesForm, int imageNumber) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isYesForm) {
          if (imageNumber == 1) yesImage1 = File(pickedFile.path);
          if (imageNumber == 2) yesImage2 = File(pickedFile.path);
        } else {
          if (imageNumber == 1) noImage1 = File(pickedFile.path);
          if (imageNumber == 2) noImage2 = File(pickedFile.path);
        }
      });
    }
  }

  Widget imagePickerBlock(bool isYesForm, int imageNumber, File? imageFile) {
    return GestureDetector(
      onTap: () => pickImage(isYesForm, imageNumber),
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: imageFile != null
            ? Image.file(imageFile, fit: BoxFit.cover)
            : Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.image, size: 50, color: Colors.grey),
              SizedBox(height: 8),
              Text('Upload Image'),
            ],
          ),
        ),
      ),
    );
  }

  Widget formYes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Form for YES:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Field 1 (YES form)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Field 2 (YES form)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(true, 1, yesImage1),
            imagePickerBlock(true, 2, yesImage2),
          ],
        ),
      ],
    );
  }

  Widget formNo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Form for NO:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Field 1 (NO form)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Field 2 (NO form)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(false, 1, noImage1),
            imagePickerBlock(false, 2, noImage2),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Traced?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Is address traced?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Yes'),
              leading: Radio<String>(
                value: 'yes',
                groupValue: traced,
                onChanged: (value) {
                  setState(() {
                    traced = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('No'),
              leading: Radio<String>(
                value: 'no',
                groupValue: traced,
                onChanged: (value) {
                  setState(() {
                    traced = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            if (traced == 'yes') formYes(),
            if (traced == 'no') formNo(),
          ],
        ),
      ),
    );
  }
}
