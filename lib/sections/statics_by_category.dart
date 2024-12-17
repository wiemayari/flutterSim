import 'package:fintech_dashboard_clone/data/mock_data.dart';
import 'package:fintech_dashboard_clone/models/expense.dart';
import 'package:fintech_dashboard_clone/models/pie_data.dart';
import 'package:fintech_dashboard_clone/styles/styles.dart';
import 'package:fintech_dashboard_clone/widgets/category_box.dart';
import 'package:fintech_dashboard_clone/widgets/expense_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StaticsByCategory extends StatefulWidget {
  const StaticsByCategory({Key? key}) : super(key: key);

  @override
  State<StaticsByCategory> createState() => _StaticsByCategoryState();
}

class _StaticsByCategoryState extends State<StaticsByCategory> {
  int touchedIndex = -1;
  final ScrollController _scrollController = ScrollController();
  late Future<Map<String, double>> rolePercentages;

  @override
  void initState() {
    super.initState();
    rolePercentages = fetchRolePercentages();
  }

  Future<Map<String, double>> fetchRolePercentages() async {
    final response = await http.get(Uri.parse('http://localhost:3000/auth/role-percentages'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      double otherPercentage = 100.0 - data['percentages'].values.reduce((a, b) => a + b); // Calculate the remaining percentage
      data['percentages']['Other'] = otherPercentage; // Add "Other" category
      return data['percentages'].cast<String, double>();
    } else {
      throw Exception('Failed to load role percentages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Styles.defaultPadding),
      child: CategoryBox(
        suffix: Container(),
        title: "Statistics Des Utilisateur ",
        children: [
          Expanded(
            child: FutureBuilder<Map<String, double>>(
              future: rolePercentages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No data available');
                } else {
                  final data = snapshot.data!;
                  return Column(
                    children: [
                      _pieChart(
                        data.entries
                            .map(
                              (e) => PieData(value: e.value, color: getColorForRole(e.key)),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 10),
                      _colorLegend(data),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Color getColorForRole(String roleName) {
    switch (roleName) {
      case 'Maman':
        return Styles.defaultBlueColor;
      case 'Medecin':
        return Styles.defaultRedColor;
      case 'Admin':
        return Styles.defaultYellowColor;
      case 'Other':
        return Styles.defaultGrayColor; // color for "Other" category
      default:
        return Styles.defaultGrayColor; // fallback color if role not found
    }
  }

  Widget _colorLegend(Map<String, double> data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Styles.defaultLightWhiteColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...data.entries.map(
            (e) => Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: getColorForRole(e.key),
                ),
                SizedBox(width: 4),
                Text("${e.key}: ${e.value.toStringAsFixed(1)}%"),
              ],
            ),
          ).toList(),
        ],
      ),
    );
  }

  Widget _otherExpanses(List<Expense> otherExpenses) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Styles.defaultLightWhiteColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(2),
        children: otherExpenses
            .map((Expense e) => ExpenseWidget(expense: e))
            .toList(),
      ),
    );
  }

  Widget _pieChart(List<PieData> data) {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              touchedIndex == -1
                  ? "100%"
                  : "${data[touchedIndex].value.toStringAsFixed(0)}%",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          PieChart(
            PieChartData(
              sections: data
                  .map(
                    (e) => PieChartSectionData(
                      color: e.color,
                      value: e.value,
                      radius: touchedIndex == data.indexOf(e) ? 35.0 : 25.0,
                      title: '',
                    ),
                  )
                  .toList(),
              pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              }),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 50,
            ),
            swapAnimationDuration: const Duration(milliseconds: 150),
            swapAnimationCurve: Curves.linear,
          ),
        ],
      ),
    );
  }
}
