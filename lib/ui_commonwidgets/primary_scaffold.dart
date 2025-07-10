import 'package:click_happysoft_app/routing/app_routes.dart';
import 'package:click_happysoft_app/routing/bottom_navbar.dart';
import 'package:click_happysoft_app/ui_commonwidgets/common_constants.dart';
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
        leading: const Padding(
            padding: EdgeInsets.only(left: 12.0), child: FlutterLogo()),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.black),
            onPressed: () {},
          ),
          AppSpacing.h4
        ],
      ),
      body: body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.addNewOrder);
        },
        backgroundColor: AppColors.light,
        foregroundColor: AppColors.primary,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        child: const Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
