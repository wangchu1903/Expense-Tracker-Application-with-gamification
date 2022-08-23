import 'package:expense_manager/controller/budget_controller.dart';
import 'package:expense_manager/controller/transaction_controller.dart';
import 'package:expense_manager/model/budget_model.dart';
import 'package:expense_manager/ui/components/progress_dialog.dart';
import 'package:expense_manager/ui/pages/budget_page.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod/riverpod.dart';

import '../../ui/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import '../../utils/constants.dart';

/// This page is used to add transactions
/// It uses riverpod for state management
class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({Key? key}) : super(key: key);

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

/// used to track and update a linear progress indicator in the component
final currentPageStateProvider = AutoDisposeStateProvider<double>((ref) {
  return 0.5;
});

/// used to track and update a expense type drop down
final expenseTypeProvider = StateProvider<String>((ref) {
  return "";
});

/// used to track and update a date picker
final pickedDateProvider = AutoDisposeStateProvider<String>((ref) {
  return "";
});

/// used to track and update a image picker
final imageProvider = AutoDisposeStateProvider<XFile?>((ref) {
  return null;
});

/// used to track and update a budget picker
final selectedBudget = AutoDisposeStateProvider<Data?>((ref) {
  return null;
});

/// A Change notifier provider which provides a transaction controller which is used to make
/// api calls and listen for results while updating the ui accordingly
final createTransactionNotifierProvider =
    ChangeNotifierProvider.autoDispose<TransactionController>(
        (ref) => TransactionController());

final budgetNotifier = ChangeNotifierProvider.autoDispose<BudgetController>(
    (ref) => BudgetController());

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  PageController controller = PageController();
  void onPageChange() {
    controller.animateToPage(1,
        duration: const Duration(milliseconds: 300), curve: Curves.bounceIn);
    ref.read(currentPageStateProvider.state).state = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final counter = ref.watch(currentPageStateProvider.state);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Add transaction',
                      style: TextStyle(
                          fontFamily: 'GTWalsheimPro',
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              LinearProgressIndicator(
                  color: primaryColor, value: counter.state),
              Expanded(
                  child: PageView(
                controller: controller,
                children: [
                  StepOne(
                    onPress: onPageChange,
                  ),
                  StepTwo(
                    onPress: onPageChange,
                  )
                ],
              )),
            ],
          );
        },
      ),
    ));
  }
}

class StepOne extends ConsumerWidget {
  final onPress;
  const StepOne({
    Key? key,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Center(
            child:
                SvgPicture.asset('assets/saving_illustration.svg', height: 150),
          ),
          const SizedBox(height: 30),
          const Text(
            'What kind of \ntransaction is this?',
            style: TextStyle(
                fontFamily: 'GTWalsheimPro',
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.watch(expenseTypeProvider.state).state = "Income";
                    onPress();
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3.0),
                            decoration: const BoxDecoration(
                                color: secondaryColor, shape: BoxShape.circle),
                            child: const Icon(
                              Icons.keyboard_arrow_left_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Text(
                            'Income',
                            style: TextStyle(
                                fontFamily: 'GTWalsheimPro',
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.watch(expenseTypeProvider.state).state = "Expense";
                    onPress();
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3.0),
                            decoration: const BoxDecoration(
                                color: primaryColor, shape: BoxShape.circle),
                            child: const Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Text(
                            'Expense',
                            style: TextStyle(
                                fontFamily: 'GTWalsheimPro',
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class StepTwo extends ConsumerWidget {
  final onPress;
  var dateController = TextEditingController();
  var payeeController = TextEditingController();
  var amountController = TextEditingController();

  StepTwo({Key? key, required this.onPress}) : super(key: key);
  void onDateSelect(BuildContext context) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2000, 3, 5),
        maxTime: DateTime.now(), onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      print('confirm $date');
      dateController.text = date.year.toString() +
          "-" +
          (date.month > 9
              ? date.month.toString()
              : "0" + date.month.toString()) +
          "-" +
          date.day.toString() +
          "T00:00:00.000Z";
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  Future<void> _imagePicker(BuildContext context, WidgetRef ref) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Select Image',
            style: TextStyle(
                fontFamily: 'GTWalsheimPro',
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Please Select Image Source',
                  style: TextStyle(
                      fontFamily: 'GTWalsheimPro',
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Take Picture',
                style: TextStyle(
                    fontFamily: 'GTWalsheimPro',
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                _takePicture(ref);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text(
                'Gallery',
                style: TextStyle(
                    fontFamily: 'GTWalsheimPro',
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                print("REF${ref}");
                _pickGallery(ref);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _pickGallery(WidgetRef ref) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    ref.read(imageProvider.state).state = image;
  }

  _takePicture(WidgetRef ref) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    ref.read(imageProvider.state).state = photo;
  }

  @override
  Widget build(BuildContext context, ref) {
    final expenseType = ref.watch(expenseTypeProvider.state).state;
    final transactionController = ref.watch(createTransactionNotifierProvider);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ref.read(budgetNotifier).getBudgets();
    });
    if (transactionController.apiResponse.isLoading) {
      return const ProgressDialog();
    } else if (transactionController.apiResponse.model != null &&
        (transactionController.apiResponse.model as bool)) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
      return const ProgressDialog();
    } else {
      return Container(
        margin: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        color: expenseType == "Income"
                            ? secondaryColor
                            : primaryColor,
                        shape: BoxShape.circle),
                    child: Icon(
                      expenseType == "Income"
                          ? Icons.keyboard_arrow_left_rounded
                          : Icons.keyboard_arrow_right_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transaction Type',
                        style: TextStyle(
                            fontFamily: 'GTWalsheimPro',
                            fontSize: 16,
                            fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        expenseType,
                        style: const TextStyle(
                            fontFamily: 'GTWalsheimPro',
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Payee name',
                style: TextStyle(
                    fontFamily: 'GTWalsheimPro',
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700),
              ),
              TextField(
                controller: payeeController,
                keyboardType: TextInputType.name,
                style: const TextStyle(
                    fontFamily: 'GTWalsheimPro',
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Enter payee name',
                    hintStyle: TextStyle(
                        fontFamily: 'GTWalsheimPro',
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Amount',
                style: TextStyle(
                    fontFamily: 'GTWalsheimPro',
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
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
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Budget',
                style: TextStyle(
                    fontFamily: 'GTWalsheimPro',
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700),
              ),
              Consumer(builder:
                  (BuildContext context, WidgetRef ref, Widget? child) {
                final res = ref.watch(budgetNotifier);
                if (res.apiResponse.model == null ||
                    res.apiResponse.isLoading) {
                  return const ProgressDialog();
                } else {
                  final data = (res.apiResponse.model as Budget).data;
                  return DropdownButton<Data>(
                    isExpanded: true,
                    value: ref.watch(selectedBudget.state).state,
                    items: data.map((Data value) {
                      return DropdownMenuItem<Data>(
                        value: value,
                        child: Text(value.title,
                            style: const TextStyle(
                                fontFamily: 'GTWalsheimPro',
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal)),
                      );
                    }).toList(),
                    onChanged: (data) {
                      ref.read(selectedBudget.state).state = data;
                    },
                  );
                }
              }),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Date',
                style: TextStyle(
                    fontFamily: 'GTWalsheimPro',
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () {
                  onDateSelect(context);
                },
                child: TextField(
                  controller: dateController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      fontFamily: 'GTWalsheimPro',
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                  decoration: const InputDecoration(
                      enabled: false,
                      border: UnderlineInputBorder(),
                      hintText: 'Select Date',
                      hintStyle: TextStyle(
                          fontFamily: 'GTWalsheimPro',
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Receipt Image',
                style: TextStyle(
                    fontFamily: 'GTWalsheimPro',
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  child: ref.watch(imageProvider.state).state == null
                      ? GestureDetector(
                          onTap: () => _imagePicker(context, ref),
                          child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12))),
                              child: const Center(
                                child: Icon(Icons.image),
                              )),
                        )
                      : Container(
                          child: Image.file(
                              File(ref.read(imageProvider.state).state!.path)),
                        )),
              const SizedBox(
                height: 10,
              ),

              // Image(image: image)
              const SizedBox(
                height: 20,
              ),

              PrimaryButton(
                  title: "FINISH",
                  color: primaryColor,
                  onPress: () {
                    if (amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter amount')));
                      return;
                    }

                    if (payeeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please enter Payee Name')));
                      return;
                    }

                    if (dateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select date')));
                      return;
                    }

                    if (expenseType.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please select expense type')));
                      return;
                    }
                    if (ref.read(selectedBudget.state).state == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please select Budget')));
                      return;
                    }
                    if (ref.read(imageProvider.state).state == null) {
                      transactionController.transaction(
                          payeeController.text,
                          amountController.text,
                          dateController.text,
                          expenseType,
                          ref.read(selectedBudget.state).state!.id);
                    } else {
                      transactionController.transaction(
                          payeeController.text,
                          amountController.text,
                          dateController.text,
                          expenseType,
                          ref.read(selectedBudget.state).state!.id,
                          file: ref.read(imageProvider.state).state!.path);
                    }
                  }),
            ],
          ),
        ),
      );
    }
  }
}
