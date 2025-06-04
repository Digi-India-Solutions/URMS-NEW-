import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../login/loginPage.dart';
import '../officeRecords/offileProfile.dart';
import '../services/api_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> allTasks = [];
  bool isLoading = true;
  String errorMessage = '';
  bool isSyncing = false;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 🔁 add this
    fetchTasks();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.locationWhenInUse,
      Permission.storage,
    ].request();

    // Optional: handle each permission result
    statuses.forEach((permission, status) {
      if (status.isDenied) {
        print('$permission denied');
      }
    });


    // Navigate or proceed once permissions are handled
  }

  void refreshPage() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Replace this with your own logic to refetch tasks or load offline data
      await fetchTasks(); // Or whatever method you use
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error refreshing: ${e.toString()}';
        isLoading = false;
      });
    }
  }


  Future<void> fetchTasks() async {
    try {
      final response = await ApiService.getAllTasks();
      print('Status: ${response.statusCode}');
      print('Raw Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          setState(() {
            allTasks = jsonResponse['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'No task data found.';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
          'Failed to load tasks. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'No Internet, Please Connect To Internet First';
      });
    }
  }


  Future<List<Widget>> buildOfflineCards() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> offlineList = prefs.getStringList('offline_submissions') ?? [];

    if (offlineList.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: Text('✅ No offline submissions found.')),
        )
      ];
    }

    return offlineList.map((jsonStr) {
      final Map<String, dynamic> data = jsonDecode(jsonStr);
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        color: Colors.orange[100],
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Task ID: ${data['taskID'] ?? 'N/A'}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              // Text("Name: ${data['applicantName'] ?? 'N/A'}"),
              Text("Remark: ${data['remark'] ?? 'N/A'}"),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    }).toList();
  }


  List<Widget> buildTaskCards(String status) {
    final filteredTasks = allTasks.where((task) =>
    (task['status'] ?? '').toLowerCase() == status.toLowerCase()).toList();

    if (filteredTasks.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: Text('No tasks found for this status.')),
        )
      ];
    }

    return filteredTasks.map((task) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        color: Colors.cyan[100],
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Applicant: ${task['applicantName'] ?? 'N/A'}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17)),
              Text("Address: ${task['address'] ?? 'N/A'}"),
              Text("Contact No: ${task['contactNumber'] ?? 'N/A'}"),
              const SizedBox(height: 8),
              Text("Product: ${task['product'] ?? 'N/A'}"),
              Text("Bank: ${task['bankName'] ?? 'N/A'}"),
              Text("Initiate: ${(task['createdAt'] ?? '').toString().substring(
                  0, 10)}"),
              Text("Trigger: ${task['trigger'] ?? 'N/A'}"),
              const SizedBox(height: 8),
              Text("Assign Date: ${task['assignDate'] ?? 'N/A'}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (status.toLowerCase() == 'draft')
                      ? Text(
                    'Under Verification',
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  )
                      : (status.toLowerCase() == 'pending')
                      ? Text(
                    status,
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  )
                      : Text(
                    'Draft',
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  (status.toLowerCase() == 'pending')
                      ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              OfficeProfile(
                                applicantName: task['applicantName'] ?? 'N/A',
                                address: task['address'] ?? 'N/A',
                                contactNumber: task['contactNumber'] ?? 'N/A',
                                taskId: task['_id'] ?? 'N/A',
                              ),
                        ),
                      );
                    },
                    child: const Text("Start Now"),
                  )
                      : (status.toLowerCase() == 'draft')
                      ? SizedBox(width: 10,)
                      : ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              OfficeProfile(
                                applicantName: task['applicantName'] ?? 'N/A',
                                address: task['address'] ?? 'N/A',
                                contactNumber: task['contactNumber'] ?? 'N/A',
                                taskId: task['_id'] ?? 'N/A',
                              ),
                        ),
                      );
                    },
                    child: const Text("Sync"),
                  ),

                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }


  Future<void> syncOfflineSubmissions() async {
    setState(() {
      isLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList('offline_submissions') ?? [];

    if (jsonList.isEmpty) {
      print("❌ No offline submissions to sync.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ No offline submissions to sync."),
          backgroundColor: Colors.grey,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final List<String> remainingSubmissions = [];

    for (int i = 0; i < jsonList.length; i++) {
      try {
        Map<String, dynamic> data = jsonDecode(jsonList[i]);

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://api.zaikanuts.shop/api/send-record'),
        );

        // Attach normal fields
        data.forEach((key, value) {
          if (value is String && !_isBase64Image(value)) {
            request.fields[key] = value;
            print("📝 $key: $value");
          }
        });

        // Attach addressImage1 & addressImage2 → addressImage[]
        for (int j = 1; j <= 2; j++) {
          String base64Key = 'addressImage$j';
          if (data.containsKey(base64Key)) {
            String base64Str = data[base64Key];
            Uint8List bytes = base64Decode(base64Str);
            request.files.add(
              http.MultipartFile.fromBytes(
                'addressImage',
                bytes,
                filename: 'addressImage$j.jpg',
                contentType: MediaType('image', 'jpeg'),
              ),
            );
            print(" Attached addressImage[]: addressImage$j.jpg (${bytes
                .length} bytes)");
          }
        }

        // Attach image3–6 → images[]
        for (int j = 3; j <= 6; j++) {
          String base64Key = 'image$j';
          if (data.containsKey(base64Key)) {
            String base64Str = data[base64Key];
            Uint8List bytes = base64Decode(base64Str);
            request.files.add(
              http.MultipartFile.fromBytes(
                'images',
                bytes,
                filename: 'image$j.jpg',
                contentType: MediaType('image', 'jpeg'),
              ),
            );
            print(" Attached images[]: image$j.jpg (${bytes.length} bytes)");
          }
        }

        print("Sending request to: ${request.url}");

        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        print(" Response Status: ${response.statusCode}");
        print(" Response Body: $responseBody");

        if (response.statusCode == 200 &&
            responseBody.contains('"success":true')) {
          print("✅ Submission #${i + 1} synced successfully.");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✅ Submission #${i + 1} synced successfully."),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          print("❌ Failed to sync submission #${i + 1}. Keeping it for retry.");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("❌ Failed to sync submission #${i + 1}. Keeping it for retry."),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
          remainingSubmissions.add(jsonList[i]);
        }
      } catch (e) {
        print("⚠️ Error syncing submission #${i + 1}: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("⚠️ Error syncing submission #${i + 1}"),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
        remainingSubmissions.add(jsonList[i]);
      }
    }

    // Save only failed submissions back
    await prefs.setStringList('offline_submissions', remainingSubmissions);
    setState(() {
      isLoading = false;
    });

    print(
        "🧹 Updated offline storage. Remaining: ${remainingSubmissions.length}");
  }

  bool _isBase64Image(String str) {
    return str.length > 100 && RegExp(r'^[A-Za-z0-9+/]+={0,2}$').hasMatch(str);
  }


  Future<bool> hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // or prefs.remove('isLoggedIn');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () => _logout(context), // Call logout
          tooltip: 'Logout',
        ),
        title: const Center(
          child: Text(
            "Let's Start The Work",
            style: TextStyle(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: refreshPage,
            tooltip: 'Refresh',
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
          child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
          : Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.deepPurple[100],
            ),
            child: Row(
              children: const [
                Icon(Icons.search, size: 24),
                SizedBox(width: 10),
                Text('May 24, 2025',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                Spacer(),
                Icon(Icons.calendar_today, size: 24),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(children: buildTaskCards('draft')),
                ListView(children: buildTaskCards('pending')),

                FutureBuilder<List<Widget>>(
                  future: buildOfflineCards(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error loading offline data."));
                    } else {
                      final cards = snapshot.data ?? [];

                      if (cards.isEmpty) {
                        return const Center(child: Text("No offline submissions found."));
                      }

                      return ListView(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                        children: [
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                bool online = await hasInternetConnection();
                                if (!online) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('❌ No internet connection, Connect to Internet First')),
                                  );
                                  return;
                                }
                                await syncOfflineSubmissions();
                                refreshPage(); // refresh after syncing
                              },
                              icon: const Icon(Icons.cloud_upload),
                              label: const Text(' Sync Offline Submissions'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...cards,
                        ],
                      );
                    }
                  },
                )

              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.deepPurple,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[400],
            tabs: const [
              Tab(icon: Icon(Icons.check), text: 'Under Verification'),
              Tab(icon: Icon(Icons.access_time), text: 'Pending'),
              Tab(icon: Icon(Icons.drafts), text: 'Draft'),
            ],
          ),
        ),
      ),
    );
  }
}


