import 'package:click_happysoft_app/orders_page/classes/customer_class.dart';
import 'package:click_happysoft_app/orders_page/classes/product_class.dart';
import 'package:click_happysoft_app/orders_page/order_sql_manager.dart';
import 'package:click_happysoft_app/ui_commonwidgets/common_constants.dart';
import 'package:click_happysoft_app/ui_commonwidgets/form_widgets.dart';
import 'package:click_happysoft_app/ui_commonwidgets/secondary_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  List<Customer> customersList = [];
  List<Product> productsList = [];

  @override
  void initState() {
    initializeCustomerAndProduct();
    super.initState();
  }

  Future<void> initializeCustomerAndProduct() async {
    customersList = await OrderSqlManager.fetchAllCustomers();
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
              CustomCombobox(
                dataList: customersList,
                selectedData: selectedCustomer,
                icon: Icons.person,
                label: 'Customer Name',
                helperText: 'Choose Customer',
              ),
              Obx(
                () {
                  return CustomTextBox(
                    label: 'Customer ID',
                    helperText: 'Customer ID',
                    readonly: true,
                    defaultText: '${selectedCustomer.value.id}',
                    icon: Icons.person,
                  );
                },
              ),
              CustomCombobox(
                dataList: productsList,
                icon: Icons.category,
                selectedData: selectedProduct,
                label: 'Product Name',
                helperText: 'Choose Product',
              ),
              Obx(
                () => CustomTextBox(
                  label: 'Product ID',
                  helperText: 'Product ID',
                  defaultText: '${selectedProduct.value.id}',
                  icon: Icons.category,
                  readonly: true,
                ),
              ),
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
              ),
              AppSpacing.v16,
              CustomButton(
                  text: 'Save',
                  color: AppColors.primary,
                  icon: Icons.check,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Get.showSnackbar(const GetSnackBar(
                        title: 'Submitted',
                        message: 'The order is saved successfully',
                      ));
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
