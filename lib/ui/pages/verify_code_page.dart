import 'package:expense_manager/controller/forgotpassword_controller.dart';
import 'package:expense_manager/ui/components/progress_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../utils/constants.dart';
import '../components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerifyCodePage extends ConsumerStatefulWidget {
  const VerifyCodePage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

final forgotPasswordProvider = ChangeNotifierProvider<ForgotPasswordController>(
    (ref) => ForgotPasswordController());

class _ForgotPasswordPageState extends ConsumerState<VerifyCodePage> {
  var codeController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;
    final provider = ref.watch(forgotPasswordProvider);
    if (provider.success) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Your password has been reset'),
            action: SnackBarAction(
                label: "Sign In",
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                })));
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
                            'Please enter your verification code',
                            style: TextStyle(
                                fontFamily: 'GTWalsheimPro',
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Verification Code',
                            style: TextStyle(
                                fontFamily: 'GTWalsheimPro',
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700),
                          ),
                          TextField(
                            controller: codeController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                fontFamily: 'GTWalsheimPro',
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: '000000',
                                hintStyle: TextStyle(
                                    fontFamily: 'GTWalsheimPro',
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'New Password',
                            style: TextStyle(
                                fontFamily: 'GTWalsheimPro',
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700),
                          ),
                          TextField(
                            obscureText: true,
                            controller: passwordController,
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
                          const Text(
                            'Confirm Password',
                            style: TextStyle(
                                fontFamily: 'GTWalsheimPro',
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700),
                          ),
                          TextField(
                            obscureText: true,
                            controller: confirmController,
                            keyboardType: TextInputType.visiblePassword,
                            style: const TextStyle(
                                fontFamily: 'GTWalsheimPro',
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: '000000',
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
                                if (codeController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please your verification code')));
                                  return;
                                }

                                if (passwordController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please your new password')));
                                  return;
                                }

                                if (passwordController.text !=
                                    confirmController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please make sure your passwords match')));
                                  return;
                                }
                                ref.read(forgotPasswordProvider).verifyCode(
                                    codeController.text,
                                    email,
                                    passwordController.text);
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
