import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:urms/officeRecords/submit_Page.dart';
import 'imageWithWatermark.dart';
import 'package:flutter/foundation.dart';



class OfficeProfile extends StatefulWidget {
  final String applicantName;
  final String address;
  final String contactNumber;
  final String taskId;



  const OfficeProfile({
    super.key,
    required this.applicantName,
    required this.address,
    required this.contactNumber,
    required this.taskId,
  });

  @override
  State<OfficeProfile> createState() => _OfficeProfileState();
}

class _OfficeProfileState extends State<OfficeProfile> {
  String? addressTraced;
  String? companyExist;
  String? entryAllowed;
  String? detailSharedByColleague;
  String? reasonOfUntrace;
  String? requiredToTrace;
  String? callingResponse;
  String? metNeighbourFirst;
  String? metNeighbourSecond;
  String? lastLocation;
  String? otherObservation;
  String? confirmationAboutCompany;
  String? currentCompanyExists;
  String? totalFloor;
  String? permissiveExistsOnWhichFloor;
  String? landArea;
  String? localityOfAddress;
  String? nameBoardSeen;
  String? metPersonName;
  String? metPersonDesignation;
  String? anyConfirmation ;
  String? firstColleagueName;
  String? firstColleagueDesignation;
  String? secondColleagueName;
  String? secondColleagueDesignation;
  String? totalEmployee;
  String? seenEmployee;
  String? natureOfBusiness;
  String? setupAndActivity;
  String? applicantDesignation;
  String? idCardShown;
  String? tenureOfWorkingYrs;
  String? tenureOfWorkingMonths;
  String? tenureOfWorking;
  String? otherReasonTemp;
  int? loadingImageNumber;
  bool isCooldown = false;
  int cooldownSecondsRemaining = 0;
  Timer? cooldownTimer;


  // Example variables for images & metadata
File? image1, image2, image3, image4, image5, image6;
DateTime? image1Timestamp, image2Timestamp, image3Timestamp, image4Timestamp, image5Timestamp, image6Timestamp;
String? image1LatLong, image2LatLong, image3LatLong, image4LatLong, image5LatLong, image6LatLong;


  // String get tenureOfWorking =>
  //     '${tenureOfWorkingYrs ?? "0"} years and ${tenureOfWorkingMonths ?? "0"} months';
  // 'yes' or 'no'

  // Shared image files for both YES and NO form
  // File? image1;
  // DateTime? image1Timestamp;
  // String? image1LatLong;

  // File? image2;
  // DateTime? image2Timestamp;
  // String? image2LatLong;

  // File? image3;
  // DateTime? image3Timestamp;
  // String? image3LatLong;

  // File? image4;
  // DateTime? image4Timestamp;
  // String? image4LatLong;

  // File? image5;
  // DateTime? image5Timestamp;
  // String? image5LatLong;

  // File? image6;
  // DateTime? image6Timestamp;
  // String? image6LatLong;


  // @override
  // void initState() {
  //   super.initState();
  //
  //   // Safely initialize using other nullable fields here
  //   tenureOfWorking =
  //   '${tenureOfWorkingYrs} years and ${tenureOfWorkingMonths} months';
  // }


  bool get isFormValid {
    if (addressTraced == 'no') {
      return reasonOfUntrace != null &&
          requiredToTrace != null &&
          callingResponse != null &&
          lastLocation?.isNotEmpty == true &&
          otherObservation?.isNotEmpty == true &&
          image1 != null &&
          image2 != null &&
          image3 != null &&
          image4 != null &&
          image5 != null &&
          image6 != null;
    }

    if (addressTraced == 'yes' && companyExist == 'no') {

        return callingResponse != null &&
            metNeighbourFirst?.isNotEmpty == true &&
            metNeighbourSecond?.isNotEmpty == true &&
            confirmationAboutCompany != null &&
            currentCompanyExists?.isNotEmpty == true &&
            totalFloor != null &&
            permissiveExistsOnWhichFloor != null &&
            landArea?.isNotEmpty == true &&
            localityOfAddress != null &&
            otherObservation?.isNotEmpty == true &&
            image1 != null &&
            image2 != null &&
            image3 != null &&
            image4 != null &&
            image5 != null &&
            image6 != null;

    }

    if (addressTraced == 'yes' && companyExist == 'yes' && entryAllowed == 'no') {

        return callingResponse != null &&
            totalFloor != null &&
            permissiveExistsOnWhichFloor != null &&
            landArea?.isNotEmpty == true &&
            localityOfAddress != null &&
            nameBoardSeen != null &&
            metPersonName?.isNotEmpty == true &&
            metPersonDesignation?.isNotEmpty == true &&
            anyConfirmation != null &&
            otherObservation?.isNotEmpty == true &&
            image1 != null &&
            image2 != null &&
            image3 != null &&
            image4 != null &&
            image5 != null &&
            image6 != null;
      }

    if (addressTraced == 'yes' && companyExist == 'yes' && entryAllowed == 'yes' && detailSharedByColleague == 'notConfirmed') {

      return firstColleagueName?.isNotEmpty == true &&
          firstColleagueDesignation?.isNotEmpty == true &&
          secondColleagueName?.isNotEmpty == true &&
          secondColleagueDesignation?.isNotEmpty == true &&
          callingResponse != null &&
          totalFloor != null &&
          permissiveExistsOnWhichFloor != null &&
          landArea?.isNotEmpty == true &&
          localityOfAddress != null &&
          totalEmployee?.isNotEmpty == true &&
          seenEmployee?.isNotEmpty == true &&
          natureOfBusiness?.isNotEmpty == true &&
          setupAndActivity != null &&
          nameBoardSeen != null &&
          otherObservation?.isNotEmpty == true &&
          image1 != null &&
          image2 != null &&
          image3 != null &&
          image4 != null &&
          image5 != null &&
          image6 != null;
    }

    if (addressTraced == 'yes' && companyExist == 'yes' && entryAllowed == 'yes' && detailSharedByColleague == 'confirmed') {

      return firstColleagueName?.isNotEmpty == true &&
          firstColleagueDesignation?.isNotEmpty == true &&
          secondColleagueName?.isNotEmpty == true &&
          secondColleagueDesignation?.isNotEmpty == true &&
          metPersonName?.isNotEmpty == true &&
          metPersonDesignation?.isNotEmpty == true &&
          applicantDesignation?.isNotEmpty == true &&
          tenureOfWorkingMonths?.isNotEmpty == true &&
          tenureOfWorkingYrs?.isNotEmpty == true &&
          totalFloor != null &&
          permissiveExistsOnWhichFloor != null &&
          landArea?.isNotEmpty == true &&
          localityOfAddress != null &&
          idCardShown != null &&
          totalEmployee?.isNotEmpty == true &&
          seenEmployee?.isNotEmpty == true &&
          natureOfBusiness?.isNotEmpty == true &&
          setupAndActivity != null &&
          nameBoardSeen != null &&
          otherObservation?.isNotEmpty == true &&
          image1 != null &&
          image2 != null &&
          image3 != null &&
          image4 != null &&
          image5 != null &&
          image6 != null;
    }

    return false; // Default case
  }


  // final picker = ImagePicker();

  // bool isLoading = false;

  // Future<void> pickImage(int imageNumber) async {
  //   setState(() => isLoading = true);

  //   final pickedFile = await picker.pickImage(source: ImageSource.camera);

  //   if (pickedFile != null) {
  //     final imageFile = File(pickedFile.path);

  //     // Compress image using your addWatermarkToImage function (which now just resizes)
  //     final compressedFile = await addWatermarkToImage(imageFile);

  //     DateTime now = DateTime.now();

  //     String latLong = 'Unknown location';
  //     try {
  //       Position position = await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high);
  //       latLong = '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
  //     } catch (e) {
  //       latLong = 'Location unavailable';
  //     }

  //     setState(() {
  //       switch (imageNumber) {
  //         case 1:
  //           image1 = compressedFile ?? imageFile;  // fallback to original if compression failed
  //           image1Timestamp = now;
  //           image1LatLong = latLong;
  //           break;
  //         case 2:
  //           image2 = compressedFile ?? imageFile;
  //           image2Timestamp = now;
  //           image2LatLong = latLong;
  //           break;
  //         case 3:
  //           image3 = compressedFile ?? imageFile;
  //           image3Timestamp = now;
  //           image3LatLong = latLong;
  //           break;
  //         case 4:
  //           image4 = compressedFile ?? imageFile;
  //           image4Timestamp = now;
  //           image4LatLong = latLong;
  //           break;
  //         case 5:
  //           image5 = compressedFile ?? imageFile;
  //           image5Timestamp = now;
  //           image5LatLong = latLong;
  //           break;
  //         case 6:
  //           image6 = compressedFile ?? imageFile;
  //           image6Timestamp = now;
  //           image6LatLong = latLong;
  //           break;
  //       }
  //       isLoading = false;
  //     });
  //   } else {
  //     setState(() => isLoading = false);
  //   }
  // }

final picker = ImagePicker();

bool isLoading = false;

// Example variables for images & metadata
// File? image1, image2, image3, image4, image5, image6;
// DateTime? image1Timestamp, image2Timestamp, image3Timestamp, image4Timestamp, image5Timestamp, image6Timestamp;
// String? image1LatLong, image2LatLong, image3LatLong, image4LatLong, image5LatLong, image6LatLong;

Future<void> pickImage(int imageNumber) async {
  if (isCooldown) return;

  setState(() {
    loadingImageNumber = imageNumber;
    isCooldown = true;
    cooldownSecondsRemaining = 10;
  });

  startCooldownTimer();

  try {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) {
      setState(() {
        loadingImageNumber = null;
      });
      return;
    }

    final imageFile = File(pickedFile.path);
    final compressedFile = await addWatermarkToImage(imageFile);

    String latLong = 'Unknown location';
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      latLong = '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
    } catch (_) {
      latLong = 'Location unavailable';
    }

    final now = DateTime.now();
    final fileToUse = compressedFile ?? imageFile;

    setState(() {
      switch (imageNumber) {
        case 1:
          image1 = fileToUse;
          image1Timestamp = now;
          image1LatLong = latLong;
          break;
        case 2:
          image2 = fileToUse;
          image2Timestamp = now;
          image2LatLong = latLong;
          break;
        case 3:
          image3 = fileToUse;
          image3Timestamp = now;
          image3LatLong = latLong;
          break;
        case 4:
          image4 = fileToUse;
          image4Timestamp = now;
          image4LatLong = latLong;
          break;
        case 5:
          image5 = fileToUse;
          image5Timestamp = now;
          image5LatLong = latLong;
          break;
        case 6:
          image6 = fileToUse;
          image6Timestamp = now;
          image6LatLong = latLong;
          break;
      }
      loadingImageNumber = null;
    });
  } catch (e) {
    print("PickImage Error: $e");
    setState(() => loadingImageNumber = null);
  }
}


void startCooldownTimer() {
  cooldownTimer?.cancel(); // Cancel any existing timer

  cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (cooldownSecondsRemaining > 1) {
      setState(() => cooldownSecondsRemaining--);
    } else {
      timer.cancel();
      setState(() {
        isCooldown = false;
        cooldownSecondsRemaining = 0;
      });
    }
  });
}


  @override
  void initState() {
    super.initState();


  }


  Widget imagePickerBlock(int imageNumber, File? imageFile, DateTime? timestamp, String? latLong) {
  final bool isCurrentLoading = loadingImageNumber == imageNumber;

  return GestureDetector(
    onTap: () {
      if (!isCooldown && !isCurrentLoading) {
        pickImage(imageNumber);
      }
    },
    child: Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: imageFile != null
                  ? Image.file(imageFile, fit: BoxFit.cover)
                  : const Center(
                      child: Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                    ),
            ),
            if (isCurrentLoading)
              const CircularProgressIndicator(),
            if (isCooldown && !isCurrentLoading)
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Wait $cooldownSecondsRemaining s',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        if (timestamp != null && latLong != null)
          Text(
            'Time: ${timestamp.toLocal().toString().split('.')[0]}\n'
            'Location: $latLong',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          )
        else
          const SizedBox(height: 40),
      ],
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
            onChanged: (value) {
              setState(() {
                companyExist = value;
                entryAllowed = null; // Reset the nested state
                // You can also reset image3 - image6 if you want:
                image3 = null;
                image4 = null;
                image5 = null;
                image6 = null;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('No'),
          leading: Radio<String>(
            value: 'no',
            groupValue: companyExist,
            onChanged: (value){
              setState(() {
                companyExist = value;
                entryAllowed = null; // Reset the nested state

                callingResponse = null;
                metNeighbourFirst = null;
                metNeighbourSecond = null;
                confirmationAboutCompany = null;
                currentCompanyExists = null;
                totalFloor = null;
                permissiveExistsOnWhichFloor = null;
                landArea = null;
                localityOfAddress = null;
                otherObservation = null;


                // You can also reset image3 - image6 if you want:
                image3 = null;
                image4 = null;
                image5 = null;
                image6 = null;
              });
            },
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
        const Text('Reason Of Untraced ?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Address is Incomplete'),
          leading: Radio<String>(
            value: 'Address is Incomplete',
            groupValue: reasonOfUntrace,
            onChanged: (value) => setState(() => reasonOfUntrace = value),
          ),
        ),
        ListTile(
          title: const Text('Address exists in slum location'),
          leading: Radio<String>(
            value: 'Address exists in slum location',
            groupValue: reasonOfUntrace,
            onChanged: (value) => setState(() => reasonOfUntrace = value),
          ),
        ),
        ListTile(
          title: const Text('Address is not in sequences'),
          leading: Radio<String>(
            value: 'Address is not in sequences',
            groupValue: reasonOfUntrace,
            onChanged: (value) => setState(() => reasonOfUntrace = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: reasonOfUntrace,
            onChanged: (value) => setState(() => reasonOfUntrace = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (reasonOfUntrace == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  reasonOfUntrace = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),
        const SizedBox(height: 16),

        const Text('Required to Trace?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Required Street Number'),
          leading: Radio<String>(
            value: 'Required Street Number',
            groupValue: requiredToTrace,
            onChanged: (value) => setState(() => requiredToTrace = value),
          ),
        ),
        ListTile(
          title: const Text('Required Landmark'),
          leading: Radio<String>(
            value: 'Required Landmark',
            groupValue: requiredToTrace,
            onChanged: (value) => setState(() => requiredToTrace = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: requiredToTrace,
            onChanged: (value) => setState(() => requiredToTrace = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (requiredToTrace == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  requiredToTrace = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),

        const SizedBox(height: 20),

        const Text('Calling Response? ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('did not pick the call'),
          leading: Radio<String>(
            value: 'did not pick the call',
            groupValue: callingResponse,
            onChanged: (value) => setState(() => callingResponse = value),
          ),
        ),
        ListTile(
          title: const Text('Number Was Not Reachable'),
          leading: Radio<String>(
            value: 'Number Was Not Reachable',
            groupValue: callingResponse,
            onChanged: (value) => setState(() => callingResponse = value),
          ),
        ),
        ListTile(
          title: const Text('Number Was Switch Off'),
          leading: Radio<String>(
            value: 'Number Was Switch Off',
            groupValue: callingResponse,
            onChanged: (value) => setState(() => callingResponse = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: callingResponse,
            onChanged: (value) => setState(() => callingResponse = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (callingResponse == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  callingResponse = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),

        const SizedBox(height: 20,),

        const Text('Last Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        TextField(
          decoration: const InputDecoration(
            labelText: 'Last Location',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              lastLocation = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 20,),
        const Text('Other Observation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Other Observation',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              otherObservation = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(3, image3, image3Timestamp, image3LatLong),
            imagePickerBlock(4, image4, image4Timestamp, image4LatLong),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(5, image5, image5Timestamp, image5LatLong),
            imagePickerBlock(6, image6, image6Timestamp, image6LatLong),
          ],
        ),
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
            onChanged: (value)  {
              setState(() {
                entryAllowed = value;
                detailSharedByColleague = null;// Reset the nested state
                firstColleagueName = null;
                firstColleagueDesignation = null;
                secondColleagueName = null;
                secondColleagueDesignation = null;
                // You can also reset image3 - image6 if you want:
                image3 = null;
                image4 = null;
                image5 = null;
                image6 = null;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('No'),
          leading: Radio<String>(
            value: 'no',
            groupValue: entryAllowed,
            onChanged: (value) {
              setState(() {
                entryAllowed = value;
                detailSharedByColleague = null;// Reset the nested state
                callingResponse = null;
                totalFloor = null;
                permissiveExistsOnWhichFloor = null;
                landArea = null;
                localityOfAddress = null;
                nameBoardSeen = null;
                metPersonName = null;
                metPersonDesignation= null;
                anyConfirmation = null;
                otherObservation = null;
                // You can also reset image3 - image6 if you want:
                image3 = null;
                image4 = null;
                image5 = null;
                image6 = null;
              });
            },
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

        const Text('Calling Response? ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ListTile(
          title: const Text('did not pick the call'),
          leading: Radio<String>(
            value: 'did not pick the call',
            groupValue: callingResponse,
            onChanged: (value) => setState(() => callingResponse = value),
          ),
        ),
        ListTile(
          title: const Text('Number Was Not Reachable'),
          leading: Radio<String>(
            value: 'Number Was Not Reachable',
            groupValue: callingResponse,
            onChanged: (value) => setState(() => callingResponse = value),
          ),
        ),
        ListTile(
          title: const Text('Number Was Switch Off'),
          leading: Radio<String>(
            value: 'Number Was Switch Off',
            groupValue: callingResponse,
            onChanged: (value) => setState(() => callingResponse = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: callingResponse,
            onChanged: (value) => setState(() => callingResponse = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (callingResponse == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  callingResponse = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),

        const SizedBox(height: 20,),
        const Text('Met Neighbours ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        TextField(
          decoration: const InputDecoration(
            labelText: 'Met 1st Neighbour',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              metNeighbourFirst = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),
        const SizedBox(height: 10),

        TextField(
          decoration: const InputDecoration(
            labelText: 'Met 2nd Neighbour',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              metNeighbourSecond = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),


        const SizedBox(height: 20),

        const Text('Confirmation About Company', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('previously company exist but now shifted'),
          leading: Radio<String>(
            value: 'previously company exist but now shifted',
            groupValue: confirmationAboutCompany,
            onChanged: (value) => setState(() => confirmationAboutCompany = value),
          ),
        ),
        ListTile(
          title: const Text('not exist given company here'),
          leading: Radio<String>(
            value: 'not exist given company here ',
            groupValue: confirmationAboutCompany,
            onChanged: (value) => setState(() => confirmationAboutCompany = value),
          ),
        ),
        ListTile(
          title: const Text('recently shifted'),
          leading: Radio<String>(
            value: 'recently shifted',
            groupValue: confirmationAboutCompany,
            onChanged: (value) => setState(() => confirmationAboutCompany = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: confirmationAboutCompany,
            onChanged: (value) => setState(() => confirmationAboutCompany = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (confirmationAboutCompany == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  confirmationAboutCompany = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),
        const SizedBox(height: 20,),
        const Text('Current Company which Exist there: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        TextField(
          decoration: const InputDecoration(
            labelText: 'Enter Current Company',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              currentCompanyExists = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 20),

        const Text('Total Floor?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Only ground floor'),
          leading: Radio<String>(
            value: 'Only ground floor',
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 1st floor'),
          leading: Radio<String>(
            value: 'Ground to 1st floor ',
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 2nd floor'),
          leading: Radio<String>(
            value: 'Ground to 2nd floor',
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 3rd floor'),
          leading: Radio<String>(
            value: 'Ground to 3rd floor',
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (totalFloor == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  totalFloor = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),
        const SizedBox(height: 20,),


        const Text('Premises Exists On Which Floor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Ground floor'),
          leading: Radio<String>(
            value: 'Ground floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('1st floor'),
          leading: Radio<String>(
            value: '1st floor ',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('2nd floor'),
          leading: Radio<String>(
            value: '2nd floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('3rd floor'),
          leading: Radio<String>(
            value: '3rd floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (permissiveExistsOnWhichFloor == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  permissiveExistsOnWhichFloor = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),
        const SizedBox(height: 20,),


        const Text('Land Area (in Sq. Feet) ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        TextField(
          decoration: const InputDecoration(
            labelText: 'Enter Land Area',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              landArea = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 20,),


        const Text('Locality Of Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Commercial'),
          leading: Radio<String>(
            value: 'Commercial',
            groupValue: localityOfAddress,
            onChanged: (value) => setState(() => localityOfAddress = value),
          ),
        ),
        ListTile(
          title: const Text(' Resi cum commercial'),
          leading: Radio<String>(
            value: ' Resi cum commercial',
            groupValue: localityOfAddress,
            onChanged: (value) => setState(() => localityOfAddress = value),
          ),
        ),
        ListTile(
          title: const Text('Industrial'),
          leading: Radio<String>(
            value: 'Industrial',
            groupValue: localityOfAddress,
            onChanged: (value) => setState(() => localityOfAddress = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: localityOfAddress,
            onChanged: (value) => setState(() => localityOfAddress = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (localityOfAddress == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  localityOfAddress = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),
        const SizedBox(height: 20,),
        const Text('Other Observation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Other Observation',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              otherObservation = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),


        const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(3, image3, image3Timestamp, image3LatLong),
            imagePickerBlock(4, image4, image4Timestamp, image4LatLong),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(5, image5, image5Timestamp, image5LatLong),
            imagePickerBlock(6, image6, image6Timestamp, image6LatLong),
          ],
        ),
      ],
    );
  }


  Widget entryAllowedYes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text('Form for YES:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        const SizedBox(height: 20,),
        const Text('First Colleague Name and Designation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        TextField(
          decoration: const InputDecoration(
            labelText: 'First Colleague Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              firstColleagueName = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: const InputDecoration(
            labelText: 'First Colleague Designation',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              firstColleagueDesignation = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 20),

        const Text('Second Colleague Name and Designation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        TextField(
          decoration: const InputDecoration(
            labelText: 'Second Colleague Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              secondColleagueName = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Second Colleague Designation',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              secondColleagueDesignation = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 20),

        const Text(
          'Details Shared By Colleague? ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ListTile(
          title: const Text('Confirmed'),
          leading: Radio<String>(
            value: 'confirmed',
            groupValue: detailSharedByColleague,
            onChanged: (value) {
    setState(() {
    detailSharedByColleague = value; // Reset the nested state
    metPersonName = null;
    metPersonDesignation = null;
    applicantDesignation = null;
    tenureOfWorkingYrs = null;
    tenureOfWorkingMonths = null;
    totalFloor = null;
    permissiveExistsOnWhichFloor = null;
    landArea = null;
    localityOfAddress = null;
    idCardShown = null;
    totalEmployee = null;
    seenEmployee = null;
    natureOfBusiness = null;
    setupAndActivity = null;
    nameBoardSeen = null;
    otherObservation = null;
    // You can also reset image3 - image6 if you want:
    image3 = null;
    image4 = null;
    image5 = null;
    image6 = null;
    });
    },
          ),
        ),
        ListTile(
          title: const Text('Not Confirmed'),
          leading: Radio<String>(
            value: 'notConfirmed',
            groupValue: detailSharedByColleague,
            onChanged: (value) {
              setState(() {
                detailSharedByColleague = value; // Reset the nested state
                callingResponse = null;
                totalFloor = null;
                permissiveExistsOnWhichFloor = null;
                landArea = null;
                localityOfAddress = null;
                totalEmployee = null;
                seenEmployee = null;
                natureOfBusiness = null;
                setupAndActivity = null;
                nameBoardSeen = null;
                otherObservation = null;
                // You can also reset image3 - image6 if you want:
                image3 = null;
                image4 = null;
                image5 = null;
                image6 = null;
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        if (detailSharedByColleague == 'confirmed') detailsSharedYes(),
        if (detailSharedByColleague == 'notConfirmed') detailsSharedNo(),
      ],
    );
  }

Widget entryAllowedNo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Calling Response? ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ListTile(
          title: const Text('did not pick the call'),
          leading: Radio<String>(
            value: 'did not pick the call',
            groupValue: callingResponse,
            onChanged: (value) => setState(() => callingResponse = value),
          ),
        ),
        ListTile(
          title: const Text('Number Was Not Reachable'),
          leading: Radio<String>(
            value: 'Number Was Not Reachable',
            groupValue: callingResponse,
            onChanged: (value) => setState(() => callingResponse = value),
          ),
        ),
        ListTile(
          title: const Text('Number Was Switch Off'),
          leading: Radio<String>(
            value: 'Number Was Switch Off',
            groupValue: callingResponse,
            onChanged: (value) => setState(() => callingResponse = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: callingResponse,
            onChanged: (value) => setState(() => callingResponse = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (callingResponse == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  callingResponse = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),

        const SizedBox(height: 20),

        const SizedBox(height: 20),

        const Text('Total Floor?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Only ground floor'),
          leading: Radio<String>(
            value: 'Only ground floor',
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 1st floor'),
          leading: Radio<String>(
            value: 'Ground to 1st floor ',
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 2nd floor'),
          leading: Radio<String>(
            value: 'Ground to 2nd floor',
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 3rd floor'),
          leading: Radio<String>(
            value: 'Ground to 3rd floor',
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (totalFloor == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  totalFloor = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),
        const SizedBox(height: 20,),


        const Text('Premises Exists On Which Floor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Ground floor'),
          leading: Radio<String>(
            value: 'Ground floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('1st floor'),
          leading: Radio<String>(
            value: '1st floor ',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('2nd floor'),
          leading: Radio<String>(
            value: '2nd floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('3rd floor'),
          leading: Radio<String>(
            value: '3rd floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (permissiveExistsOnWhichFloor == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  permissiveExistsOnWhichFloor = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),
        const SizedBox(height: 20,),


        const Text('Land Area (in Sq. Feet) ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        TextField(
          decoration: const InputDecoration(
            labelText: 'Enter Land Area',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              landArea = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 20,),


        const Text('Locality Of Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Commercial'),
          leading: Radio<String>(
            value: 'Commercial',
            groupValue: localityOfAddress,
            onChanged: (value) => setState(() => localityOfAddress = value),
          ),
        ),
        ListTile(
          title: const Text(' Resi cum commercial'),
          leading: Radio<String>(
            value: ' Resi cum commercial',
            groupValue: localityOfAddress,
            onChanged: (value) => setState(() => localityOfAddress = value),
          ),
        ),
        ListTile(
          title: const Text('Industrial'),
          leading: Radio<String>(
            value: 'Industrial',
            groupValue: localityOfAddress,
            onChanged: (value) => setState(() => localityOfAddress = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: localityOfAddress,
            onChanged: (value) => setState(() => localityOfAddress = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (localityOfAddress == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  localityOfAddress = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),
        const SizedBox(height: 20,),

        const Text('Name Board Seen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Seen by same name'),
          leading: Radio<String>(
            value: 'Seen by same name',
            groupValue: nameBoardSeen,
            onChanged: (value) => setState(() => nameBoardSeen = value),
          ),
        ),
        ListTile(
          title: const Text('not seen'),
          leading: Radio<String>(
            value: 'not seen ',
            groupValue: nameBoardSeen,
            onChanged: (value) => setState(() => nameBoardSeen = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: nameBoardSeen,
            onChanged: (value) => setState(() => nameBoardSeen = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (nameBoardSeen == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  nameBoardSeen = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),
        const SizedBox(height: 20,),
        const Text('Met Person Name and Designation: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        TextField(
          decoration: const InputDecoration(
            labelText: 'Met Person Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              metPersonName = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Met Person Designation',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              metPersonDesignation = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 20),

        const Text('Any Confirmation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('confirmed applicant name and working'),
          leading: Radio<String>(
            value: 'confirmed applicant name and working',
            groupValue: anyConfirmation,
            onChanged: (value) => setState(() => anyConfirmation = value),
          ),
        ),
        ListTile(
          title: const Text('not confirmed applicant name and working'),
          leading: Radio<String>(
            value: 'not confirmed applicant name and working',
            groupValue: anyConfirmation,
            onChanged: (value) => setState(() => anyConfirmation = value),
          ),
        ),

        const SizedBox(height: 20,),


        const Text('Other Observation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Other Observation',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              otherObservation = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),


        const SizedBox(height: 20,),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(3, image3, image3Timestamp, image3LatLong),
            imagePickerBlock(4, image4, image4Timestamp, image4LatLong),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(5, image5, image5Timestamp, image5LatLong),
            imagePickerBlock(6, image6, image6Timestamp, image6LatLong),
          ],
        ),
      ],
    );
  }

  Widget detailsSharedYes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 20,),
        const Text('Met Person Name and Designation: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        TextField(
          decoration: const InputDecoration(
            labelText: 'Met Person Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              metPersonName = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Met Person Designation',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              metPersonDesignation = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),
        const SizedBox(height: 20),
        const Text("Applicant's Designation ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        TextField(
          decoration: const InputDecoration(
            labelText: "Applicant's Designation ",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              applicantDesignation = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),
        const SizedBox(height: 20),
        const Text("Tenure Of Working", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        TextField(
          decoration: const InputDecoration(
            labelText: "Years",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              tenureOfWorkingYrs = value;
              tenureOfWorking = '$tenureOfWorkingYrs years $tenureOfWorkingMonths months';
            });
          },
        ),



        const SizedBox(height: 10),
        TextField(
          decoration: const InputDecoration(
            labelText: "Months",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              tenureOfWorkingMonths = value;
              tenureOfWorking = '$tenureOfWorkingYrs years $tenureOfWorkingMonths months';
            });
          },
        ),


        const SizedBox(height: 20),

        const Text('Total Floor?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Only ground floor'),
          leading: Radio<String>(
            value: 'Only ground floor',
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 1st floor'),
          leading: Radio<String>(
            value: 'Ground to 1st floor ',
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 2nd floor'),
          leading: Radio<String>(
            value: 'Ground to 2nd floor',
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 3rd floor'),
          leading: Radio<String>(
            value: 'Ground to 3rd floor',
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (totalFloor == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  totalFloor = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),
        const SizedBox(height: 20,),


        const Text('Premises Exists On Which Floor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Ground floor'),
          leading: Radio<String>(
            value: 'Ground floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('1st floor'),
          leading: Radio<String>(
            value: '1st floor ',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('2nd floor'),
          leading: Radio<String>(
            value: '2nd floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('3rd floor'),
          leading: Radio<String>(
            value: '3rd floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (permissiveExistsOnWhichFloor == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  permissiveExistsOnWhichFloor = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),
        const SizedBox(height: 20,),


        const Text('Land Area (in Sq. Feet) ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        TextField(
          decoration: const InputDecoration(
            labelText: 'Enter Land Area',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              landArea = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 20,),


        const Text('Locality Of Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Commercial'),
          leading: Radio<String>(
            value: 'Commercial',
            groupValue: localityOfAddress,
            onChanged: (value) => setState(() => localityOfAddress = value),
          ),
        ),
        ListTile(
          title: const Text(' Resi cum commercial'),
          leading: Radio<String>(
            value: ' Resi cum commercial',
            groupValue: localityOfAddress,
            onChanged: (value) => setState(() => localityOfAddress = value),
          ),
        ),
        ListTile(
          title: const Text('Industrial'),
          leading: Radio<String>(
            value: 'Industrial',
            groupValue: localityOfAddress,
            onChanged: (value) => setState(() => localityOfAddress = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: localityOfAddress,
            onChanged: (value) => setState(() => localityOfAddress = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (localityOfAddress == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  localityOfAddress = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),

        const SizedBox(height: 20,),


        const Text('ID card Shown by Applicant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Shown ID Card'),
          leading: Radio<String>(
            value: 'shown ID Card',
            groupValue: idCardShown,
            onChanged: (value) => setState(() => idCardShown = value),
          ),
        ),
        ListTile(
          title: const Text('Not Shown ID Card'),
          leading: Radio<String>(
            value: ' not shown ID Card',
            groupValue: idCardShown,
            onChanged: (value) => setState(() => idCardShown = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: idCardShown,
            onChanged: (value) => setState(() => idCardShown = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (idCardShown == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  idCardShown = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),
        const SizedBox(height: 20,),

        const Text('Total Employee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        TextField(
          decoration: const InputDecoration(
            labelText: 'total employee',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              totalEmployee = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 20,),

        const Text('Seen Employee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        TextField(
          decoration: const InputDecoration(
            labelText: 'seen employee',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              seenEmployee = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 20,),

        const Text('Nature of Business', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        TextField(
          decoration: const InputDecoration(
            labelText: 'nature of business',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              natureOfBusiness = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 20,),

        const Text('Setup and Activity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Average'),
          leading: Radio<String>(
            value: 'average',
            groupValue: setupAndActivity,
            onChanged: (value) => setState(() => setupAndActivity = value),
          ),
        ),
        ListTile(
          title: const Text('Good'),
          leading: Radio<String>(
            value: 'good',
            groupValue: setupAndActivity,
            onChanged: (value) => setState(() => setupAndActivity = value),
          ),
        ),
        ListTile(
          title: const Text('Low'),
          leading: Radio<String>(
            value: 'low', // Changed to 'Any other' instead of empty string
            groupValue: setupAndActivity,
            onChanged: (value) => setState(() => setupAndActivity = value),
          ),
        ),
        ListTile(
          title: const Text('Temporary'),
          leading: Radio<String>(
            value: 'temporary', // Changed to 'Any other' instead of empty string
            groupValue: setupAndActivity,
            onChanged: (value) => setState(() => setupAndActivity = value),
          ),
        ),


        const SizedBox(height: 20,),

        const Text('Name Board Seen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Seen by same name'),
          leading: Radio<String>(
            value: 'Seen by same name',
            groupValue: nameBoardSeen,
            onChanged: (value) => setState(() => nameBoardSeen = value),
          ),
        ),
        ListTile(
          title: const Text('not seen'),
          leading: Radio<String>(
            value: 'not seen ',
            groupValue: nameBoardSeen,
            onChanged: (value) => setState(() => nameBoardSeen = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: nameBoardSeen,
            onChanged: (value) => setState(() => nameBoardSeen = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (nameBoardSeen == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  nameBoardSeen = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),

        const SizedBox(height: 20),

        const Text('Other Observation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Other Observation',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              otherObservation = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(3, image3, image3Timestamp, image3LatLong),
            imagePickerBlock(4, image4, image4Timestamp, image4LatLong),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(5, image5, image5Timestamp, image5LatLong),
            imagePickerBlock(6, image6, image6Timestamp, image6LatLong),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

Widget detailsSharedNo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        const Text('Calling Response? ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ListTile(
          title: const Text('did not pick the call'),
          leading: Radio<String>(
            value: 'did not pick the call',
            groupValue: callingResponse,
            onChanged: (value) => setState(() => callingResponse = value),
          ),
        ),
        ListTile(
          title: const Text('Number Was Not Reachable'),
          leading: Radio<String>(
            value: 'Number Was Not Reachable',
            groupValue: callingResponse,
            onChanged: (value) => setState(() => callingResponse = value),
          ),
        ),
        ListTile(
          title: const Text('Number Was Switch Off'),
          leading: Radio<String>(
            value: 'Number Was Switch Off',
            groupValue: callingResponse,
            onChanged: (value) => setState(() => callingResponse = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: callingResponse,
            onChanged: (value) => setState(() => callingResponse = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (callingResponse == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  callingResponse = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),

        const SizedBox(height: 20),

        const Text('Total Floor?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Only ground floor'),
          leading: Radio<String>(
            value: 'Only ground floor',
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 1st floor'),
          leading: Radio<String>(
            value: 'Ground to 1st floor ',
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 2nd floor'),
          leading: Radio<String>(
            value: 'Ground to 2nd floor',
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 3rd floor'),
          leading: Radio<String>(
            value: 'Ground to 3rd floor',
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: totalFloor,
            onChanged: (value) => setState(() => totalFloor = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (totalFloor == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  totalFloor = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),
        const SizedBox(height: 20,),


        const Text('Premises Exists On Which Floor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Ground floor'),
          leading: Radio<String>(
            value: 'Ground floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 1st floor'),
          leading: Radio<String>(
            value: '1st floor ',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('2nd floor'),
          leading: Radio<String>(
            value: '2nd floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('3rd floor'),
          leading: Radio<String>(
            value: '3rd floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (permissiveExistsOnWhichFloor == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  permissiveExistsOnWhichFloor = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),
        const SizedBox(height: 20,),


        const Text('Land Area (in Sq. Feet) ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        TextField(
          decoration: const InputDecoration(
            labelText: 'Enter Land Area',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              landArea = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 20,),


        const Text('Locality Of Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Commercial'),
          leading: Radio<String>(
            value: 'Commercial',
            groupValue: localityOfAddress,
            onChanged: (value) => setState(() => localityOfAddress = value),
          ),
        ),
        ListTile(
          title: const Text(' Resi cum commercial'),
          leading: Radio<String>(
            value: ' Resi cum commercial',
            groupValue: localityOfAddress,
            onChanged: (value) => setState(() => localityOfAddress = value),
          ),
        ),
        ListTile(
          title: const Text('Industrial'),
          leading: Radio<String>(
            value: 'Industrial',
            groupValue: localityOfAddress,
            onChanged: (value) => setState(() => localityOfAddress = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: localityOfAddress,
            onChanged: (value) => setState(() => localityOfAddress = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (localityOfAddress == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  localityOfAddress = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),
        const SizedBox(height: 20,),

        const Text('Total Employee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        TextField(
          decoration: const InputDecoration(
            labelText: 'total employee',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              totalEmployee = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 20,),

        const Text('Seen Employee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        TextField(
          decoration: const InputDecoration(
            labelText: 'seen employee',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              seenEmployee = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 20,),

        const Text('Nature of Business', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        TextField(
          decoration: const InputDecoration(
            labelText: 'nature of business',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              natureOfBusiness = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 20,),

        const Text('Setup and Activity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Average'),
          leading: Radio<String>(
            value: 'average',
            groupValue: setupAndActivity,
            onChanged: (value) => setState(() => setupAndActivity = value),
          ),
        ),
        ListTile(
          title: const Text('Good'),
          leading: Radio<String>(
            value: 'good',
            groupValue: setupAndActivity,
            onChanged: (value) => setState(() => setupAndActivity = value),
          ),
        ),
        ListTile(
          title: const Text('Low'),
          leading: Radio<String>(
            value: 'low', // Changed to 'Any other' instead of empty string
            groupValue: setupAndActivity,
            onChanged: (value) => setState(() => setupAndActivity = value),
          ),
        ),
        ListTile(
          title: const Text('Temporary'),
          leading: Radio<String>(
            value: 'temporary', // Changed to 'Any other' instead of empty string
            groupValue: setupAndActivity,
            onChanged: (value) => setState(() => setupAndActivity = value),
          ),
        ),


        const SizedBox(height: 20,),

        const Text('Name Board Seen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Seen by same name'),
          leading: Radio<String>(
            value: 'Seen by same name',
            groupValue: nameBoardSeen,
            onChanged: (value) => setState(() => nameBoardSeen = value),
          ),
        ),
        ListTile(
          title: const Text('not seen'),
          leading: Radio<String>(
            value: 'not seen ',
            groupValue: nameBoardSeen,
            onChanged: (value) => setState(() => nameBoardSeen = value),
          ),
        ),
        ListTile(
          title: const Text('Any Other'),
          leading: Radio<String>(
            value: 'Any other', // Changed to 'Any other' instead of empty string
            groupValue: nameBoardSeen,
            onChanged: (value) => setState(() => nameBoardSeen = value),
          ),
        ),

        // Display text field only when "Any other" is selected
        if (nameBoardSeen == 'Any other')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  nameBoardSeen = value;  // Store the custom input directly in reasonOfUntrace
                });
              },
            ),
          ),

        const SizedBox(height: 20),

        const Text('Other Observation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Other Observation',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              otherObservation = value;  // Store the custom input directly in reasonOfUntrace
            });
          },
        ),

        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(3, image3, image3Timestamp, image3LatLong),
            imagePickerBlock(4, image4, image4Timestamp, image4LatLong),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(5, image5, image5Timestamp, image5LatLong),
            imagePickerBlock(6, image6, image6Timestamp, image6LatLong),
          ],
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Office Profile')),
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
                imagePickerBlock(1, image1, image1Timestamp, image1LatLong),
                imagePickerBlock(2, image2, image2Timestamp, image2LatLong),
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
                groupValue: addressTraced,
                onChanged: (value){
                  setState(() {
                    addressTraced = value;
                    companyExist = null;// Reset the nested state
                    // You can also reset image3 - image6 if you want:
                    image3 = null;
                    image4 = null;
                    image5 = null;
                    image6 = null;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('No'),
              leading: Radio<String>(
                value: 'no',
                groupValue: addressTraced,
                onChanged: (value) {
                  setState(() {
                    addressTraced = value;
                    companyExist = null; // Reset the nested state
                    reasonOfUntrace = null;
                    requiredToTrace = null;
                    callingResponse = null;
                    lastLocation = null;
                    otherObservation = null;

                    // You can also reset image3 - image6 if you want:
                    image3 = null;
                    image4 = null;
                    image5 = null;
                    image6 = null;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            if (addressTraced == 'yes') addressTracedYes(),
            if (addressTraced == 'no') addressTracedNo(),
            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: isFormValid
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubmitPage(
                        formData: {
                          'applicantName': widget.applicantName,
                                'address': widget.address,
                                'contactNumber': widget.contactNumber,
                                'taskId': widget.taskId,
                                'addressTraced': addressTraced,
                                'metNeighbourFirst': metNeighbourFirst,
                                'metNeighbourSecond' : metNeighbourSecond,
                                'companyExist': companyExist,
                                'entryAllowed': entryAllowed,
                                'detailSharedByColleague': detailSharedByColleague,
                                'reasonOfUntrace': reasonOfUntrace,
                                'requiredToTrace': requiredToTrace,
                                'callingResponse': callingResponse,
                                'lastLocation': lastLocation,
                                'otherObservation': otherObservation,
                                'confirmationAboutCompany': confirmationAboutCompany,
                                'currentCompanyExists': currentCompanyExists,
                                'totalFloor': totalFloor,
                                'permissiveExistsOnWhichFloor': permissiveExistsOnWhichFloor,
                                'landArea': landArea,
                                'localityOfAddress': localityOfAddress,
                                'nameBoardSeen': nameBoardSeen,
                                'metPersonName': metPersonName,
                                'metPersonDesignation': metPersonDesignation,
                                'anyConfirmation': anyConfirmation,
                                'firstColleagueName': firstColleagueName,
                                'firstColleagueDesignation': firstColleagueDesignation,
                                'secondColleagueName': secondColleagueName,
                                'secondColleagueDesignation': secondColleagueDesignation,
                                'totalEmployee': totalEmployee,
                                'seenEmployee': seenEmployee,
                                'natureOfBusiness': natureOfBusiness,
                                'setupAndActivity': setupAndActivity,
                                'applicantDesignation': applicantDesignation,
                                'idCardShown': idCardShown,
                                'tenureOfWorking': tenureOfWorking,
                                'image1': image1,
                                'image2': image2,
                                'image3': image3,
                                'image4': image4,
                                'image5': image5,
                                'image6': image6,
                                'image1LatLong': image1LatLong,
                                'image2LatLong': image2LatLong,
                                'image3LatLong': image3LatLong,
                                'image4LatLong': image4LatLong,
                                'image5LatLong': image5LatLong,
                                'image6LatLong': image6LatLong,
                                'image1Timestamp': image1Timestamp,
                                'image2Timestamp': image2Timestamp,
                                'image3Timestamp': image3Timestamp,
                                'image4Timestamp': image4Timestamp,
                                'image5Timestamp': image5Timestamp,
                                'image6Timestamp': image6Timestamp,


                          // Add any other values you want to pass...
                        },
                      ),
                    ),
                  );
                }
                    : null, // Button will be disabled if form is invalid
                child: const Text('Next'),
              ),
            ),

            SizedBox(height: 50,),


          ],
        ),
      ),
    );
  }
}