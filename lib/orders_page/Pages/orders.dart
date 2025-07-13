import 'package:click_happysoft_app/orders_page/Viewmodels/ordersfulldata.dart';
import 'package:click_happysoft_app/orders_page/order_sql_manager.dart';
import 'package:click_happysoft_app/routing/app_routes.dart';
import 'package:click_happysoft_app/ui_commonwidgets/common_constants.dart';
import 'package:click_happysoft_app/ui_commonwidgets/primary_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
        body: FutureBuilder<List<OrderDetailsVM>>(
      future: OrderSqlManager.fetchAllOrders(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final orders = snapshot.data!;
        return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text(
                  order.customerName,
                  style: const TextStyle(color: AppColors.black, fontSize: 18),
                ),
                trailing: Text(
                  "${order.productName} - ${order.qty}",
                  style: const TextStyle(color: AppColors.gray, fontSize: 13),
                ),
                onTap: () {
                  Get.toNamed(AppRoutes.editOrder, arguments: order.toMap());
                },
              );
            });
      },
    ));
  }
}
