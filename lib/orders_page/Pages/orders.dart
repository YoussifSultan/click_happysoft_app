import 'package:click_happysoft_app/orders_page/classes/orders_class.dart';
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
  List<Order> orders = [
    Order(
        orderId: 1,
        productId: 1,
        productName: 'Mirrors',
        customerId: 2,
        customerName: 'Aly',
        quantity: 5),
    Order(
        orderId: 2,
        productId: 1,
        productName: 'Mirrors',
        customerId: 2,
        customerName: 'Aly',
        quantity: 5),
    Order(
        orderId: 2,
        productId: 1,
        productName: 'Mirrors',
        customerId: 2,
        customerName: 'Aly',
        quantity: 5),
    Order(
        orderId: 2,
        productId: 1,
        productName: 'Mirrors',
        customerId: 2,
        customerName: 'Aly',
        quantity: 5),
    Order(
        orderId: 2,
        productId: 1,
        productName: 'Mirrors',
        customerId: 2,
        customerName: 'Aly',
        quantity: 5),
    Order(
        orderId: 2,
        productId: 1,
        productName: 'Mirrors',
        customerId: 2,
        customerName: 'Aly',
        quantity: 5),
    Order(
        orderId: 2,
        productId: 1,
        productName: 'Mirrors',
        customerId: 2,
        customerName: 'Aly',
        quantity: 5),
    Order(
        orderId: 2,
        productId: 1,
        productName: 'Mirrors',
        customerId: 2,
        customerName: 'Aly',
        quantity: 5),
    Order(
        orderId: 2,
        productId: 1,
        productName: 'Mirrors',
        customerId: 2,
        customerName: 'Aly',
        quantity: 5),
  ];
  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
        body: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final item = orders[index];
              return ListTile(
                title: Text(
                  item.customerName,
                  style: const TextStyle(color: AppColors.black, fontSize: 18),
                ),
                trailing: Text(
                  "${item.productName} - ${item.quantity}",
                  style: const TextStyle(color: AppColors.gray, fontSize: 13),
                ),
                onTap: () {
                  Get.toNamed(AppRoutes.editOrder, arguments: item.toMap());
                },
              );
            }));
  }
}
