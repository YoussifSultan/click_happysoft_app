import 'package:click_happysoft_app/login_page/classes/salesman.dart';
import 'package:click_happysoft_app/login_page/salesman_sqlmanager.dart';
import 'package:click_happysoft_app/routing/app_routes.dart';
import 'package:click_happysoft_app/ui_commonwidgets/common_constants.dart';
import 'package:click_happysoft_app/ui_commonwidgets/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.dark, AppColors.light],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.v16,
                    // Username
                    CustomTextBox(
                      label: 'Email',
                      helperText: 'Type your Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!GetUtils.isEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value;
                      },
                      icon: Icons.email_outlined,
                    ),

                    // Password
                    CustomTextBox(
                        label: 'Password',
                        onSaved: (value) {
                          _password = value;
                        },
                        icon: Icons.password_outlined,
                        helperText: 'Type your Password',
                        isPassword: true),
                    AppSpacing.v8,
                    CustomButton(
                        text: 'Login',
                        color: AppColors.primary,
                        icon: Icons.login,
                        onPressed: () async {
                          await login();
                        }),
                    AppSpacing.v4,
                    // Login Button

                    AppSpacing.v8,
                    const Text("Or Sign Up Using"),
                    AppSpacing.v8,

                    // Social Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.facebook, color: Colors.blue),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.g_mobiledata, color: Colors.red),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.alternate_email,
                              color: Colors.lightBlue),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Salesman? salesman =
          await SalesmanSqlManager.checkLogin(_email, _password);

      if (salesman != null) {
        Get.snackbar(
          'Login Successful',
          'Welcome ${salesman.name}',
        );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        await prefs.setString('salesman_email', salesman.email);
        await prefs.setInt('salesman_id', salesman.id);
        await prefs.setString('salesman_name', salesman.name);
        Get.offAndToNamed(AppRoutes.orders);
      } else {
        Get.snackbar(
          'Login Failed',
          'Invalid email or password',
        );
      }
    }
  }
}
