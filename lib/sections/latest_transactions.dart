import 'package:flutter/material.dart';
import 'package:fintech_dashboard_clone/styles/styles.dart';
import 'package:fintech_dashboard_clone/data/mock_data.dart';

class LatestTransactions extends StatelessWidget {
  LatestTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = MockData.users;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Liste des utilisateurs",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                child: Text(
                  "Voir tout",
                  style: TextStyle(
                    color: Styles.defaultRedColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  // Implement your logic here
                },
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.9, // Increase width
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white, // White background
            borderRadius: BorderRadius.circular(16), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(
              Styles.defaultRedColor.withOpacity(0.1), // Header row background
            ),
            columns: const [
              DataColumn(label: Text("ID")),
              DataColumn(label: Text("Nom")),
              DataColumn(label: Text("Prénom")),
              DataColumn(label: Text("Mail")),
              DataColumn(label: Text("Numéro")),
              DataColumn(label: Text("Sexe")),
              DataColumn(label: Text("Rôle")),
            ],
            rows: users
                .map(
                  (user) => DataRow(
                    cells: [
                      DataCell(Text(user.id)),
                      DataCell(Text(user.nom)),
                      DataCell(Text(user.prenom)),
                      DataCell(Text(user.mail)),
                      DataCell(Text(user.number)),
                      DataCell(Text(user.sexe)),
                      DataCell(Text(user.role)),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
