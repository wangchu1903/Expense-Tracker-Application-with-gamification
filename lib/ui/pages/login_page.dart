import 'package:expense_manager/controller/login_controller.dart';
import 'package:expense_manager/model/login_model.dart';
import 'package:expense_manager/routes/app_pages.dart';
import 'package:expense_manager/ui/components/progress_dialog.dart';
import 'package:expense_manager/utils/save_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../utils/constants.dart';
import '../components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

final loginProvider =
    ChangeNotifierProvider<LoginController>((ref) => LoginController());

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '';

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Error logging in"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    SaveData.getToken().then((value) {
      if (value.isNotEmpty) {
        Navigator.pushNamed(context, Routes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final provider = ref.watch(loginProvider);

            if (provider.apiResponse.model != null) {
              final model = (provider.apiResponse.model as LoginModel);
              SaveData.saveData(
                  model.token, model.data.user.email, model.data.user.name);
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                Navigator.pushNamed(context, Routes.home);
              });
            }

            if (provider.apiResponse.errorMessage.isNotEmpty) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _showMyDialog();
                provider.apiResponse.errorMessage = '';
              });
            }

            if (provider.apiResponse.isLoading) {
              return const ProgressDialog();
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(14),
                              bottomRight: Radius.circular(14))),
                      padding: const EdgeInsets.all(8),
                      height: 60,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Expenses Tracker',
                            style: TextStyle(
                                fontFamily: 'GTWalsheimPro',
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, Routes.register),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontFamily: 'GTWalsheimPro',
                                  color: primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            Center(
                              child: SvgPicture.asset(
                                  'assets/saving_illustration.svg',
                                  height: 150),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Login to your account',
                              style: TextStyle(
                                  fontFamily: 'GTWalsheimPro',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Email',
                              style: TextStyle(
                                  fontFamily: 'GTWalsheimPro',
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextFormField(
                              onSaved: (value) => email = value ?? '',
                              keyboardType: TextInputType.emailAddress,
                              validator: EmailValidator(
                                  errorText: 'Please enter Email address'),
                              style: const TextStyle(
                                  fontFamily: 'GTWalsheimPro',
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  hintText: 'name@domain.com',
                                  hintStyle: TextStyle(
                                      fontFamily: 'GTWalsheimPro',
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Password',
                              style: TextStyle(
                                  fontFamily: 'GTWalsheimPro',
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextFormField(
                              obscureText: true,
                              onSaved: (value) => password = value ?? '',
                              validator: RequiredValidator(
                                  errorText: 'Please enter password'),
                              keyboardType: TextInputType.visiblePassword,
                              style: const TextStyle(
                                  fontFamily: 'GTWalsheimPro',
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  hintText: '*******',
                                  hintStyle: TextStyle(
                                      fontFamily: 'GTWalsheimPro',
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(height: 30),
                            PrimaryButton(
                                title: "Sign In",
                                color: primaryColor,
                                onPress: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();

                                    // context.read(loginProvider);

                                    // context.ref(loginProvider).lo
                                    // print(provider.apiResponse.isLoading);
                                    provider.login(email, password);
                                  }
                                }),
                            const SizedBox(height: 30),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.forgotPassword);
                              },
                              child: const Center(
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      fontFamily: 'GTWalsheimPro',
                                      fontSize: 14,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
