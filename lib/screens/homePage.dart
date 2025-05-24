import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> allTasks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      final response = await ApiService.getAllTasks();
      final jsonResponse = jsonDecode(response.body);
      print('API response: ${response.body}');

      if (jsonResponse['success']) {
        setState(() {
          allTasks = jsonResponse['data'];
        });
      }
    } catch (e) {
      debugPrint('Error fetching tasks: $e');
    }
  }

  List<Widget> buildTaskCards(String status) {
    final filteredTasks = allTasks.where((task) => task['status'].toLowerCase() == status.toLowerCase()).toList();

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
              Row(
                children: [
                  // CircleAvatar(backgroundImage: AssetImage('assets/profile.jpg'), radius: 24),
                  // const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Applicant: ${task['applicantName']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                        Text("Address: ${task['address']}", style: const TextStyle(fontSize: 14)),
                        Text("Contact No: ${task['contactNumber']}", style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Product: ${task['product']}", style: const TextStyle(fontSize: 14)),
                      Text("Bank: ${task['bankName']} ", style: const TextStyle(fontSize: 14)),

                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Initiate: ${task['createdAt'].substring(0, 10)}", style: const TextStyle(fontSize: 14)),
                      Text("Trigger: ${task['trigger']}", style: const TextStyle(fontSize: 14)),

                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Center(child: Text("ASSIGN DATE: ${task['assignDate']}", style: const TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    status,
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                  // Show button only if status is NOT 'complete' (under verification)
                  if (status.toLowerCase() != 'complete')
                    ElevatedButton(
                      onPressed: () {},
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
        title: Center(
          child: Text(
            "Let's Start The Work",
            style: TextStyle(fontSize: 30 ,color: Colors.white,fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
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
          labelColor: Colors.white,      // selected tab text/icon color
          unselectedLabelColor: Colors.grey[400], // unselected tabs color
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
