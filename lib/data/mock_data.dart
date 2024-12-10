import 'package:fintech_dashboard_clone/models/enums/transaction_type.dart';
import 'package:fintech_dashboard_clone/models/expense.dart';
import 'package:fintech_dashboard_clone/models/transaction.dart';
import 'package:fintech_dashboard_clone/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MockData {
  static BarChartGroupData makeGroupData(
      int x, double y1, Color barColor, double width) {
    return BarChartGroupData(
      barsSpace: 1,
      x: x,
      barRods: [
        BarChartRodData(
          y: y1,
          colors: [barColor],
          width: width,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ],
    );
  }

  static List<BarChartGroupData> getBarChartitems(Color color,
      {double width = 20}) {
    return [
      makeGroupData(0, 5, color, width),
      makeGroupData(1, 6, color, width),
      makeGroupData(2, 8, color, width),
      makeGroupData(3, 5, color, width),
      makeGroupData(4, 7, color, width),
      makeGroupData(5, 9, color, width),
      makeGroupData(6, 3, color, width),
    ];
  }

  static List<User> get users {
  return [
    User(
      id: "1",
      nom: "Doe",
      prenom: "John",
      mail: "john.doe@example.com",
      number: "+216 12345678",
      sexe: "Femme",
      role: "Maman",
    ),
    User(
      id: "1",
      nom: "Wiem",
      prenom: "Ayari",
      mail: "john.doe@example.com",
      number: "+216 12345678",
      sexe: "Femme",
      role: "Maman",
    ),
    User(
      id: "2",
      nom: "Smith",
      prenom: "Jane",
      mail: "jane.smith@example.com",
      number: "+216 98765432",
      sexe: "Femme",
      role: "Medecin",
    ),
    User(
      id: "3",
      nom: "Brown",
      prenom: "James",
      mail: "james.brown@example.com",
      number: "+216 55566789",
      sexe: "Homme",
      role: "Admin",
    ),
  ];
}


  static List<Expense> get otherExpanses {
    return [
      Expense(
        color: Styles.defaultBlueColor,
        expenseName: "Maman",
        expensePercentage: 50,
      ),
      Expense(
        color: Styles.defaultRedColor,
        expenseName: "Medecin",
        expensePercentage: 35,
      ),
      Expense(
        color: Styles.defaultYellowColor,
        expenseName: "Admin",
        expensePercentage: 15,
      )
    ];
  }
}
