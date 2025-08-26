import 'package:click_happysoft_app/routing/app_routes.dart';
import 'package:click_happysoft_app/routing/bottom_navbar.dart';
import 'package:click_happysoft_app/constants/common_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class PrimaryScaffold extends StatelessWidget {
  const PrimaryScaffold({super.key, required this.body});
  final Widget body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.light,
        elevation: 0.5,
        title: Image.asset(
          "assets/images/company_logo.png",
          height: 200,
          width: 120,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.black),
            onPressed: () {},
          ),
          AppSpacing.h4
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavbar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        onPressed: () {
          Get.toNamed(AppRoutes.addNewOrder); // Navigate to add new order page
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
