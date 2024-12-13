import 'package:fintech_dashboard_clone/layout/app_layout.dart';  // Import for AppLayout
import 'package:fintech_dashboard_clone/models/card_details.dart';  // Import for CardDetails
import 'package:fintech_dashboard_clone/models/enums/card_type.dart';  // Import for CardType
import 'package:fintech_dashboard_clone/sections/expense_income_chart.dart';
import 'package:fintech_dashboard_clone/sections/latest_transactions.dart';
import 'package:fintech_dashboard_clone/sections/statics_by_category.dart';
import 'package:fintech_dashboard_clone/sections/upgrade_pro_section.dart';
import 'package:fintech_dashboard_clone/sections/your_cards_section.dart';
import 'package:fintech_dashboard_clone/styles/styles.dart';
import 'package:fintech_dashboard_clone/responsive.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AppLayout(
          content: Row(
            children: [
              // Main Panel
              Expanded(
                child: Column(
                  children: [
                    // Set flex value to 1.5 to adjust the height of ExpenseIncomeCharts
                    const Expanded(
                      flex: 1,  // Set flex to 3 for ExpenseIncomeCharts (1.5 equivalent)
                      child: ExpenseIncomeCharts(),
                    ),
                
                   
                  ],
                ),
                flex: 5,
              ),
              // Right Panel
              Visibility(
                visible: Responsive.isDesktop(context),
                child: Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: Styles.defaultPadding),
                    child: Column(
                      children: [
                        CardsSection(
                          cardDetails: [
                            CardDetails("431421432", CardType.mastercard),
                            CardDetails("423142231", CardType.mastercard),
                          ],
                        ),
                        const Expanded(
                          child: StaticsByCategory(),
                        ),
                      ],
                    ),
                  ),
                  flex: 2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
