import 'package:click_happysoft_app/orders_page/Pages/addneworder.dart';
import 'package:click_happysoft_app/orders_page/Pages/edit_order.dart';
import 'package:click_happysoft_app/orders_page/Pages/orders.dart';
import 'package:click_happysoft_app/routing/main_menu.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const addNewOrder = '/orders/add/';

  ///NOTE - Requires Map of Order as arguments in GETx routing
  ///
  /// Example: Get.toNamed(AppRoutes.editOrder, arguments: item.toMap());
  static const editOrder = '/orders/edit';
  static const orders = '/orders/';
  static const mainmenu = '/menu/';

  static final pages = [
    GetPage(
        name: addNewOrder,
        transition: Transition.fadeIn,
        page: () => const AddNewOrderPage()),
    GetPage(
        name: mainmenu,
        transition: Transition.fadeIn,
        page: () => const MainMenuPage()),
    GetPage(
        name: orders,
        transition: Transition.fadeIn,
        page: () => const OrdersPage()),
    GetPage(
      name: editOrder,
      transition: Transition.fadeIn,
      page: () => const EditOrdersPage(),
    ),
  ];
}
