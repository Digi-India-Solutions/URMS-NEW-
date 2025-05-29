import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:exif/exif.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';


class OfficeProfile extends StatefulWidget {
  final String applicantName;
  final String address;
  final String contactNumber;

  const OfficeProfile({
    super.key,
    required this.applicantName,
    required this.address,
    required this.contactNumber,
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

  // String get tenureOfWorking =>
  //     '${tenureOfWorkingYrs ?? "0"} years and ${tenureOfWorkingMonths ?? "0"} months';
  // 'yes' or 'no'

  // Shared image files for both YES and NO form
  File? image1;
  File? image2;
  File? image3;
  File? image4;
  File? image5;
  File? image6;

  final picker = ImagePicker();

  Future<void> pickImage(int imageNumber) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) image1 = File(pickedFile.path);
        if (imageNumber == 2) image2 = File(pickedFile.path);
        if (imageNumber == 3) image3 = File(pickedFile.path);
        if (imageNumber == 4) image4 = File(pickedFile.path);
        if (imageNumber == 5) image5 = File(pickedFile.path);
        if (imageNumber == 6) image6 = File(pickedFile.path);

      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Safely initialize using other nullable fields here
    tenureOfWorking =
    '${tenureOfWorkingYrs ?? "0"} years and ${tenureOfWorkingMonths ?? "0"} months';
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
            imagePickerBlock(3, image3),
            imagePickerBlock(4, image4),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(5, image5),
            imagePickerBlock(6, image6),
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


        const Text('Permissive Exists On Which Floor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Only ground floor'),
          leading: Radio<String>(
            value: 'Only ground floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 1st floor'),
          leading: Radio<String>(
            value: 'Ground to 1st floor ',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 2nd floor'),
          leading: Radio<String>(
            value: 'Ground to 2nd floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 3rd floor'),
          leading: Radio<String>(
            value: 'Ground to 3rd floor',
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
            imagePickerBlock(3, image3),
            imagePickerBlock(4, image4),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(5, image5),
            imagePickerBlock(6, image6),
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
            onChanged: (value) => setState(() => detailSharedByColleague = value),
          ),
        ),
        ListTile(
          title: const Text('Not Confirmed'),
          leading: Radio<String>(
            value: 'notConfirmed',
            groupValue: detailSharedByColleague,
            onChanged: (value) => setState(() => detailSharedByColleague = value),
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


        const Text('Permissive Exists On Which Floor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Only ground floor'),
          leading: Radio<String>(
            value: 'Only ground floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 1st floor'),
          leading: Radio<String>(
            value: 'Ground to 1st floor ',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 2nd floor'),
          leading: Radio<String>(
            value: 'Ground to 2nd floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 3rd floor'),
          leading: Radio<String>(
            value: 'Ground to 3rd floor',
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
            imagePickerBlock(3, image3),
            imagePickerBlock(4, image4),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(5, image5),
            imagePickerBlock(6, image6),
          ],
        ),
      ],
    );
  }

  Widget detailsSharedYes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Form for Yes:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

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
              tenureOfWorkingYrs = value;  // Store the custom input directly in reasonOfUntrace
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
              tenureOfWorkingMonths = value;  // Store the custom input directly in reasonOfUntrace
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


        const Text('Permissive Exists On Which Floor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Only ground floor'),
          leading: Radio<String>(
            value: 'Only ground floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 1st floor'),
          leading: Radio<String>(
            value: 'Ground to 1st floor ',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 2nd floor'),
          leading: Radio<String>(
            value: 'Ground to 2nd floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 3rd floor'),
          leading: Radio<String>(
            value: 'Ground to 3rd floor',
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
            imagePickerBlock(3, image3),
            imagePickerBlock(4, image4),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(5, image5),
            imagePickerBlock(6, image6),
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


        const Text('Permissive Exists On Which Floor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ListTile(
          title: const Text('Only ground floor'),
          leading: Radio<String>(
            value: 'Only ground floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 1st floor'),
          leading: Radio<String>(
            value: 'Ground to 1st floor ',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 2nd floor'),
          leading: Radio<String>(
            value: 'Ground to 2nd floor',
            groupValue: permissiveExistsOnWhichFloor,
            onChanged: (value) => setState(() => permissiveExistsOnWhichFloor = value),
          ),
        ),
        ListTile(
          title: const Text('Ground to 3rd floor'),
          leading: Radio<String>(
            value: 'Ground to 3rd floor',
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
            imagePickerBlock(3, image3),
            imagePickerBlock(4, image4),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            imagePickerBlock(5, image5),
            imagePickerBlock(6, image6),
          ],
        ),
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
            const SizedBox(height: 20),
            if (addressTraced == 'yes') addressTracedYes(),
            if (addressTraced == 'no') addressTracedNo(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}