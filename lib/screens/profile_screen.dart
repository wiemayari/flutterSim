import 'package:flutter/material.dart';
import 'package:fintech_dashboard_clone/layout/navigation_panel.dart';
import 'package:fintech_dashboard_clone/layout/top_app_bar.dart';
import 'package:fintech_dashboard_clone/responsive.dart';
import 'package:fintech_dashboard_clone/styles/styles.dart';
import 'package:fintech_dashboard_clone/sections/latest_transactions.dart';
import 'package:fintech_dashboard_clone/sections/statics_by_category.dart';
import 'package:fintech_dashboard_clone/sections/upgrade_pro_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Responsive(
          mobile: SingleChildScrollView(
            child: Column(
              children: [
                const TopAppBar(),
                const SizedBox(height: 20),
                _buildSectionContainer(
                  context: context,
                  child: const UpgradeProSection(),
                  height: 150,
                ),
                const SizedBox(height: 20),
                _buildSectionContainer(
                  context: context,
                  child: LatestTransactions(),
                ),
                const SizedBox(height: 20),
                _buildSectionContainer(
                  context: context,
                  child: const StaticsByCategory(),
                  height: 250,
                ),
                const SizedBox(height: 20),
                const NavigationPanel(axis: Axis.horizontal),
              ],
            ),
          ),
          desktop: Row(
            children: [
              const NavigationPanel(axis: Axis.vertical),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 10.0,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 100,
                          child: TopAppBar(),
                        ),
                        const SizedBox(height: 20),
                        _buildSectionContainer(
                          context: context,
                          child: const UpgradeProSection(),
                          height: 150,
                        ),
                        const SizedBox(height: 20),
                        _buildSectionContainer(
                          context: context,
                          child: LatestTransactions(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContainer({
    required BuildContext context,
    required Widget child,
    double? height,
  }) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Styles.defaultLightWhiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: child,
      ),
    );
  }
}