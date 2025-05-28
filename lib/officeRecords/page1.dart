import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddressTracePage extends StatefulWidget {
  final String applicantName;
  final String address;
  final String contactNumber;

  const AddressTracePage({
    super.key,
    required this.applicantName,
    required this.address,
    required this.contactNumber,
  });

  @override
  State<AddressTracePage> createState() => _AddressTracePageState();
}

class _AddressTracePageState extends State<AddressTracePage> {
  String? traced;
  String? companyExist;
  String? entryAllowed;
  String? detailShared;
  // 'yes' or 'no'

  // Shared image files for both YES and NO form
  File? image1;
  File? image2;

  final picker = ImagePicker();

  Future<void> pickImage(int imageNumber) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) image1 = File(pickedFile.path);
        if (imageNumber == 2) image2 = File(pickedFile.path);
      });
    }
  }

  Widget imagePickerBlock(int imageNumber, File? imageFile) {
    return GestureDetector(
      onTap: () => pickImage(imageNumber),
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
              Icon(Icons.camera_alt, size: 50, color: Colors.grey),
              SizedBox(height: 8),
              Text('Capture Image'),
            ],
          ),
        ),
      ),
    );
  }

  Widget addressTracedYes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text('Form for YES:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        const Text(
          'Company Exist?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ListTile(
          title: const Text('Yes'),
          leading: Radio<String>(
            value: 'yes',
            groupValue: companyExist,
            onChanged: (value) => setState(() => companyExist = value),
          ),
        ),
        ListTile(
          title: const Text('No'),
          leading: Radio<String>(
            value: 'no',
            groupValue: companyExist,
            onChanged: (value) => setState(() => companyExist = value),
          ),
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
        if (companyExist == 'yes') companyExistYes(),
        if (companyExist == 'no') companyExistNo(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget addressTracedNo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Form for NO:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget companyExistYes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text('Form for YES:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        const Text(
          'Entry Allowed?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ListTile(
          title: const Text('Yes'),
          leading: Radio<String>(
            value: 'yes',
            groupValue: entryAllowed,
            onChanged: (value) => setState(() => entryAllowed = value),
          ),
        ),
        ListTile(
          title: const Text('No'),
          leading: Radio<String>(
            value: 'no',
            groupValue: entryAllowed,
            onChanged: (value) => setState(() => entryAllowed = value),
          ),
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
        if (entryAllowed == 'yes') entryAllowedYes(),
        if (entryAllowed == 'no') entryAllowedNo(),
        const SizedBox(height: 40),
      ],
    );
  }


  Widget companyExistNo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Form for NO:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
      ],
    );
  }


  Widget entryAllowedYes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text('Form for YES:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        const Text(
          'Details Shared By Colleague? ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ListTile(
          title: const Text('Confirmed'),
          leading: Radio<String>(
            value: 'confirmed',
            groupValue: detailShared,
            onChanged: (value) => setState(() => detailShared = value),
          ),
        ),
        ListTile(
          title: const Text('Not Confirmed'),
          leading: Radio<String>(
            value: 'notConfirmed',
            groupValue: detailShared,
            onChanged: (value) => setState(() => detailShared = value),
          ),
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
        if (detailShared == 'confirmed') detailsSharedYes(),
        if (detailShared == 'notConfirmed') detailsSharedNo(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget entryAllowedNo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Form for NO:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget detailsSharedYes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Form for Yes:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
      ],
    );
  }


  Widget detailsSharedNo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Form for NO:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Address Traced?')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Applicant: ${widget.applicantName}", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Address: ${widget.address}"),
            Text("Contact: ${widget.contactNumber}"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                imagePickerBlock(1, image1),
                imagePickerBlock(2, image2),
              ],
            ),
            const Text(
              'Is address traced?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Yes'),
              leading: Radio<String>(
                value: 'yes',
                groupValue: traced,
                onChanged: (value) => setState(() => traced = value),
              ),
            ),
            ListTile(
              title: const Text('No'),
              leading: Radio<String>(
                value: 'no',
                groupValue: traced,
                onChanged: (value) => setState(() => traced = value),
              ),
            ),
            const SizedBox(height: 20),
            if (traced == 'yes') addressTracedYes(),
            if (traced == 'no') addressTracedNo(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
