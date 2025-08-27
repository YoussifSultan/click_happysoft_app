import 'package:click_happysoft_app/constants/scaffolds/secondary_scaffold.dart';
import 'package:click_happysoft_app/orders_page/Viewmodels/ordersfulldata.dart';
import 'package:click_happysoft_app/orders_page/order_sql_manager.dart';
import 'package:click_happysoft_app/routing/app_routes.dart';
import 'package:click_happysoft_app/constants/common_constants.dart';
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
  @override
  void initState() {
    super.initState();
  }

  Future<List<OrderDetailsVM>> fetchOrdersOfSalesman() async {
    final prefs = await SharedPreferences.getInstance();
    int salesmanID = prefs.getInt('salesman_id')!;
    List<OrderDetailsVM> orders =
        await OrderSqlManager.fetchAllOrders(salesmanID);
    print(orders.length);
    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryScaffold(
        body: FutureBuilder(
            future: fetchOrdersOfSalesman(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: Text(
                    'No orders found',
                    style: TextStyle(color: AppColors.gray, fontSize: 18),
                  ),
                );
              }
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final order = snapshot.data![index];
                    return ListTile(
                      title: Text(
                        order.customerName,
                        style: const TextStyle(
                            color: AppColors.black, fontSize: 18),
                      ),
                      trailing: Text(
                        DateFormat('dd/MM/yyyy').format(order.date),
                        style: const TextStyle(
                            color: AppColors.gray, fontSize: 13),
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
                  });
            }));
  }
}
