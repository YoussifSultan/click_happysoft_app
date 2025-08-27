import 'package:click_happysoft_app/RVrequest_page/Classes/paymentmethods.dart';
import 'package:click_happysoft_app/constants/common_constants.dart';
import 'package:click_happysoft_app/constants/scaffolds/primary_scaffold.dart';
import 'package:click_happysoft_app/constants/ui_constants/form_widgets.dart';
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
  Map<String, double> cashBalance = {};
  Map<String, double> chequeBalance = {};

  Future<void> fetchDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    int salesmanID = prefs.getInt('salesman_id')!;
    noNotValidCustomers =
        await DashboardSqlManager.getNoCustomers(true, salesmanID);
    noNotValidOrders = await DashboardSqlManager.getNoOrders(true, salesmanID);
    cashBalance =
        await DashboardSqlManager.getBalance(salesmanID, PaymentMethod.cash);
    chequeBalance =
        await DashboardSqlManager.getBalance(salesmanID, PaymentMethod.cheque);
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: fetchDashboardData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(shrinkWrap: true, children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                children: [
                  PowerBiCard(
                      value: "$noNotValidCustomers",
                      caption: "No of Customers"),
                  PowerBiCard(
                      value: "$noNotValidOrders", caption: "No of Orders"),
                ],
              ),
              BalanceCard(
                details: cashBalance.entries.map((e) {
                  return DetailRow(title: e.value.toString(), caption: e.key);
                }).toList(),
                title: '${cashBalance['EGP'] ?? 0.0} EGP',
                caption: 'Salesman Cash Balance',
              ),
              BalanceCard(
                details: chequeBalance.entries.map((e) {
                  return DetailRow(title: e.value.toString(), caption: e.key);
                }).toList(),
                title: '${chequeBalance['EGP'] ?? 0.0} EGP',
                caption: 'Salesman Cheque Balance',
              )
            ]);
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
      color: Colors.white,
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

class BalanceCard extends StatelessWidget {
  const BalanceCard(
      {super.key,
      required this.details,
      required this.title,
      required this.caption});
  final List<DetailRow> details;
  final String title;
  final String caption;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 16, left: 10, right: 10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total availability
            Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined, size: 32),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      caption,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 30, thickness: 1),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(details[index].caption,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey)),
                    Text(
                      details[index].title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
              itemCount: details.length,
            ),

            AppSpacing.v16,
            // Details button
            Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  text: 'Details',
                  color: AppColors.primary,
                  icon: Icons.login_outlined,
                  height: 60,
                  onPressed: () {},
                ))
          ],
        ),
      ),
    );
  }
}

class DetailRow {
  final String title;
  final String caption;

  DetailRow({
    required this.title,
    required this.caption,
  });
}
