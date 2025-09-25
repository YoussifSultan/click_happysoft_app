import 'package:click_happysoft_app/routing/app_routes.dart';
import 'package:click_happysoft_app/constants/common_constants.dart';
import 'package:click_happysoft_app/constants/scaffolds/primary_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  Future<Map<String, String>> getSalesmanData() async {
    final prefs = await SharedPreferences.getInstance();

    // Get saved values
    String email = prefs.getString('salesman_email')!;
    String name = prefs.getString('salesman_name')!;
    return {'email': email, 'name': name};
  }

  final List<Map<String, dynamic>> menuItems = [
    {
      'icon': Icons.person,
      'title': 'Customer',
      'children': [
        {
          'icon': Icons.add_circle_outline,
          'title': 'Add new Customer',
          'onTap': () async {
            Get.toNamed(AppRoutes.addnewCustomer);
          },
        },
      ],
    },
    {
      'icon': Icons.shopping_basket_outlined,
      'title': 'Orders',
      'children': [
        {
          'icon': Icons.add_circle_outline,
          'title': 'Add new Order',
          'onTap': () async {
            Get.toNamed(AppRoutes.addNewOrder);
          },
        },
        {
          'icon': Icons.list_alt,
          'title': 'View Orders',
          'onTap': () async {
            Get.toNamed(AppRoutes.orders);
          },
        },
      ],
    },
    {
      'icon': Icons.receipt_long,
      'title': 'Reciept Voucher Request',
      'children': [
        {
          'icon': Icons.add_chart_sharp,
          'title': 'Add new Cash RV Request',
          'onTap': () async {
            Get.toNamed(AppRoutes.addnewReceiptVoucherRequest);
          },
        },
      ],
    },
    {
      'icon': Icons.logout,
      'title': 'Log out',
      'onTap': () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('is_logged_in');
        await prefs.remove('salesman_email');
        await prefs.remove('salesman_id');
        await prefs.remove('salesman_name');
        Get.offAndToNamed(AppRoutes.login);
      },
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
        body: Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with profile
            FutureBuilder(
              future: getSalesmanData(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/logo_arabic.png'),
                  ),
                  title: Text(snapshot.data['name'] ?? 'Salesman Name',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      snapshot.data['email'] ?? 'example@example.com',
                      style: const TextStyle(color: Colors.grey)),
                  trailing: const Icon(Icons.chevron_right),
                );
              },
            ),

            const Divider(),
            // Menu Items
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];

                // If item has children → make expandable
                if (item.containsKey('children')) {
                  return ExpansionTile(
                    leading: Icon(item['icon'], color: AppColors.black),
                    title: Text(item['title']),
                    children: (item['children'] as List<Map<String, dynamic>>)
                        .map((child) => ListTile(
                              leading:
                                  Icon(child['icon'], color: AppColors.black),
                              title: Text(child['title']),
                              onTap: child['onTap'],
                            ))
                        .toList(),
                  );
                }

                // Normal non-expandable item
                return ListTile(
                  leading: Icon(item['icon'], color: AppColors.black),
                  title: Text(item['title']),
                  onTap: () {
                    item['onTap'] != null
                        ? item['onTap']()
                        : Get.snackbar('Info', 'Processing');
                  },
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
    ));
  }
}
