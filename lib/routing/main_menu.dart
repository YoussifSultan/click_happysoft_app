import 'package:click_happysoft_app/routing/app_routes.dart';
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
  final List<Map<String, dynamic>> menuItems = [
    {
      'icon': Icons.logout,
      'title': 'Log out',
      'onTap': () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('is_logged_in');
        Get.offAndToNamed(AppRoutes.login);
      }
    },
    {'icon': Icons.settings, 'title': 'Settings'},
    {'icon': Icons.add_circle_outline, 'title': 'Add account'}
  ];
  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
        body: Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header with profile
            const ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://www.w3schools.com/howto/img_avatar.png'),
              ),
              title: Text('Sarbasis Basu'),
              subtitle: Text('@sarbasisbasu5277',
                  style: TextStyle(color: Colors.grey)),
              trailing: Icon(Icons.chevron_right),
            ),

            const Divider(),
            // Menu Items
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  if (item.isEmpty) {
                    return Divider(color: Colors.grey[700]);
                  }
                  return ListTile(
                    leading: Icon(item['icon'], color: Colors.white),
                    title: Text(item['title']),
                    onTap: () {
                      item['onTap']();
                    },
                  );
                },
              ),
            ),

            const Divider(),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Privacy Policy', style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 10),
                  Text('|', style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 10),
                  Text('Terms of Service',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
