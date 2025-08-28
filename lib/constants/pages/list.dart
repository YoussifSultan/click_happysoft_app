import 'package:click_happysoft_app/constants/common_constants.dart';
import 'package:click_happysoft_app/constants/scaffolds/secondary_scaffold.dart';
import 'package:flutter/material.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage(
      {super.key, required this.dataName, required this.listItems});
  final String dataName;
  final List<ListItem> listItems;

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryScaffold(
        body: ListView.builder(
            itemCount: widget.listItems.length,
            itemBuilder: (context, index) {
              final item = widget.listItems[index];
              return ListTile(
                title: Text(
                  item.title,
                  style: const TextStyle(color: AppColors.black, fontSize: 18),
                ),
                trailing: Text(
                  item.trailing,
                  style: const TextStyle(color: AppColors.gray, fontSize: 13),
                ),
                subtitle: Text(
                  item.subtitle,
                  style:
                      const TextStyle(color: AppColors.primary, fontSize: 13),
                ),
                onTap: () {
                  item.onTap();
                },
              );
            }));
  }
}

class ListItem {
  final String title;
  final String subtitle;
  final String trailing;
  final Function onTap;

  ListItem(
      {required this.title,
      required this.subtitle,
      required this.trailing,
      required this.onTap});
}
