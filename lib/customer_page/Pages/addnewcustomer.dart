import 'package:click_happysoft_app/customer_page/Classes/customer_class.dart';
import 'package:click_happysoft_app/customer_page/Classes/customer_type.dart';
import 'package:click_happysoft_app/customer_page/customer_sql_manager.dart';
import 'package:click_happysoft_app/ui_commonwidgets/common_constants.dart';
import 'package:click_happysoft_app/ui_commonwidgets/form_widgets.dart';
import 'package:click_happysoft_app/ui_commonwidgets/secondary_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddnewCustomerPage extends StatefulWidget {
  const AddnewCustomerPage({super.key});

  @override
  State<AddnewCustomerPage> createState() => _AddnewCustomerPageState();
}

class _AddnewCustomerPageState extends State<AddnewCustomerPage> {
  final _formKey =
      GlobalKey<FormState>(); // Needed to access and validate the form
  String englishName = '';
  String arabicName = '';
  String category = 'Customer';
  CustomerType customerType = CustomerType.company;
  String mobile = '';
  String phone = '';
  String faxNumber = '';
  String email = '';
  String website = '';
  String address = '';
  String shoppingAddress = '';
  String nationalIDNumber = '';

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
              label: 'Arabic Name',
              helperText: 'Enter Arabic Name',
              icon: Icons.person,
              validator: (value) {
                if (GetUtils.isNullOrBlank(value)!) {
                  return 'Arabic Name is required';
                }
                return null;
              },
              onSaved: (value) {
                arabicName = value!;
              },
            ),
            CustomTextBox(
              label: 'English Name',
              helperText: 'Enter English Name',
              icon: Icons.person,
              validator: (value) {
                return null;
              },
              onSaved: (value) {
                englishName = value!;
              },
            ),
            CustomCombobox(
                dataList: ['Customer'],
                label: 'Category',
                text: category,
                helperText: 'Choose Category',
                onSelected: (value) {
                  category = value;
                }),
            CustomCombobox(
                dataList: CustomerType.customerTypes,
                label: 'Customer Type',
                text: customerType.customerType,
                helperText: 'Choose Customer Type',
                onSelected: (value) {
                  customerType = value;
                }),
            CustomTextBox(
              label: 'Mobile',
              helperText: 'Enter Mobile Number',
              icon: Icons.phone_android,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (GetUtils.isNullOrBlank(value)!) {
                  return null;
                } else if (!GetUtils.isPhoneNumber(value!)) {
                  return 'Invalid Mobile Number';
                }
                return null;
              },
              onSaved: (value) {
                mobile = value!;
              },
            ),
            CustomTextBox(
              label: 'Phone',
              helperText: 'Enter Phone Number',
              icon: Icons.call,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (GetUtils.isNullOrBlank(value)!) {
                  return null;
                } else if (!GetUtils.isPhoneNumber(value!)) {
                  return 'Invalid Phone Number';
                }
                return null;
              },
              onSaved: (value) {
                phone = value!;
              },
            ),
            CustomTextBox(
              label: 'Fax Number',
              helperText: 'Enter Fax Number',
              icon: Icons.fax,
              keyboardType: TextInputType.phone,
              validator: (value) {
                return null;
              },
              onSaved: (value) {
                faxNumber = value!;
              },
            ),
            CustomTextBox(
              label: 'Email',
              helperText: 'Enter Email Address',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (GetUtils.isNullOrBlank(value)!) {
                  return null;
                } else if (!GetUtils.isEmail(value!)) {
                  return 'Invalid Email Address';
                }
                return null;
              },
              onSaved: (value) {
                email = value!;
              },
            ),
            CustomTextBox(
              label: 'Website',
              helperText: 'Enter Website URL',
              icon: Icons.web,
              keyboardType: TextInputType.url,
              validator: (value) {
                return null;
              },
              onSaved: (value) {
                website = value!;
              },
            ),
            CustomTextBox(
              label: 'Address',
              helperText: 'Enter Address',
              icon: Icons.location_on,
              isMultiline: true,
              validator: (value) {
                return null;
              },
              onSaved: (value) {
                address = value!;
              },
            ),
            CustomTextBox(
              label: 'Shopping Address',
              helperText: 'Enter Shopping Address',
              icon: Icons.shopping_cart,
              isMultiline: true,
              validator: (value) {
                return null;
              },
              onSaved: (value) {
                shoppingAddress = value!;
              },
            ),
            CustomTextBox(
              label: 'National ID Number',
              helperText: 'Enter National ID Number',
              icon: Icons.perm_identity,
              keyboardType: TextInputType.number,
              customTextInputAction: TextInputAction.done,
              validator: (value) {
                if (GetUtils.isNullOrBlank(value)!) {
                  return null;
                } else if (!GetUtils.isNumericOnly(value!)) {
                  return 'Invalid National ID Number';
                }
                return null;
              },
              onSaved: (value) {
                nationalIDNumber = value!;
              },
            ),
            AppSpacing.v24,
            CustomButton(
                text: 'Save',
                color: AppColors.primary,
                icon: Icons.check,
                onPressed: () async {
                  await saveNewOrder();
                }),
            AppSpacing.v24,
          ],
        ),
      ),
    ));
  }

  Future<void> saveNewOrder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Customer newCustomer = Customer(
        arabicName: arabicName,
        englishName: englishName,
        category: category,
        customerType: customerType,
        mobile: mobile,
        phone: phone,
        faxNumber: faxNumber,
        email: email,
        website: website,
        address: address,
        shippingAddress: shoppingAddress,
        nationalIdNumber: nationalIDNumber,
        isValid: false, // Default to false, can be changed later
        customerID: 0, // Assuming new customer, ID will be set by the server
      );
      http.Response response =
          await CustomerSqlManager.addNewCustomer(newCustomer);
      int responseCode = response.statusCode;
      if (responseCode == 200) {
        Get.back(); // Navigate back to homepage
        Get.snackbar(
          'Saved Successfully',
          'The customer is saved successfully',
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
