import 'package:click_happysoft_app/RVrequest_page/Classes/paymentmethods.dart';
import 'package:click_happysoft_app/RVrequest_page/RV_sqlmanager.dart';
import 'package:click_happysoft_app/RVrequest_page/Viewmodels/rv_requests_listItem.dart';
import 'package:click_happysoft_app/constants/pages/list.dart';
import 'package:click_happysoft_app/constants/scaffolds/secondary_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RvRequestsPage extends StatefulWidget {
  const RvRequestsPage({super.key});

  @override
  State<RvRequestsPage> createState() => _RvRequestsPageState();
}

class _RvRequestsPageState extends State<RvRequestsPage> {
  List<RVListItem> rvRequests = [];
  late PaymentMethod selectedPaymentMethod;
  @override
  void initState() {
    selectedPaymentMethod = Get.arguments;
    super.initState();
  }

  Future<void> fetchRVRequests() async {
    final prefs = await SharedPreferences.getInstance();
    int salesmanID = prefs.getInt('salesman_id')!;
    if (selectedPaymentMethod == PaymentMethod.cheque) {
      rvRequests = await RvSqlmanager.fetchAllRVRequests(
          salesmanID, PaymentMethod.cheque);
    } else {
      rvRequests =
          await RvSqlmanager.fetchAllRVRequests(salesmanID, PaymentMethod.cash);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchRVRequests(),
        builder: (context, _) {
          if (rvRequests.isEmpty) {
            return const SecondaryScaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return ListViewPage(
              dataName: "Orders",
              listItems: rvRequests.map((rv) {
                return ListItem(
                    title: "${rv.amount} ${rv.currency}",
                    subtitle:
                        "${rv.description} - ${DateFormat('dd/MM/yyyy').format(rv.voucherDate)}",
                    trailing: rv.customerName,
                    isGood: rv.isDeposited,
                    onTap: () {});
              }).toList());
        });
  }
}
