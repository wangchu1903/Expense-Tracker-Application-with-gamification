import 'package:expense_manager/controller/transaction_controller.dart';
import 'package:expense_manager/model/transaction_model.dart';
import 'package:expense_manager/ui/components/primary_button.dart';
import 'package:expense_manager/ui/components/progress_dialog.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionEdit extends ConsumerStatefulWidget {
  final Data transaction;
  const TransactionEdit(this.transaction, {Key? key}) : super(key: key);

  @override
  _TransactionEditState createState() => _TransactionEditState();
}

final transactionProvider =
    ChangeNotifierProvider.autoDispose<TransactionController>(
        (ref) => TransactionController());

class _TransactionEditState extends ConsumerState<TransactionEdit> {
  var dateController = TextEditingController();
  var payeeController = TextEditingController();
  var amountController = TextEditingController();
  String _selected = "EXPENSE";
  String id = '';

  @override
  void initState() {
    super.initState();
    payeeController.text = widget.transaction.payeeName;
    dateController.text = widget.transaction.date;
    amountController.text = widget.transaction.amount;
    _selected = widget.transaction.type;
    id = widget.transaction.id;
  }

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

  @override
  Widget build(BuildContext context) {
    final transactionController = ref.watch(transactionProvider);
    if (transactionController.success) {
      Navigator.pop(context);
    }
    if (transactionController.apiResponse.isLoading) {
      return const ProgressDialog();
    } else {
      return SizedBox(
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                'Transaction Type',
                style: TextStyle(
                    fontFamily: 'GTWalsheimPro',
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700),
              ),
              DropdownButton<String>(
                isExpanded: true,
                value: _selected,
                items: <String>["EXPENSE", "INCOME"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(
                            fontFamily: 'GTWalsheimPro',
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal)),
                  );
                }).toList(),
                onChanged: (data) {
                  setState(() {
                    _selected = data!;
                  });
                },
              ),
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
                height: 20,
              ),
              PrimaryButton(
                  title: "UPDATE",
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

                    if (_selected.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please select expense type')));
                      return;
                    }
                    ref.read(transactionProvider).updateTransaction(
                        payeeController.text,
                        amountController.text,
                        dateController.text,
                        _selected,
                        id);
                  }),
            ],
          ),
        ),
      );
    }
  }
}
