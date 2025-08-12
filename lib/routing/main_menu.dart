import 'package:click_happysoft_app/routing/app_routes.dart';
import 'package:click_happysoft_app/ui_commonwidgets/common_constants.dart';
import 'package:click_happysoft_app/ui_commonwidgets/primary_scaffold.dart';
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
    {
      'icon': Icons.add_circle_outline,
      'title': 'Add new Customer',
      'onTap': () async {
        Get.toNamed(AppRoutes.addnewCustomer);
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
                        AssetImage('assets/images/ahmed_khalil.jpg'),
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
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                if (item.isEmpty) {
                  return Divider(color: Colors.grey[700]);
                }
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
