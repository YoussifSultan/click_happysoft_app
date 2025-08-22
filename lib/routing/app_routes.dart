import 'package:click_happysoft_app/customer_page/Pages/addnewcustomer.dart';
import 'package:click_happysoft_app/dashboard_page/Pages/dashboard.dart';
import 'package:click_happysoft_app/login_page/login_page.dart';
import 'package:click_happysoft_app/orders_page/Pages/addneworder.dart';
import 'package:click_happysoft_app/orders_page/Pages/edit_order.dart';
import 'package:click_happysoft_app/orders_page/Pages/orders.dart';
import 'package:click_happysoft_app/routing/main_menu.dart';
import 'package:click_happysoft_app/routing/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const addNewOrder = '/orders/add/';

  ///NOTE - Requires Map of Order as arguments in GETx routing
  ///
  /// Example: Get.toNamed(AppRoutes.editOrder, arguments: item.toMap());
  static const editOrder = '/orders/edit';
  static const orders = '/orders/';
  static const addnewCustomer = '/customer/add/';

  static const mainmenu = '/menu/';
  static const dashboard = '/dashboard/';
  static const login = '/login/';
  static const splashScreen = '/splash/';

  static final pages = [
    GetPage(
        name: mainmenu,
        transition: Transition.fadeIn,
        page: () => const MainMenuPage()),
    GetPage(
        name: addnewCustomer,
        transition: Transition.fadeIn,
        page: () => const AddnewCustomerPage()),
    GetPage(
        name: addNewOrder,
        transition: Transition.fadeIn,
        page: () => const AddNewOrderPage()),
    GetPage(
        name: orders,
        transition: Transition.fadeIn,
        page: () => const OrdersPage()),
    GetPage(
        name: editOrder,
        transition: Transition.fadeIn,
        page: () => const EditOrdersPage()),
    GetPage(
        name: login,
        transition: Transition.fadeIn,
        page: () => const LoginPage()),
    GetPage(
      name: splashScreen,
      transition: Transition.fadeIn,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: dashboard,
      transition: Transition.fadeIn,
      page: () => const Dashboard(),
    ),
  ];

  /// Returns the current route name based on the current route.
  static String getCurrentRouteName() {
    final currentRoute = Get.currentRoute;
    return currentRoute.isNotEmpty
        ? currentRoute
            .replaceFirst('/', '')
            .replaceAll('/', "-")
            .capitalize! // Capitalize first letter
        : 'Dashboard'; // Default to 'Home' if no route is found
  }
}
