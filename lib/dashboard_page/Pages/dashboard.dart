import 'dart:convert';

import 'package:click_happysoft_app/constants/scaffolds/primary_scaffold.dart';
import 'package:click_happysoft_app/dashboard_page/dashboard_sql_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int noNotValidCustomers = 0;
  int noNotValidOrders = 0;

  Future<void> fetchDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    int salesmanID = prefs.getInt('salesman_id')!;
    noNotValidCustomers = jsonDecode(
        (await DashboardSqlManager.getNoCustomers(false, salesmanID))
            .body)['Count(*)'] as int;
    noNotValidOrders = jsonDecode(
        (await DashboardSqlManager.getNoOrders(false, salesmanID))
            .body)['Count(*)'] as int;
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: fetchDashboardData(),
          builder: (context, snapshot) {
            return GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              children: [
                PowerBiCard(
                    value: "$noNotValidCustomers", caption: "No of Customers"),
                PowerBiCard(
                    value: "$noNotValidOrders", caption: "No of Orders"),
                const PowerBiCard(value: "320", caption: "No of Products"),
                const PowerBiCard(value: "", caption: ""),
              ],
            );
          },
        ),
      ),
    );
  }
}

class PowerBiCard extends StatelessWidget {
  final String value;
  final String caption;

  const PowerBiCard({
    super.key,
    required this.value,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Value (large, bold, like Power BI metric)
            Text(
              value,
              style: const TextStyle(
                fontSize: 32, // Bigger number
                fontWeight: FontWeight.w600,
                color: Colors.black, // Strong dark text
              ),
            ),
            const SizedBox(height: 6),
            // Caption (small, grey, like Power BI label)
            Text(
              caption,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey, // Muted caption
              ),
            ),
          ],
        ),
      ),
    );
  }
}
