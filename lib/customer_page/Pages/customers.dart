import 'package:click_happysoft_app/constants/pages/list.dart';
import 'package:click_happysoft_app/constants/scaffolds/secondary_scaffold.dart';
import 'package:click_happysoft_app/customer_page/Viewmodels/customerListItem.dart';
import 'package:click_happysoft_app/customer_page/customer_sql_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  List<CustomerListItem> customers = [];
  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchAllCustomers() async {
    customers = await CustomerSqlManager.fetchAllCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchAllCustomers(),
        builder: (context, _) {
          if (customers.isEmpty) {
            return const SecondaryScaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return ListViewPage(
              dataName: "Customers",
              listItems: customers.map((customer) {
                return ListItem(
                    title: customer.name,
                    subtitle: customer.mobile,
                    trailing: customer.customerType.customerType,
                    onTap: () {});
              }).toList());
        });
  }
}
