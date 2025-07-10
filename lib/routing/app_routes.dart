import 'package:click_happysoft_app/orders_page/addneworder.dart';
import 'package:click_happysoft_app/orders_page/orders.dart';
import 'package:click_happysoft_app/routing/main_menu.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const addNewOrder = '/orders/add/';
  static const orders = '/orders/';
  static const mainmenu = '/menu/';

  static final pages = [
    GetPage(
        name: addNewOrder,
        transition: Transition.fadeIn,
        page: () => const AddNewOrderScreen()),
    GetPage(
        name: mainmenu,
        transition: Transition.fadeIn,
        page: () => const MainMenuScreen()),
    GetPage(
        name: orders,
        transition: Transition.fadeIn,
        page: () => const OrdersScreen()),
  ];
}
