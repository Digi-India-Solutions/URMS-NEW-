import 'dart:convert';
import 'package:flutter/material.dart';
import '../officeRecords/offileProfile.dart';
import '../services/api_services.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchTasks();
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
          errorMessage = 'Failed to load tasks. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching tasks: $e';
      });
    }
  }

  List<Widget> buildTaskCards(String status) {
    final filteredTasks = allTasks.where((task) => (task['status'] ?? '').toLowerCase() == status.toLowerCase()).toList();

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
              Text("Applicant: ${task['applicantName'] ?? 'N/A'}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              Text("Address: ${task['address'] ?? 'N/A'}"),
              Text("Contact No: ${task['contactNumber'] ?? 'N/A'}"),
              const SizedBox(height: 8),
              Text("Product: ${task['product'] ?? 'N/A'}"),
              Text("Bank: ${task['bankName'] ?? 'N/A'}"),
              Text("Initiate: ${(task['createdAt'] ?? '').toString().substring(0, 10)}"),
              Text("Trigger: ${task['trigger'] ?? 'N/A'}"),
              const SizedBox(height: 8),
              Text("Assign Date: ${task['assignDate'] ?? 'N/A'}", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    status,
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                  if (status.toLowerCase() != 'complete')
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OfficeProfile(
                              applicantName: task['applicantName'] ?? 'N/A',
                              address: task['address'] ?? 'N/A',
                              contactNumber: task['contactNumber'] ?? 'N/A',
                            ),
                          ),
                        );
                      },
                      child: const Text("Start Now"),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Center(
          child: Text(
            "Let's Start The Work",
            style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Spacer(),
                Icon(Icons.calendar_today, size: 24),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(children: buildTaskCards('complete')),
                ListView(children: buildTaskCards('pending')),
                ListView(children: buildTaskCards('draft')),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.deepPurple,
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
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
