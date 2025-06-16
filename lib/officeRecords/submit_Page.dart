import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
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
    }
    else if (addressTraced == 'yes' && companyExist == 'no') {
      return "Visited at given address (${data['address']}) found that address was trace then we met with neighbor ${data['metNeighbourFirst']} and ${data['metNeighbourSecond']} both are confirmed that company not exist at given address. Currently ${data['currentCompanyExists']} exist at given address. Then we made a call to applicant but at that time applicant ${data['callingResponse']}. Building built from ${data['totalFloor']} and office exist at ${data['permissiveExistsOnWhichFloor']} with an area approx. ${data['landArea']} Sq. Feet in Locality of ${data['localityOfAddress']}.\n(Other Observation: ${data['otherObservation']})";
    }
    else if (addressTraced == 'yes' && companyExist == 'yes' && entryAllowed == 'no') {
      return "Visited at given address (${data['address']}) found that entry not allowed then we call to applicant but the applicant ${data['callingResponse']}. Building built from ${data['totalFloor']} and office exist at ${data['permissiveExistsOnWhichFloor']} with an area approx. ${data['landArea']} Sq. Feet in Locality of ${data['localityOfAddress']}. Name board ‘${data['nameBoardSeen']}’.\nWe also met with ${data['metPersonName']} working as ${data['metPersonDesignation']} who did ${data['anyConfirmation']}.\n(Other Observation:${data['otherObservation']})";
    }
    else if (addressTraced == 'yes' && companyExist == 'yes' && entryAllowed == 'yes' && detailSharedByColleague == 'not confirmed') {
      return "Visited at given address (${data['address']}) firstly we met with colleague ${data['firstColleagueName']} working as ${data['firstColleagueDesignation']} & also met with ${data['secondColleagueName']} working as ${data['secondColleagueDesignation']}, both not confirmed applicant name and working. Then we call to applicant but applicant ${data['callingResponse']}. Building built from ${data['totalFloor']} and office exist at ${data['permissiveExistsOnWhichFloor']} with an area approx. ${data['landArea']} Sq. Feet in Locality of ${data['localityOfAddress']}. Name board '${data['nameBoardSeen']}'. Nature of business related to ${data['natureOfBusiness']}. Total employee are ${data['totalEmployee']} but at visit time, ${data['seenEmployee']} employees were seen. Setup and activity is ${data['setupAndActivity']}.\n(Other observation: ${data['otherObservation']})";
    }
    else if (addressTraced == 'yes' && companyExist == 'yes' && entryAllowed == 'yes' && detailSharedByColleague == 'confirmed') {
      return "Visited at given address (${data['address']}) we met ${data['metPersonName']} working as ${data['metPersonDesignation']}, he confirmed that applicant working here as a ${data['applicantDesignation']} from ${data['tenureOfWorking']}. Building built from ${data['totalFloor']} and office exist at ${data['permissiveExistsOnWhichFloor']} with an area approx. ${data['landArea']} Sq. Feet in ${data['localityOfAddress']} locality. Name board '${data['nameBoardSeen']}'. Nature of business related to ${data['natureOfBusiness']}. Total employee are ${data['totalEmployee']} but at visit time ${data['seenEmployee']} employees were seen. Setup and activity is ${data['setupAndActivity']}. At Visit time, applicant ${data['idCardShown']}.\nColleague confirmed :- we met with ${data['firstColleagueName']} working as ${data['firstColleagueDesignation']} and ${data['secondColleagueName']} working as ${data['secondColleagueDesignation']} both ${data['detailSharedByColleague']} Details shared by Colleague about applicant's name and working.\n(Other observation: ${data['otherObservation']})";
    }
    else {
      return 'No Remark';
    }
  }

//   Future<void> submitData() async {
//     setState(() {
//       isSubmitting = true;
//       submissionResult = null;
//     });

//     try {
//       var uri = Uri.parse("https://api.zaikanuts.shop/api/send-record");
//       var request = http.MultipartRequest('POST', uri);
//       final data = widget.formData;

//       final Map<String, String> fieldMappings = {
//         // ... your field mappings
//         'taskId': 'taskID',
//               'addressTraced': 'addressTraced',
//               'reasonOfUntrace': 'reasonOfUntraced',
//               'requiredToTrace': 'requireToTrace',
//               'callingResponse': 'callingResponse',
//               'lastLocation': 'yourLocatation',
//               'otherObservation': 'otherObservation',
//               'remark': 'remark',
//               'companyExist': 'companyExits',
//               'metNeighbourFirst': 'metneighboreFirst',
//               'metNeighbourSecond': 'metneighboreSecond',
//               'confirmationAboutCompany': 'confrimationAboutCompany',
//               'currentCompanyExists': 'currentCompanyExitThere',
//               'totalFloor': 'totalFloor',
//               'permissiveExistsOnWhichFloor': 'permissiveExitWhichFloor',
//               'landArea': 'landArea',
//               'localityOfAddress': 'localityOfAddress',
//               'entryAllow': 'entryAllow',
//               'nameBoardSeen': 'nameBoardSeen',
//               'metPersonName': 'metPersonName',
//               'metPersonDesignation': 'designation',
//               'anyConfirmation': 'anyConfirmation',
//               'firstColleagueName': 'firstColleagueName',
//               'secondColleagueName': 'secondColleagueName',
//               'detailsSharedByColleague': 'detailsSharedByColleague',
//               'totalEmployee': 'totalEmployee',
//               'seenEmployee': 'seenEmployee',
//               'natureOfBusiness': 'natureOfBusiness',
//               'setupAndActivity': 'setupAndActivity',
//               'applicantDesignation': 'appliciantDesignation',
//               'tenureOfWorking': 'tenureOfBusiness',
//               'idCardShown': 'idCardShown',
//               'latlang': 'latlang',
//       };

//       for (var entry in fieldMappings.entries) {
//         final key = entry.key;
//         final backendKey = entry.value;

//         if (key == 'remark') {
//           request.fields[backendKey] = generatedRemark ?? '';
//         } else {
//           final value = data[key];
//           if (value != null) {
//             request.fields[backendKey] = value.toString();
//           }
//         }
//       }

//       // Add images
//       for (int i = 1; i <= 6; i++) {
//         File? imageFile = data['image$i'];
//         if (imageFile is File) {
//           request.files.add(await http.MultipartFile.fromPath(
//             i <= 2 ? 'addressImage' : 'images',
//             imageFile.path,
//             filename: path.basename(imageFile.path),
//           ));
//         }
//       }

// // 2. Add lat/long and timestamp arrays manually
// for (int i = 1; i <= 6; i++) {
//   String? latLong = data['image${i}LatLong'];
//   DateTime? timestamp = data['image${i}Timestamp'];
//   String? timestampStr = timestamp?.toIso8601String();

//   if (latLong != null) {
//     request.fields.addAll({
//       i <= 2 ? 'addressImageLatitude[]' : 'imagesLatitude[]': latLong,
//     });
//   }

//   if (timestampStr != null) {
//     request.fields.addAll({
//       i <= 2 ? 'addressImageTimestamp[]' : 'imagesTimestamp[]': timestampStr,
//     });
//   }
// }


    

//       var response = await request.send();
//       final responseBody = await response.stream.bytesToString();

//       if (response.statusCode == 200) {
//         setState(() {
//           submissionResult = 'Submitted successfully!';
//         });

//         await Future.delayed(Duration(milliseconds: 300));
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(
//             builder: (context) => HomePage(),
//             settings: RouteSettings(arguments: 'Submission successful'),
//           ),
//               (Route<dynamic> route) => false,
//         );
//       } else {
//         setState(() {
//           submissionResult = 'Submission failed. Code: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       // 🚨 Save offline and show SnackBar
//       await storeFormDataToSharedPrefs(widget.formData, generatedRemark, context);

//       setState(() {
//         submissionResult = 'Saved offline due to network error';
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("No internet. Data saved offline."),
//           backgroundColor: Colors.orange,
//           duration: Duration(seconds: 3),
//         ),
//       );

//       // ✅ Debug print
//       await debugPrintOfflineSubmission();

//       setState(() {
//         submissionResult = 'Saved offline due to error: $e';
//       });
//     }
//      finally {
//       setState(() {
//         isSubmitting = false;
//       });
//     }
//   }




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
      'image1LatLong': 'addressImageLatitude[]',
      'image2LatLong': 'addressImageLatitude[]',
      'image3LatLong': 'imagesLatitude[]',
      'image4LatLong': 'imagesLatitude[]',
      'image5LatLong': 'imagesLatitude[]',
      'image6LatLong': 'imagesLatitude[]',
      'image1Timestamp': 'addressImageTimestamp[]',
      'image2Timestamp': 'addressImageTimestamp[]',
      'image3Timestamp': 'imagesTimestamp[]',
      'image4Timestamp': 'imagesTimestamp[]',
      'image5Timestamp': 'imagesTimestamp[]',
      'image6Timestamp': 'imagesTimestamp[]',    
    };

    // ✅ Add form fields
    debugPrint("🔻 Sending the following form fields:");
    for (var entry in fieldMappings.entries) {
      final key = entry.key;
      final backendKey = entry.value;

      final value = key == 'remark' ? generatedRemark : data[key];
      if (value != null) {
        request.fields[backendKey] = value.toString();
        debugPrint('$backendKey: ${value.toString()}');
      }
    }

    // ✅ Add image files
    debugPrint("📷 Sending the following image files:");
    for (int i = 1; i <= 6; i++) {
      File? imageFile = data['image$i'];
      if (imageFile is File) {
        final fieldName = i <= 2 ? 'addressImage' : 'images';
        final fileName = path.basename(imageFile.path);
        request.files.add(await http.MultipartFile.fromPath(fieldName, imageFile.path, filename: fileName));
        debugPrint('$fieldName: $fileName');
      }
    }

 

    // ✅ Send the request
    var response = await request.send();
    final responseBody = await response.stream.bytesToString();

    debugPrint("✅ API Response Status: ${response.statusCode}");
    debugPrint("✅ API Response Body: $responseBody");

    if (response.statusCode == 200) {
      setState(() {
        submissionResult = 'Submitted successfully!';
      });

      await Future.delayed(Duration(milliseconds: 300));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomePage(),
          settings: RouteSettings(arguments: 'Submission successful'),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      setState(() {
        submissionResult = 'Submission failed. Code: ${response.statusCode}';
      });
    }
  } catch (e) {
    await storeFormDataToSharedPrefs(widget.formData, generatedRemark, context);

    setState(() {
      submissionResult = 'Saved offline due to error: $e';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("No internet. Data saved offline."),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );

    await debugPrintOfflineSubmission();
  } finally {
    setState(() {
      isSubmitting = false;
    });
  }
}






  Future<void> storeFormDataToSharedPrefs(Map<String, dynamic> data, String? generatedRemark, BuildContext context,) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> offlineList = prefs.getStringList('offline_submissions') ?? [];

    Map<String, dynamic> dataToSave = {};

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
        dataToSave[backendKey] = generatedRemark ?? '';
      } else {
        final value = data[key];
        if (value != null) {
          dataToSave[backendKey] = value.toString();
        }
      }
    }

    for (int i = 1; i <= 6; i++) {
      File? imageFile = data['image$i'];
      if (imageFile != null && await imageFile.exists()) {
        List<int> imageBytes = await imageFile.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        String imageKey = (i <= 2) ? 'addressImage$i' : 'image$i';
        dataToSave[imageKey] = base64Image;
      }
    }

    String jsonString = jsonEncode(dataToSave);
    offlineList.add(jsonString);
    await prefs.setStringList('offline_submissions', offlineList);

    print('✅ Saved offline submission (Total now: ${offlineList.length})');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false,
    );
  }



  Future<void> debugPrintOfflineSubmission() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList('offline_submissions') ?? [];

    if (jsonList.isEmpty) {
      print("❌ No offline submission data found.");
      return;
    }

    print("🧾 Total offline items found: ${jsonList.length}");

    for (int i = 0; i < jsonList.length; i++) {
      try {
        Map<String, dynamic> data = jsonDecode(jsonList[i]);
        print("📦 Offline Submission #${i + 1}:");

        data.forEach((key, value) {
          if (value is String && _isBase64Image(value)) {
            String preview = value.substring(0, 30);
            print("$key: [BASE64 IMAGE] Preview: $preview... (length: ${value.length})");
          } else {
            print("$key: $value");
          }
        });

        print("\n---");
      } catch (e) {
        print("⚠️ Error decoding item $i: $e");
      }
    }
  }

  bool _isBase64Image(String str) {
    return str.length > 100 && RegExp(r'^[A-Za-z0-9+/]+={0,2}$').hasMatch(str);
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


