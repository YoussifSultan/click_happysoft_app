import 'package:click_happysoft_app/RVrequest_page/Classes/paymentmethods.dart';
import 'package:click_happysoft_app/constants/common_constants.dart';
import 'package:click_happysoft_app/constants/scaffolds/primary_scaffold.dart';
import 'package:click_happysoft_app/constants/ui_constants/form_widgets.dart';
import 'package:click_happysoft_app/dashboard_page/dashboard_sql_manager.dart';
import 'package:click_happysoft_app/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int noNotValidCustomers = 0;
  int noValidCustomers = 0;
  int noNotValidOrders = 0;
  int noValidOrders = 0;
  Map<String, double> cashBalance = {};
  Map<String, double> chequeBalance = {};

  Future<void> fetchDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    int salesmanID = prefs.getInt('salesman_id')!;
    noNotValidCustomers =
        await DashboardSqlManager.getNoCustomers(false, salesmanID);
    noNotValidOrders = await DashboardSqlManager.getNoOrders(false, salesmanID);
    noValidCustomers =
        await DashboardSqlManager.getNoCustomers(true, salesmanID);
    noValidOrders = await DashboardSqlManager.getNoOrders(true, salesmanID);
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
              BalanceCard(
                icon: Icons.people,
                details: [
                  DetailRow(
                      title: noNotValidCustomers.toString(),
                      caption: 'Not Valid Customers'),
                  DetailRow(
                      title: noValidCustomers.toString(),
                      caption: "Valid Customers")
                ],
                title: "${noNotValidCustomers + noValidCustomers}",
                onAddButtionPressed: () {
                  Get.toNamed(AppRoutes.addnewCustomer);
                  setState(() {});
                },
                caption: 'Total NO Customers',
              ),
              BalanceCard(
                icon: Icons.edit,
                details: [
                  DetailRow(
                      title: noNotValidOrders.toString(),
                      caption: 'Not Valid Orders'),
                  DetailRow(
                      title: noValidOrders.toString(), caption: "Valid Orders")
                ],
                title: "${noNotValidOrders + noValidOrders}",
                caption: 'Total NO Orders',
                onAddButtionPressed: () async {
                  await Get.toNamed(AppRoutes.addNewOrder);
                  setState(() {});
                },
                onDetailsButtionPressed: () async {
                  await Get.toNamed(AppRoutes.orders);
                  setState(() {});
                },
              ),
              BalanceCard(
                details: cashBalance.entries.map((e) {
                  return DetailRow(title: e.value.toString(), caption: e.key);
                }).toList(),
                title: '${cashBalance['EGP'] ?? 0.0} EGP',
                caption: 'Salesman Cash Balance',
                onAddButtionPressed: () async {
                  await Get.toNamed(AppRoutes.addnewReceiptVoucherRequest);
                  setState(() {});
                },
              ),
              BalanceCard(
                icon: Icons.account_balance,
                details: chequeBalance.entries.map((e) {
                  return DetailRow(title: e.value.toString(), caption: e.key);
                }).toList(),
                title: '${chequeBalance['EGP'] ?? 0.0} EGP',
                caption: 'Salesman Cheque Balance',
                onAddButtionPressed: () async {
                  await Get.toNamed(AppRoutes.addnewReceiptVoucherRequest);
                  setState(() {});
                },
              ),
              AppSpacing.v24
            ]);
          },
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
      required this.caption,
      this.icon = Icons.account_balance_wallet_outlined,
      this.onAddButtionPressed,
      this.onDetailsButtionPressed});
  final List<DetailRow> details;
  final String title;
  final String caption;
  final Function? onAddButtionPressed;
  final Function? onDetailsButtionPressed;
  final IconData icon;
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 32),
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
                CustomIconButton(
                    color: AppColors.primary,
                    icon: Icons.add,
                    onPressed: () {
                      onAddButtionPressed!();
                    })
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
                child: GestureDetector(
                  onTap: () {
                    if (onDetailsButtionPressed == null) {
                      Get.snackbar("Info", "No Details Available");
                    } else {
                      onDetailsButtionPressed!();
                    }
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("View Details",
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)),
                      AppSpacing.h8,
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                )),
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
