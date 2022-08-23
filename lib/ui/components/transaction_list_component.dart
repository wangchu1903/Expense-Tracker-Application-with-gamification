import 'package:expense_manager/model/transaction_model.dart';
import 'package:expense_manager/routes/app_pages.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

/// This list is being used to display transaction lists
/// a List<Data> is passed to this component which it uses to display the list
class TransactionListComponent extends StatefulWidget {
  final List<Data> transaction;
  final onDelete;
  const TransactionListComponent(
      {Key? key, required this.transaction, this.onDelete})
      : super(key: key);

  @override
  _TransactionListComponentState createState() =>
      _TransactionListComponentState();
}

class _TransactionListComponentState extends State<TransactionListComponent> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.transaction.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(widget.transaction[index].id),
          onDismissed: (direction) {
            if (widget.onDelete != null) {
              widget.onDelete(widget.transaction, index);
            }
          },
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.transactionDetail,
                  arguments: widget.transaction[index]);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.transaction[index].payeeName,
                      style: const TextStyle(
                          fontFamily: 'GTWalsheimPro',
                          fontSize: 19,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Rs. " + widget.transaction[index].amount,
                      style: TextStyle(
                          fontFamily: 'GTWalsheimPro',
                          fontSize: 16,
                          color: widget.transaction[index].type == "INCOME"
                              ? accentColor
                              : primaryColor,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  widget.transaction[index].date.split('T')[0],
                  style: const TextStyle(
                      fontFamily: 'GTWalsheimPro',
                      fontSize: 12,
                      fontWeight: FontWeight.w300),
                ),
                Divider()
              ],
            ),
          ),
        );
      },
    );
  }
}
