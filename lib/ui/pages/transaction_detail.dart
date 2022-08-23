import 'package:expense_manager/model/transaction_model.dart';
import 'package:expense_manager/utils/api_constants.dart';

import '../../utils/constants.dart';
import '../../ui/components/dashed_seperator.dart';
import '../../ui/components/primary_button.dart';
import 'package:flutter/material.dart';

import 'edit_transaction_page.dart';

class TransactionDetail extends StatefulWidget {
  const TransactionDetail({Key? key}) : super(key: key);

  @override
  _TransactionDetailState createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  _showEdit(Data transactionDetail, BuildContext context) {
    return showDialog(
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
            14,
          )),
          child: TransactionEdit(transactionDetail),
        );
      },
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final transaction = ModalRoute.of(context)!.settings.arguments as Data;

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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Transaction',
                    style: TextStyle(
                        fontFamily: 'GTWalsheimPro',
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payee',
                        style: TextStyle(
                            fontFamily: 'GTWalsheimPro',
                            fontSize: 16,
                            fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        transaction.payeeName,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'GTWalsheimPro',
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                height: 10,
                              ),
                              Text(
                                transaction.type,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'GTWalsheimPro',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(
                              height: 30,
                              child: VerticalDivider(color: Colors.black)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date',
                                style: TextStyle(
                                    fontFamily: 'GTWalsheimPro',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                transaction.date.split("T")[0],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'GTWalsheimPro',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const DashedSeparator(
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Amount',
                                  style: TextStyle(
                                      fontFamily: 'GTWalsheimPro',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  'Rs ' + transaction.amount,
                                  style: const TextStyle(
                                      fontFamily: 'GTWalsheimPro',
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                primary: primaryColor,
                                side: const BorderSide(
                                    width: 1.0, color: primaryColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              onPressed: () {
                                _showEdit(transaction, context);
                              },
                              child: const Text(
                                'Edit',
                                style: const TextStyle(
                                    fontFamily: 'GTWalsheimPro',
                                    fontSize: 14,
                                    color: primaryColor,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: transaction.file.isNotEmpty
                  ? Image.network(
                      ApiConstants.imageBaseaseUrl + transaction.file)
                  : Container(),
            )
          ],
        ),
      ),
    );
  }
}
