import 'dart:convert';

import 'package:click_happysoft_app/orders_page/Pages/orders.dart';
import 'package:click_happysoft_app/orders_page/Viewmodels/customerVM.dart';
import 'package:click_happysoft_app/orders_page/Viewmodels/ordersfulldata.dart';
import 'package:click_happysoft_app/orders_page/classes/orders_class.dart';
import 'package:click_happysoft_app/orders_page/classes/product_class.dart';
import 'package:click_happysoft_app/orders_page/order_sql_manager.dart';
import 'package:click_happysoft_app/constants/common_constants.dart';
import 'package:click_happysoft_app/constants/ui_constants/form_widgets.dart';
import 'package:click_happysoft_app/constants/ui_constants/combobox.dart';
import 'package:click_happysoft_app/constants/scaffolds/secondary_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewOrderPage extends StatefulWidget {
  const AddNewOrderPage({super.key});

  @override
  State<AddNewOrderPage> createState() => _AddNewOrderPageState();
}

class _AddNewOrderPageState extends State<AddNewOrderPage> {
  final _formKey =
      GlobalKey<FormState>(); // Needed to access and validate the form
  CustomerVM selectedCustomer = CustomerVM(id: 0, name: '');
  Product selectedProduct = Product(id: 0, name: '');
  DateTime date = DateTime.now();
  int qty = 1; // Default quantity

  List<CustomerVM> customersList = [];
  List<Product> productsList = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> initializeCustomers() async {
    customersList = await OrderSqlManager.fetchAllCustomers();
  }

  Future<void> initializeProducts() async {
    productsList = await OrderSqlManager.fetchAllProducts();
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
                        selectedCustomer =
                            CustomerVM(id: customer.id, name: customer.title);
                      },
                      icon: Icons.person,
                      label: 'Customer Name',
                      helperText: 'Choose Customer',
                    );
                  }),
              FutureBuilder(
                  future: initializeProducts(),
                  builder: (context, snapshot) {
                    return CustomCombobox(
                      dataList: productsList
                          .map((product) => CustomComboboxitem(
                              title: product.name, id: product.id))
                          .toList(),
                      icon: Icons.category,
                      text: selectedProduct.name,
                      onSelected: (product) {
                        selectedProduct =
                            Product(id: product.id, name: product.title);
                      },
                      label: 'Product Name',
                      helperText: 'Choose Product',
                    );
                  }),
              CustomTextBox(
                label: 'Quantity',
                helperText: 'Enter Quantity',
                defaultText: '1',
                customTextInputAction: TextInputAction.done,
                icon: Icons.numbers,
                validator: (value) {
                  if (GetUtils.isNullOrBlank(value)!) {
                    return 'Quantity is required';
                  } else if (!GetUtils.isNumericOnly(value)) {
                    return 'Enter valid Quantity';
                  }
                  return null;
                },
                onSaved: (value) {
                  qty = int.parse(value);
                },
              ),
              DatepickerBox(
                label: 'Select Order Date',
                initialDate: DateTime.now(),
                lastDate: DateTime.now(),
                onSaved: (value) {
                  date = value;
                },
              ),
              AppSpacing.v16,
              CustomButton(
                  text: 'Save',
                  color: AppColors.primary,
                  icon: Icons.check,
                  onPressed: () async {
                    await saveNewOrder();
                  })
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveNewOrder() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      int salesmanID = prefs.getInt('salesman_id')!;
      _formKey.currentState!.save();
      Order newOrder = Order(
        productId: selectedProduct.id,
        customerId: selectedCustomer.id,
        salesmanId: salesmanID,
        qty: qty,
        date: date,
        id: 0, // Assuming ID is auto-generated
      );
      http.Response response = await OrderSqlManager.addnewOrder(newOrder);
      int responseCode = response.statusCode;
      if (responseCode == 200) {
        Get.back(); // Navigate back to homepage
        Get.snackbar(
          'Saved Successfully',
          'The order is saved successfully',
        );
      } else {
        Get.back(); // Navigate back to homepage
        Get.snackbar(
          '$responseCode',
          'Please try again later',
        );
      }
    }
  }
}
