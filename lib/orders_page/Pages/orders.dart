import 'package:click_happysoft_app/orders_page/Viewmodels/ordersfulldata.dart';
import 'package:click_happysoft_app/orders_page/order_sql_manager.dart';
import 'package:click_happysoft_app/routing/app_routes.dart';
import 'package:click_happysoft_app/ui_commonwidgets/common_constants.dart';
import 'package:click_happysoft_app/ui_commonwidgets/primary_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    fetchOrdersOfSalesman();
    super.initState();
  }

  Future<List<OrderDetailsVM>> fetchOrdersOfSalesman() async {
    final prefs = await SharedPreferences.getInstance();
    int salesmanID = prefs.getInt('salesman_id')!;
    final orderListController = Get.find<OrdersListController>();
    List<OrderDetailsVM> orders =
        await OrderSqlManager.fetchAllOrders(salesmanID);
    orderListController.orders.assignAll(orders);
    print("Fetched ${orders.length} orders for salesman ID $salesmanID");
    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(body: Obx(() {
      final orders = Get.find<OrdersListController>().orders;
      if (orders.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        );
      }
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
    }));
  }
}

class OrdersListController extends GetxController {
  final RxList<OrderDetailsVM> orders = <OrderDetailsVM>[].obs;

  void addOrder(OrderDetailsVM order) {
    orders.add(order);
  }

  void updateOrder(int index, OrderDetailsVM updatedOrder) {
    orders[index] = updatedOrder;
  }

  void deleteOrder(int index) {
    orders.removeAt(index);
  }
}
