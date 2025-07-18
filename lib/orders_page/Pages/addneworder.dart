import 'dart:convert';

import 'package:click_happysoft_app/orders_page/Pages/orders.dart';
import 'package:click_happysoft_app/orders_page/Viewmodels/ordersfulldata.dart';
import 'package:click_happysoft_app/orders_page/classes/customer_class.dart';
import 'package:click_happysoft_app/orders_page/classes/orders_class.dart';
import 'package:click_happysoft_app/orders_page/classes/product_class.dart';
import 'package:click_happysoft_app/orders_page/order_sql_manager.dart';
import 'package:click_happysoft_app/ui_commonwidgets/common_constants.dart';
import 'package:click_happysoft_app/ui_commonwidgets/form_widgets.dart';
import 'package:click_happysoft_app/ui_commonwidgets/secondary_scaffold.dart';
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
  Rx<Customer> selectedCustomer = Customer(id: 0, name: '').obs;
  Rx<Product> selectedProduct = Product(id: 0, name: '').obs;
  DateTime date = DateTime.now();
  int qty = 1; // Default quantity

  List<Customer> customersList = [];
  List<Product> productsList = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> initializeCustomer() async {
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
                  future: initializeCustomer(),
                  builder: (context, snapshot) {
                    return Obx(
                      () => CustomCombobox(
                        dataList: customersList,
                        text: selectedCustomer.value.name,
                        onSelected: (customer) {
                          selectedCustomer.value = customer;
                        },
                        suffixText: 'ID: ${selectedCustomer.value.id}',
                        icon: Icons.person,
                        label: 'Customer Name',
                        helperText: 'Choose Customer',
                      ),
                    );
                  }),
              FutureBuilder(
                  future: initializeProducts(),
                  builder: (context, snapshot) {
                    return Obx(
                      () => CustomCombobox(
                        dataList: productsList,
                        icon: Icons.category,
                        suffixText: 'ID: ${selectedProduct.value.id}',
                        text: selectedProduct.value.name,
                        onSelected: (product) {
                          selectedProduct.value = product;
                        },
                        label: 'Product Name',
                        helperText: 'Choose Product',
                      ),
                    );
                  }),
              CustomTextBox(
                label: 'Quantity',
                helperText: 'Enter Quantity',
                defaultText: '1',
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
        productId: selectedProduct.value.id,
        customerId: selectedCustomer.value.id,
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
        final orderListController = Get.find<OrdersListController>();
        orderListController.orders.add(OrderDetailsVM(
            customerId: selectedCustomer.value.id,
            customerName: selectedCustomer.value.name,
            productId: selectedProduct.value.id,
            productName: selectedProduct.value.name,
            qty: qty,
            date: date,
            id: jsonDecode(response.body)['last_insert_id'],
            salesmanId: salesmanID));
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
