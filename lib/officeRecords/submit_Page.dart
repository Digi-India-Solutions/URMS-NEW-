import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../screens/homePage.dart';

class SubmitPage extends StatefulWidget {
  final Map<String, dynamic> formData;

  const SubmitPage({Key? key, required this.formData}) : super(key: key);

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  bool isSubmitting = false;
  String? submissionResult;
  String? generatedRemark;

  @override
  void initState() {
    super.initState();
    generatedRemark = generateRemark(widget.formData);
  }

  String generateRemark(Map<String, dynamic> data) {
    final addressTraced = data['addressTraced']?.toLowerCase();
    final companyExist = data['companyExist']?.toLowerCase();
    final entryAllowed = data['entryAllowed']?.toLowerCase();
    final detailSharedByColleague = data['detailSharedByColleague']?.toLowerCase();

    if (addressTraced == 'no') {
      return "Visited at given address (${data['address']}) we found that address was difficult to trace due to ${data['reasonOfUntrace']} and ${data['requiredToTrace']}, so we made a call to applicant but at visit time applicant ${data['callingResponse']}. We also met with some local person in same locality but they are not able to guide the address. Our last visit is ${data['lastLocation']}\n(Other Observation: ${data['otherObservation']})";
    } else if (addressTraced == 'yes' && companyExist == 'no') {
      return "Visited at given address (${data['address']}) found that address was trace then we met with neighbor ${data['metNeighbourFirst']} and ${data['metNeighbourSecond']} both are confirmed that company not exist at given address. Currently ${data['currentCompanyExists']} exist at given address. Then we call to applicant ${data['callingResponse']}. Building built from ${data['totalFloor']} and office exist at ${data['permissiveExistsOnWhichFloor']} with an area approx. ${data['landArea']} Sq. Feet in Locality of ${data['localityOfAddress']}.\n(Other Observation: ${data['otherObservation']})";
    } else if (addressTraced == 'yes' && companyExist == 'yes' && entryAllowed == 'no') {
      return "Visited at given address (${data['address']}) found that entry not allowed then we call to applicant ${data['callingResponse']}. Building built from ${data['totalFloor']} and premises exist at ${data['permissiveExistsOnWhichFloor']} with an area approx. ${data['landArea']} Sq. Feet in Locality of ${data['localityOfAddress']}. Name board ‘${data['nameBoardSeen']}’.\nWe also met with ${data['metPersonName']} working as ${data['metPersonDesignation']} who ${data['anyConfirmation']}.\n(Other Observation:${data['otherObservation']})";
    } else if (addressTraced == 'yes' && companyExist == 'yes' && entryAllowed == 'yes' && detailSharedByColleague == 'not confirmed') {
      return "Visited at given address (${data['address']}) firstly we met with colleague ${data['firstColleagueName']} working as ${data['firstColleagueDesignation']} & ${data['secondColleagueName']} working as ${data['secondColleagueDesignation']}, both not confirmed applicant name and working. Then we call to applicant ${data['callingResponse']}. Building built from ${data['totalFloor']} and office exist at ${data['permissiveExistsOnWhichFloor']} with an area approx. ${data['landArea']} Sq. Feet in Locality of ${data['localityOfAddress']}. Name board '${data['nameBoardSeen']}'. Nature of business related to ${data['natureOfBusiness']}. Total employee are ${data['totalEmployee']} but at visit time employees seen are ${data['seenEmployee']}. Setup and activity is ${data['setupAndActivity']}.\n(Other observation: ${data['otherObservation']})";
    }else if (addressTraced == 'yes' && companyExist == 'yes' && entryAllowed == 'yes' && detailSharedByColleague == 'confirmed') {
      return "Visited at given address (${data['address']}) we met ${data['metPersonName']} working as ${data['metPersonDesignation']}, he confirmed that applicant working here as a ${data['applicantDesignation']} from ${data['tenureOfWorking']}. Building built from ${data['totalFloor']} and office exist at ${data['permissiveExistsOnWhichFloor']} with an area approx. ${data['landArea']} Sq. Feet in ${data['localityOfAddress']} locality. Name board '${data['nameBoardSeen']}'. Nature of business related to ${data['natureOfBusiness']}. Total employee are ${data['totalEmployee']} but at visit time employees seen are ${data['seenEmployee']}. Setup and activity is ${data['setupAndActivity']}. Visit time applicant ${data['idCardShown']}.\nColleague confirmed :- we met with ${data['firstColleagueName']} working as ${data['firstColleagueDesignation']} and ${data['secondColleagueName']} working as ${data['secondColleagueDesignation']} both ${data['detailSharedByColleague']} Details shared by Colleague about applicant and Working applicant name and working.\n(Other observation: ${data['otherObservation']})";
    }else {
      return 'No Remark';
    }
  }

  Future<void> submitData() async {
    setState(() {
      isSubmitting = true;
      submissionResult = null;
    });

    try {
      var uri = Uri.parse("https://api.zaikanuts.shop/api/send-record");
      var request = http.MultipartRequest('POST', uri);
      final data = widget.formData;

      final Map<String, String> fieldMappings = {
        'taskId': 'taskID',
        'addressTraced': 'addressTraced',
        'reasonOfUntrace': 'reasonOfUntraced',
        'requiredToTrace': 'requireToTrace',
        'callingResponse': 'callingResponse',
        'lastLocation': 'yourLocatation',
        'otherObservation': 'otherObservation',
        'remark': 'remark',
        'companyExist': 'companyExits',
        'metNeighbourFirst': 'metneighboreFirst',
        'metNeighbourSecond': 'metneighboreSecond',
        'confirmationAboutCompany': 'confrimationAboutCompany',
        'currentCompanyExists': 'currentCompanyExitThere',
        'totalFloor': 'totalFloor',
        'permissiveExistsOnWhichFloor': 'permissiveExitWhichFloor',
        'landArea': 'landArea',
        'localityOfAddress': 'localityOfAddress',
        'entryAllow': 'entryAllow',
        'nameBoardSeen': 'nameBoardSeen',
        'metPersonName': 'metPersonName',
        'metPersonDesignation': 'designation',
        'anyConfirmation': 'anyConfirmation',
        'firstColleagueName': 'firstColleagueName',
        'secondColleagueName': 'secondColleagueName',
        'detailsSharedByColleague': 'detailsSharedByColleague',
        'totalEmployee': 'totalEmployee',
        'seenEmployee': 'seenEmployee',
        'natureOfBusiness': 'natureOfBusiness',
        'setupAndActivity': 'setupAndActivity',
        'applicantDesignation': 'appliciantDesignation',
        'tenureOfWorking': 'tenureOfBusiness',
        'idCardShown': 'idCardShown',
        'latlang': 'latlang',
      };

      for (var entry in fieldMappings.entries) {
        final key = entry.key;
        final backendKey = entry.value;

        if (key == 'remark') {
          request.fields[backendKey] = generatedRemark ?? '';
        } else {
          final value = data[key];
          if (value != null) {
            request.fields[backendKey] = value.toString();
          }
        }
      }

      for (int i = 1; i <= 2; i++) {
        File? imageFile = data['image$i'];
        if (imageFile is File) {
          request.files.add(await http.MultipartFile.fromPath(
            'addressImage',
            imageFile.path,
            filename: path.basename(imageFile.path),
          ));
        }
      }

      for (int i = 3; i <= 6; i++) {
        File? imageFile = data['image$i'];
        if (imageFile is File) {
          request.files.add(await http.MultipartFile.fromPath(
            'images',
            imageFile.path,
            filename: path.basename(imageFile.path),
          ));
        }
      }

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // DEBUG: Print fields
      print("Sending fields:");
      request.fields.forEach((key, value) => print("$key: $value"));

      // DEBUG: Print files
      print("Sending files:");
      for (var file in request.files) {
        print("${file.field} -> ${file.filename} (${file.length}) bytes");
      }



      print("Status Code: ${response.statusCode}");
      print("Response Body: $responseBody");




      if (response.statusCode == 200) {
        setState(() {
          submissionResult = 'Submitted successfully!';
        });


        // Wait a moment for the UI to show the message (optional)
        await Future.delayed(Duration(milliseconds: 300));

        // Navigate to SuccessPage
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => HomePage(),
            settings: RouteSettings(arguments: 'Submission successful'),
          ),
              (Route<dynamic> route) => false, // This clears the entire back stack
        );



      } else {
        setState(() {
          submissionResult = 'Submission failed. Code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        submissionResult = 'Error: $e';
      });
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.formData;

    return Scaffold(
      appBar: AppBar(title: const Text('Summary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Applicant Name: ${data['applicantName'] ?? ''}"),
            Text("Address: ${data['address'] ?? ''}"),
            Text("Contact Number: ${data['contactNumber'] ?? ''}"),
            const SizedBox(height: 10),
            Text(
              "Summary:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              generatedRemark ?? '',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            const Text("Address Images:", style: TextStyle(fontWeight: FontWeight.bold)),
            for (int i = 1; i <= 2; i++)
              if (data['image$i'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.file(data['image$i']),
                ),
            const SizedBox(height: 20),
            const Text("Location Images:", style: TextStyle(fontWeight: FontWeight.bold)),
            for (int i = 3; i <= 6; i++)
              if (data['image$i'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.file(data['image$i']),
                ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: isSubmitting ? null : submitData,
                child: isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Submit'),
              ),
            ),
            SizedBox(height: 50,),
            if (submissionResult != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  submissionResult!,
                  style: TextStyle(
                    color: submissionResult!.contains('success')
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(height: 50,),

          ],
        ),
      ),
    );
  }
}


