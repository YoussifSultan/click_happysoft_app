import 'package:click_happysoft_app/RVrequest_page/Classes/currency.dart';
import 'package:click_happysoft_app/RVrequest_page/Classes/paymentmethods.dart';
import 'package:click_happysoft_app/RVrequest_page/Classes/requestvoucher.dart';
import 'package:click_happysoft_app/RVrequest_page/RV_sqlmanager.dart';
import 'package:click_happysoft_app/constants/common_constants.dart';
import 'package:click_happysoft_app/constants/scaffolds/secondary_scaffold.dart';
import 'package:click_happysoft_app/constants/ui_constants/combobox.dart';
import 'package:click_happysoft_app/constants/ui_constants/form_widgets.dart';
import 'package:click_happysoft_app/orders_page/Viewmodels/customerVM.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Addnewrvrequest extends StatefulWidget {
  const Addnewrvrequest({super.key});

  @override
  State<Addnewrvrequest> createState() => _AddnewrvrequestState();
}

class _AddnewrvrequestState extends State<Addnewrvrequest> {
  String voucherNo = '';
  DateTime dateOfReceipt = DateTime.now();
  String referenceNo = '';
  double amount = 0.0;
  String notes = '';
  CustomerVM selectedCustomer = CustomerVM(id: 0, name: '');
  final _formKey =
      GlobalKey<FormState>(); // Needed to access and validate the form
  List<CustomerVM> customersList = [];
  PaymentMethod selectedPaymentMethod = PaymentMethod.cash; // Default selection
  Currency selectedCurrency = Currency.egp; // Default selection
  Future<void> initializeCustomers() async {
    customersList = await RvSqlmanager.fetchAllCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryScaffold(
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppSpacing.v16,
                  CustomTextBox(
                    label: 'Voucher No',
                    helperText: 'Enter Voucher No',
                    icon: Icons.numbers,
                    onSaved: (value) {
                      voucherNo = value!;
                    },
                  ),
                  FutureBuilder(
                      future: initializeCustomers(),
                      builder: (context, snapshot) {
                        return CustomCombobox(
                          dataList: customersList
                              .map((customer) => CustomComboboxitem(
                                  title: customer.name, id: customer.id))
                              .toList(),
                          text: selectedCustomer.name,
                          onSelected: (customer) {
                            selectedCustomer = CustomerVM(
                                id: customer.id, name: customer.title);
                          },
                          icon: Icons.person,
                          label: 'Customer Name',
                          helperText: 'Choose Customer',
                        );
                      }),
                  CustomCombobox(
                      dataList: PaymentMethod.methods
                          .map((paymentMethod) => CustomComboboxitem(
                              title: paymentMethod.paymentMethod,
                              id: paymentMethod.id))
                          .toList(),
                      label: 'Payment Method',
                      text: selectedPaymentMethod.paymentMethod,
                      icon: Icons.card_membership,
                      helperText: 'Choose Payment Method',
                      onSelected: (value) {
                        selectedPaymentMethod = PaymentMethod.methods
                            .firstWhere((c) => c.id == value.id);
                      }),
                  DatepickerBox(
                    initialDate: dateOfReceipt,
                    lastDate: DateTime.now(),
                    label: "Date",
                    onSaved: (newValue) {
                      dateOfReceipt = newValue!;
                    },
                  ),
                  CustomTextBox(
                    label: 'Refernce No',
                    helperText: 'Enter Reference No',
                    icon: Icons.numbers,
                    onSaved: (value) {
                      referenceNo = value!;
                    },
                  ),
                  CustomTextBox(
                    label: 'Amount',
                    helperText: 'Enter Amount',
                    keyboardType: TextInputType.number,
                    icon: Icons.attach_money_sharp,
                    onSaved: (value) {
                      amount = value!;
                    },
                  ),
                  CustomCombobox(
                      dataList: Currency.currencies
                          .map((currency) => CustomComboboxitem(
                              title: currency.name, id: currency.id))
                          .toList(),
                      label: 'Currency',
                      text: selectedCurrency.name,
                      icon: Icons.currency_pound_outlined,
                      helperText: 'Choose Currency',
                      onSelected: (value) {
                        selectedCurrency = Currency.currencies
                            .firstWhere((c) => c.id == value.id);
                      }),
                  CustomTextBox(
                      label: "Notes",
                      helperText: 'Enter Notes',
                      icon: Icons.note_add_sharp,
                      keyboardType: TextInputType.multiline,
                      isMultiline: true,
                      onSaved: (value) {
                        notes = value!;
                      }),
                  AppSpacing.v24,
                  CustomButton(
                      text: 'Save',
                      color: Colors.greenAccent,
                      icon: Icons.check,
                      onPressed: () {})
                ],
              ),
            )));
  }

  Future<void> saveNewRVRequest() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final prefs = await SharedPreferences.getInstance();
      int salesmanID = prefs.getInt('salesman_id')!;
      ReceiptVoucher newRVRequest = ReceiptVoucher(
        voucherId: 0,
        voucherNo: voucherNo,
        salesmanId: salesmanID,
        customerId: selectedCustomer.id,
        paymentMethod: selectedPaymentMethod.id,
        voucherDate: dateOfReceipt,
        referenceNo: referenceNo,
        amount: amount,
        currency: selectedCurrency.name,
        description: notes,
        approvalStatus: 0, // Default to pending approval
        createdAt: DateTime.now(),
      );
      http.Response response = await RvSqlmanager.addnewRVrequest(newRVRequest);
      int responseCode = response.statusCode;
      if (responseCode == 200) {
        Get.back(); // Navigate back to homepage
        Get.snackbar(
          'Saved Successfully',
          'The RV Request is saved successfully',
        );
      } else {
        Get.back(); // Navigate back to homepage
        Get.snackbar(
          '$responseCode',
          response.body,
        );
      }
    }
  }
}
