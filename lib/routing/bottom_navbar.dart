import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:click_happysoft_app/routing/app_routes.dart';
import 'package:click_happysoft_app/ui_commonwidgets/common_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavbar extends StatelessWidget {
  BottomNavbar({super.key});

  final NavController navController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedBottomNavigationBar(
          icons: const [
            Icons.document_scanner,
            Icons.menu,
          ],
          activeIndex: navController.selectedIndex.value,
          activeColor: AppColors.primary,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          onTap: (index) {
            navController.changePage(index);
          }),
    );
  }
}

class NavController extends GetxController {
  var selectedIndex = 0.obs;

  final List<String> pages = [AppRoutes.orders, AppRoutes.mainmenu];

  void changePage(int index) {
    selectedIndex.value = index;
    Get.offAndToNamed(pages[index]); // Replace navigation
  }
}
