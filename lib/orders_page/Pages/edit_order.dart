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
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditOrdersPage extends StatefulWidget {
  const EditOrdersPage({super.key});

  @override
  State<EditOrdersPage> createState() => _EditOrdersPageState();
}

class _EditOrdersPageState extends State<EditOrdersPage> {
  final _formKey =
      GlobalKey<FormState>(); // Needed to access and validate the form
  CustomerVM selectedCustomer = CustomerVM(id: 0, name: '');
  Product selectedProduct = Product(id: 0, name: '');
  late OrderDetailsVM selectedOrder;
  List<CustomerVM> customersList = [];
  List<Product> productsList = [];
  DateTime date = DateTime.now();
  int qty = 1; // Default quantity

  Future<void> initializeCustomer() async {
    customersList = await OrderSqlManager.fetchAllCustomers();
  }

  Future<void> initializeProducts() async {
    productsList = await OrderSqlManager.fetchAllProducts();
  }

  @override
  void initState() {
    final Map<String, dynamic> args = Get.arguments;
    selectedOrder = OrderDetailsVM.fromJson(args);
    selectedCustomer = CustomerVM(
        id: selectedOrder.customerId, name: selectedOrder.customerName);
    selectedProduct =
        Product(id: selectedOrder.productId, name: selectedOrder.productName);
    super.initState();
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
                customTextInputAction: TextInputAction.done,
                defaultText: selectedOrder.qty.toString(),
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
                initialDate: selectedOrder.date,
                lastDate: DateTime.now(),
                onSaved: (value) {
                  date = value;
                },
              ),
              AppSpacing.v16,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      text: 'Edit',
                      color: AppColors.primary,
                      icon: Icons.check,
                      onPressed: () {
                        editOrder();
                      }),
                  AppSpacing.h16,
                  CustomButton(
                      text: 'Delete',
                      color: Colors.redAccent,
                      icon: Icons.delete,
                      onPressed: () {
                        deleteOrder();
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> editOrder() async {
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
        id: selectedOrder.id, // Assuming ID is auto-generated
      );
      int responseCode = await OrderSqlManager.editOrder(newOrder);

      if (responseCode == 200) {
        Get.back(); // Navigate back to homepage
        Get.snackbar(
          'Edited Successfully',
          'The order is edited successfully',
        );
      } else {
        Get.back();
        Get.snackbar(
          '$responseCode',
          'Please try again later',
        );
      }
    }
  }

  Future<void> deleteOrder() async {
    if (_formKey.currentState!.validate()) {
      int responseCode = await OrderSqlManager.deleteOrder(selectedOrder.id);
      if (responseCode == 200) {
        Get.back(); // Navigate back to homepage
        Get.snackbar(
          'Deleted Successfully',
          'The order is deleted successfully',
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
