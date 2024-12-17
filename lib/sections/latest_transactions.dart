import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Model class to represent the API response
class ResponseModel {
  final String query;
  final String response;
  final String category;
  final String id;
  final String createdAt;
  final int version;

  ResponseModel({
    required this.query,
    required this.response,
    required this.category,
    required this.id,
    required this.createdAt,
    required this.version,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      query: json['query'] ?? '',
      response: json['response'] ?? '',
      category: json['category'] ?? '',
      id: json['_id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      version: json['__v'] ?? 0,
    );
  }
}

class LatestTransactions extends StatefulWidget {
  @override
  _LatestTransactionsState createState() => _LatestTransactionsState();
}

class _LatestTransactionsState extends State<LatestTransactions> {
  List<dynamic> users = [];
  List<ResponseModel> responses = [];
  String searchQuery = '';
  Map<String, String> roleNames = {};

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchRoles();
  }

  /// Fetch users data for the table
  Future<void> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/auth/users/'));
      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body) ?? [];
        });
      } else {
        print('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  /// Fetch roles data to get role names
  Future<void> fetchRoles() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/roles/'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        roleNames = jsonData.fold<Map<String, String>>(
            {}, (Map<String, String> map, role) {
          map[role['_id']] = role['name'] ?? 'N/A';
          return map;
        });
      } else {
        print('Failed to load roles');
      }
    } catch (e) {
      print('Error fetching roles: $e');
    }
  }

  /// Fetch a list of responses from the API and display them in a popup
  Future<void> fetchAndShowResponses(BuildContext context, String userId) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/response?userId=$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        responses = jsonData.map((data) => ResponseModel.fromJson(data)).toList();

        // Show the responses in a dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("AI Responses"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: responses.map((response) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Query:", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(response.query.isNotEmpty ? response.query : 'N/A'),
                          SizedBox(height: 8.0),
                          Text("Response:", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(response.response.isNotEmpty ? response.response : 'N/A'),
                          SizedBox(height: 8.0),
                          Text("Category:", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(response.category.isNotEmpty ? response.category : 'N/A'),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Close"),
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to load responses');
      }
    } catch (e) {
      print('Error fetching responses: $e');
    }
  }

  /// Filter the users based on the search query
  List<dynamic> get filteredUsers {
    if (searchQuery.isEmpty) {
      return users;
    }
    return users.where((user) {
      return (user['username'] != null && user['username'].toLowerCase().contains(searchQuery.toLowerCase())) ||
             (user['email'] != null && user['email'].toLowerCase().contains(searchQuery.toLowerCase())) ||
             (user['bio'] != null && user['bio'].toLowerCase().contains(searchQuery.toLowerCase())) ||
             (roleNames[user['roleId']] != null && roleNames[user['roleId']]!.toLowerCase().contains(searchQuery.toLowerCase()));
    }).toList();
  }

  /// Delete a user after confirming
  Future<void> deleteUser(String userId) async {
    // Logic to delete the user from the server (if required)
    // For now, we just remove it from the local list
    setState(() {
      users.removeWhere((user) => user['_id'] == userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: "Search...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: (query) {
              setState(() {
                searchQuery = query;
              });
            },
          ),
          SizedBox(height: 16.0),
          // DataTable
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.red.withOpacity(0.1)),
              columns: const [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("Nom")),
                DataColumn(label: Text("Email")),
                DataColumn(label: Text("Bio")),
                DataColumn(label: Text("Rôle")),  // Displaying role name here
                DataColumn(label: Text("Action")),
              ],
              rows: filteredUsers.map((user) {
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          Text(
                            user['_id'] != null
                                ? '${user['_id']!.substring(0, 4)}'
                                : 'N/A',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          if (user['_id'] != null && user['_id']!.length > 4)
                            // Apply a more intense blur effect to the rest of the id
                            Text(
                              user['_id']!.substring(4),
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.005),
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5.0,
                                    color: Colors.grey.withOpacity(0.9),
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    DataCell(Text(user['username'] ?? 'N/A')),
                    DataCell(Text(user['email'] ?? 'N/A')),
                    DataCell(Text(user['bio'] ?? 'N/A')),
                    DataCell(Text(roleNames[user['roleId']] ?? 'N/A')),  // Show role name
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.chat_bubble, color: Colors.blue),
                            onPressed: () {
                              // Fetch and display the AI responses when chat icon is clicked
                              fetchAndShowResponses(context, user['_id']);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Show confirmation dialog before deletion
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm Deletion"),
                                    content: Text("Are you sure you want to delete this user?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          deleteUser(user['_id']);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Delete"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text("Cancel"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
