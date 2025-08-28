import 'package:click_happysoft_app/constants/pages/list.dart';
import 'package:click_happysoft_app/constants/scaffolds/secondary_scaffold.dart';
import 'package:click_happysoft_app/orders_page/Viewmodels/ordersfulldata.dart';
import 'package:click_happysoft_app/orders_page/order_sql_manager.dart';
import 'package:click_happysoft_app/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<OrderDetailsVM> orders = [];
  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchOrdersOfSalesman() async {
    final prefs = await SharedPreferences.getInstance();
    int salesmanID = prefs.getInt('salesman_id')!;
    orders = await OrderSqlManager.fetchAllOrders(salesmanID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchOrdersOfSalesman(),
        builder: (context, _) {
          if (orders.isEmpty) {
            return const SecondaryScaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return ListViewPage(
              dataName: "Orders",
              listItems: orders.map((order) {
                return ListItem(
                    title: order.customerName,
                    subtitle: "${order.productName} - ${order.qty}",
                    trailing: DateFormat('dd/MM/yyyy').format(order.date),
                    onTap: () {
                      Get.toNamed(AppRoutes.editOrder,
                          arguments: order.toMap());
                    });
              }).toList());
        });
  }
}
