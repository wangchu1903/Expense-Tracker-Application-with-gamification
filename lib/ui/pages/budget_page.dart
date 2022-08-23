import 'package:expense_manager/controller/budget_controller.dart';
import 'package:expense_manager/model/budget_model.dart';
import 'package:expense_manager/routes/app_pages.dart';
import 'package:expense_manager/ui/components/no_data.dart';
import 'package:expense_manager/ui/components/progress_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ui/components/toolbar_component.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/constants.dart';

/// Handles listing of budgets
class BudgetPage extends ConsumerStatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

/// A Change notifier provider which provides a budget controller which is used to make
/// api calls and listen for results while updating the ui accordingly
final budgetNotifierProvider =
    ChangeNotifierProvider.autoDispose<BudgetController>(
        (ref) => BudgetController());

class _BudgetPageState extends ConsumerState<BudgetPage> {
  @override
  void initState() {
    super.initState();
    // An api called was made inside this method so it doesn't happen
    // while the ui still being updated
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ref.read(budgetNotifierProvider).getBudgets();
    });
  }

  /// A confirmation dialog that is shown before deleting the item
  Future<void> _deleteDialog(List<Data> data, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmation',
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
                  'Are you sure you would like to delete this item?',
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
                'Yes',
                style: TextStyle(
                    fontFamily: 'GTWalsheimPro',
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(budgetNotifierProvider).delete(data[index].id);
                ref.read(budgetNotifierProvider).getBudgets();
              },
            ),
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                    fontFamily: 'GTWalsheimPro',
                    color: accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
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
        body: SafeArea(
      child: Column(
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
                  'Budget',
                  style: TextStyle(
                      fontFamily: 'GTWalsheimPro',
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, Routes.addBudget),
                      icon: const Icon(
                        Icons.add,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(child: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final provider = ref.watch(budgetNotifierProvider);
              if (provider.apiResponse.isLoading) {
                return const ProgressDialog();
              }
              if (provider.apiResponse.model == null ||
                  (provider.apiResponse.model as Budget).data.isEmpty) {
                return const NoData();
              } else {
                final data = (provider.apiResponse.model as Budget).data;

                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(data[index].id),
                        onDismissed: (direction) {
                          _deleteDialog(data, index);
                          // setState(() {
                          //   data.removeAt(index);
                          // });

                          // ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(content: Text('Item Deleted')));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      data[index].title,
                                      style: const TextStyle(
                                          fontFamily: 'GTWalsheimPro',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      'Rs ' +
                                          data[index].totalAmount.numberDecimal,
                                      style: const TextStyle(
                                          fontFamily: 'GTWalsheimPro',
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  'Rs ' + data[index].amount.numberDecimal,
                                  style: const TextStyle(
                                      fontFamily: 'GTWalsheimPro',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                LinearProgressIndicator(
                                  value: (double.parse(data[index]
                                              .totalAmount
                                              .numberDecimal) /
                                          double.parse(data[index]
                                              .amount
                                              .numberDecimal)) /
                                      100.0,
                                  semanticsLabel: 'Linear progress indicator',
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ))
        ],
      ),
    ));
  }
}
