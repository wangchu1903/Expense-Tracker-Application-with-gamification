import 'package:expense_manager/model/login_model.dart';
import 'package:expense_manager/routes/app_pages.dart';
import 'package:expense_manager/utils/save_data.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../ui/components/progress_dialog.dart';

import '../../controller/signup_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/constants.dart';
import '../components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

final signupProvider =
    ChangeNotifierProvider<SignupController>((ref) => SignupController());

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '', name = '', confirmPassword = '';
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
                Text("Registration Error"),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final provider = ref.watch(signupProvider);
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
            }
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
                    children: const [
                      Text(
                        'Expenses Tracker',
                        style: TextStyle(
                            fontFamily: 'GTWalsheimPro',
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Sign In',
                        style: TextStyle(
                            fontFamily: 'GTWalsheimPro',
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
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
                          'SignUp to Expenses Tracker',
                          style: TextStyle(
                              fontFamily: 'GTWalsheimPro',
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Your Name',
                          style: TextStyle(
                              fontFamily: 'GTWalsheimPro',
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w700),
                        ),
                        TextFormField(
                          onSaved: (value) => name = value ?? '',
                          keyboardType: TextInputType.name,
                          validator:
                              RequiredValidator(errorText: 'Please enter name'),
                          style: const TextStyle(
                              fontFamily: 'GTWalsheimPro',
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Enter your name',
                              hintStyle: TextStyle(
                                  fontFamily: 'GTWalsheimPro',
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700)),
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
                          validator:
                              EmailValidator(errorText: 'Please enter email'),
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
                          onSaved: (value) => password = value ?? '',
                          keyboardType: TextInputType.visiblePassword,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'Please enter password'),
                            MinLengthValidator(8,
                                errorText:
                                    'Password must be at least 8 digits long'),
                          ]),
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
                        const Text(
                          'Confirm Password',
                          style: TextStyle(
                              fontFamily: 'GTWalsheimPro',
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w700),
                        ),
                        TextFormField(
                          onSaved: (value) => confirmPassword = value ?? '',
                          keyboardType: TextInputType.visiblePassword,
                          validator: RequiredValidator(
                              errorText: 'Please enter your password again'),
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
                            title: "Sign Up",
                            color: primaryColor,
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                if (password != confirmPassword) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Password do not match')));
                                }
                                // context.read(loginProvider);

                                // context.ref(loginProvider).lo
                                // print(provider.apiResponse.isLoading);
                                provider.signup(name, email, password);
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ));
          },
        ),
      ),
    );
  }
}
