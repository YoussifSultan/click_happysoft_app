import 'package:click_happysoft_app/orders_page/Viewmodels/ordersfulldata.dart';
import 'package:click_happysoft_app/orders_page/classes/customer_class.dart';
import 'package:click_happysoft_app/orders_page/classes/orders_class.dart';
import 'package:click_happysoft_app/orders_page/classes/product_class.dart';
import 'package:click_happysoft_app/orders_page/order_sql_manager.dart';
import 'package:click_happysoft_app/ui_commonwidgets/common_constants.dart';
import 'package:click_happysoft_app/ui_commonwidgets/form_widgets.dart';
import 'package:click_happysoft_app/ui_commonwidgets/secondary_scaffold.dart';
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
  late Rx<Customer> selectedCustomer;
  late Rx<Product> selectedProduct;
  late OrderDetailsVM selectedOrder;
  List<Customer> customersList = [];
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
    selectedCustomer =
        Customer(id: selectedOrder.customerId, name: selectedOrder.customerName)
            .obs;
    selectedProduct =
        Product(id: selectedOrder.productId, name: selectedOrder.productName)
            .obs;
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
                    return Obx(
                      () => CustomCombobox(
                        dataList: customersList,
                        selectedData: selectedCustomer,
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
                        selectedData: selectedProduct,
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
                    await editOrder();
                  })
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
        productId: selectedProduct.value.id,
        customerId: selectedCustomer.value.id,
        salesmanId: salesmanID,
        qty: qty,
        date: date,
        id: selectedOrder.id, // Assuming ID is auto-generated
      );
      int responseCode = await OrderSqlManager.editOrder(newOrder);
      if (responseCode == 200) {
        Get.snackbar(
          'Edited Successfully',
          'The order is edited successfully',
        );
      } else {
        Get.snackbar(
          '$responseCode',
          'Please try again later',
        );
      }
    }
  }
}
