import 'package:expense_manager/model/stats_detail.dart';
import 'package:expense_manager/model/transaction_model.dart';

import '../../utils/constants.dart';
import '../../ui/components/toolbar_with_back_component.dart';
import '../../ui/components/transaction_list_component.dart';
import 'package:flutter/material.dart';

class StatDetailPage extends StatefulWidget {
  const StatDetailPage({Key? key}) : super(key: key);

  @override
  _StatDetailPageState createState() => _StatDetailPageState();
}

class _StatDetailPageState extends State<StatDetailPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as StatsDetail;
    List<Data> transactions = [];
    for (int i = 0; i < args.transaction.length; i++) {
      if (args.transaction[i].type.toLowerCase() == args.title.toLowerCase()) {
        transactions.add(args.transaction[i]);
      }
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToolbarWithBackComponent(
              title: args.title,
              onPress: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color:
                        args.title == 'Income' ? secondaryColor : primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Till Date',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'GTWalsheimPro',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Rs ' + args.total.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'GTWalsheimPro',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          size: 40,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Transactions',
                style: TextStyle(
                    fontFamily: 'GTWalsheimPro',
                    fontSize: 16,
                    fontWeight: FontWeight.w300),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: TransactionListComponent(
                  transaction: transactions,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
