import 'package:expense_manager/controller/forgotpassword_controller.dart';
import 'package:expense_manager/routes/app_pages.dart';
import 'package:expense_manager/ui/components/progress_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../utils/constants.dart';
import '../components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

final forgotPasswordProvider = ChangeNotifierProvider<ForgotPasswordController>(
    (ref) => ForgotPasswordController());

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(forgotPasswordProvider);
    if (provider.success) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushNamed(context, Routes.verifyCode,
            arguments: emailController.text);
      });
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: provider.apiResponse.isLoading
            ? const ProgressDialog()
            : SingleChildScrollView(
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
                            'Forgot your password?',
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
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                fontFamily: 'GTWalsheimPro',
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'name@domain.com',
                                hintStyle: TextStyle(
                                    fontFamily: 'GTWalsheimPro',
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 30),
                          PrimaryButton(
                              title: "Submit",
                              color: primaryColor,
                              onPress: () {
                                if (emailController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please your email address')));
                                  return;
                                }
                                ref
                                    .read(forgotPasswordProvider)
                                    .forgot(emailController.text);
                              }),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
