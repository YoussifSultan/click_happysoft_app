import 'package:click_happysoft_app/orders_page/Viewmodels/ordersfulldata.dart';
import 'package:click_happysoft_app/orders_page/order_sql_manager.dart';
import 'package:click_happysoft_app/routing/app_routes.dart';
import 'package:click_happysoft_app/ui_commonwidgets/common_constants.dart';
import 'package:click_happysoft_app/ui_commonwidgets/primary_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
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
          child: Text(
            'No orders found',
            style: TextStyle(color: AppColors.gray, fontSize: 18),
          ),
        );
      }
      return ListView(
        children: [
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return ListTile(
                    title: Text(
                      order.customerName,
                      style:
                          const TextStyle(color: AppColors.black, fontSize: 18),
                    ),
                    trailing: Text(
                      DateFormat('dd/MM/yyyy').format(order.date),
                      style:
                          const TextStyle(color: AppColors.gray, fontSize: 13),
                    ),
                    subtitle: Text(
                      "${order.productName} - ${order.qty}",
                      style: const TextStyle(
                          color: AppColors.primary, fontSize: 13),
                    ),
                    onTap: () {
                      Get.toNamed(AppRoutes.editOrder,
                          arguments: order.toMap());
                    },
                  );
                }),
          ),
          const Divider(),
          Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.count(
                crossAxisCount: 2, // 2 tiles per row
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(4, (index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    child: Container(
                      height: 200, // Greater height
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Optional background color
                      ),
                      child: Image.asset(
                        'assets/products/product${index + 1}.png', // Replace with your image
                        fit: BoxFit.cover, // Cover entire container
                      ),
                    ),
                  );
                }),
              ))
        ],
      );
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
