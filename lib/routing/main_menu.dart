import 'package:click_happysoft_app/ui_commonwidgets/primary_scaffold.dart';
import 'package:flutter/material.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  @override
  Widget build(BuildContext context) {
    return const PrimaryScaffold(body: Placeholder());
  }
}
