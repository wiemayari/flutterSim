import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LatestTransactions extends StatefulWidget {
  @override
  _LatestTransactionsState createState() => _LatestTransactionsState();
}

class _LatestTransactionsState extends State<LatestTransactions> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/auth/users/'));
      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
        });
      } else {
        print('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(
            Colors.red.withOpacity(0.1),
          ),
          columns: const [
            DataColumn(label: Text("ID")),
            DataColumn(label: Text("Nom")),
            DataColumn(label: Text("Email")),
            DataColumn(label: Text("Bio")),
            DataColumn(label: Text("Image URI")),
            DataColumn(label: Text("Rôle ID")),
          ],
          rows: users.map((user) {
            return DataRow(
              cells: [
                DataCell(Text(user['id'] ?? '')),
                DataCell(Text(user['username'] ?? '')),
                DataCell(Text(user['email'] ?? '')),
                DataCell(Text(user['bio'] ?? '')),
                DataCell(Text(user['imageUri'] ?? '')),
                DataCell(Text(user['roleId']?.toString() ?? '')),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
