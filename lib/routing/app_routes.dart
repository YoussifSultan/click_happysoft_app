import 'package:click_happysoft_app/RVrequest_page/addnewRVrequest.dart';
import 'package:click_happysoft_app/constants/pages/list.dart';
import 'package:click_happysoft_app/customer_page/Pages/addnewcustomer.dart';
import 'package:click_happysoft_app/customer_page/Pages/customers.dart';
import 'package:click_happysoft_app/dashboard_page/Pages/dashboard.dart';
import 'package:click_happysoft_app/login_page/login_page.dart';
import 'package:click_happysoft_app/orders_page/Pages/addneworder.dart';
import 'package:click_happysoft_app/orders_page/Pages/edit_order.dart';
import 'package:click_happysoft_app/orders_page/Pages/orders.dart';
import 'package:click_happysoft_app/routing/main_menu.dart';
import 'package:click_happysoft_app/routing/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String addNewOrder = '/orders/add/';

  ///NOTE - Requires Map of Order as arguments in GETx routing
  ///
  /// Example: Get.toNamed(AppRoutes.editOrder, arguments: item.toMap());
  static const String editOrder = '/orders/edit';
  static const String orders = '/orders/';

  static const String addnewCustomer = '/customer/add/';
  static const String customers = '/customer/';

  static const String addnewReceiptVoucherRequest =
      '/receiptvoucherrequest/add/';
  static const String rvReceipts = '/receiptvoucherrequest/';

  static const String mainmenu = '/menu/';
  static const String dashboard = '/dashboard/';
  static const String login = '/login/';
  static const String splashScreen = '/splash/';

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
        name: customers,
        transition: Transition.fadeIn,
        page: () => const CustomersPage()),
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
    GetPage(
      name: addnewReceiptVoucherRequest,
      transition: Transition.fadeIn,
      page: () => const Addnewrvrequest(),
    ),
    GetPage(
        name: rvReceipts,
        transition: Transition.fadeIn,
        page: () => const Dashboard()),
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
