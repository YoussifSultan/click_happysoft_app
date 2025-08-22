import 'package:click_happysoft_app/routing/app_routes.dart';
import 'package:click_happysoft_app/constants/common_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class SecondaryScaffold extends StatelessWidget {
  const SecondaryScaffold({super.key, required this.body});
  final Widget body;
  @override
  Widget build(BuildContext context) {
    // Debugging line to check current route name
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.light,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        titleSpacing: 8,
        title: Text(
          AppRoutes.getCurrentRouteName(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: body,
    );
  }
}
