import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:expense_manager/controller/budget_controller.dart';
import 'package:expense_manager/ui/components/progress_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../ui/components/primary_button.dart';
import '../../ui/components/toolbar_with_back_component.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class CreateBudgetPage extends ConsumerStatefulWidget {
  const CreateBudgetPage({Key? key}) : super(key: key);

  @override
  _CreateBudgetPageState createState() => _CreateBudgetPageState();
}

final budgetNotifierProvider =
    ChangeNotifierProvider.autoDispose<BudgetController>(
        (ref) => BudgetController());

class _CreateBudgetPageState extends ConsumerState<CreateBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '', amount = '', totalAmount = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final provider = ref.watch(budgetNotifierProvider);
          if (provider.apiResponse.isLoading) {
            return const ProgressDialog();
          }
          if (provider.success) {
            AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
              if (!isAllowed) {
                // This is just a basic example. For real apps, you must show some
                // friendly dialog box before call the request method.
                // This is very important to not harm the user experience
                AwesomeNotifications().requestPermissionToSendNotifications();
              }
              AwesomeNotifications().createNotification(
                  content: NotificationContent(
                      id: 10,
                      channelKey: 'basic_channel',
                      title: 'Budget Created',
                      body: 'A new budget was created'));
            });
            Navigator.pop(context);
          }
          return Form(
            key: _formKey,
            child: Column(
              children: [
                ToolbarWithBackComponent(title: 'Create Budget'),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'Budget Title',
                        style: TextStyle(
                            fontFamily: 'GTWalsheimPro',
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w700),
                      ),
                      TextFormField(
                        onSaved: (value) => title = value ?? '',
                        keyboardType: TextInputType.name,
                        validator:
                            RequiredValidator(errorText: 'Please enter Title'),
                        style: const TextStyle(
                            fontFamily: 'GTWalsheimPro',
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: 'Please enter budget title',
                            hintStyle: TextStyle(
                                fontFamily: 'GTWalsheimPro',
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Total Budget Amount',
                        style: TextStyle(
                            fontFamily: 'GTWalsheimPro',
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w700),
                      ),
                      TextFormField(
                        onSaved: (value) => totalAmount = value ?? '',
                        keyboardType: TextInputType.number,
                        validator: RequiredValidator(
                            errorText: 'Please enter Total budgetAmount'),
                        style: const TextStyle(
                            fontFamily: 'GTWalsheimPro',
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: '0.00',
                            hintStyle: TextStyle(
                                fontFamily: 'GTWalsheimPro',
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 30),
                      PrimaryButton(
                          title: "Save",
                          color: primaryColor,
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              ref.read(budgetNotifierProvider).createBudget(
                                  title, totalAmount, totalAmount);
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
