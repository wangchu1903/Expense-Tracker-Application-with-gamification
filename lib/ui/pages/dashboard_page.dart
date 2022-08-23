import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:expense_manager/database/database.dart';
import 'package:expense_manager/provider/database_provider.dart';
import 'package:expense_manager/routes/app_pages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shake/shake.dart';

import '../../utils/constants.dart';
import 'package:flutter/material.dart';

import 'budget_page.dart';
import 'daily_transactions.dart';
import 'profile_page.dart';
import 'stats_page.dart';

final currentPageStateProvider = AutoDisposeStateProvider<int>((ref) {
  return 0;
});

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  static const List<Widget> _widgetOptions = <Widget>[
    DailyTransaction(),
    StatsPage(),
    StatsPage(),
    BudgetPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _setupDB();
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      Navigator.pushNamed(context, Routes.add_transaction);
    });
  }

  _setupDB() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('flutter_database.db').build();
    final dao = database.transactionDao;
    ref.read(databaseProvider.state).state = dao;
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(currentPageStateProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        //Floating action button on Scaffold
        onPressed: () {
          Navigator.pushNamed(context, Routes.add_transaction);
        },
        child: const Icon(
          Icons.add,
        ), //icon inside button
      ),
      body: SafeArea(
        child: _widgetOptions.elementAt(currentPage),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        //bottom navigation bar on scaffold
        color: Colors.white,
        shape: CircularNotchedRectangle(), //shape of notch
        notchMargin:
            5, //notche margin between floating button and bottom appbar
        child: Row(
          //children inside bottom appbar
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.grey.shade500,
              ),
              onPressed: () {
                ref.read(currentPageStateProvider.state).state = 0;
              },
            ),
            IconButton(
              icon: Icon(
                Icons.stacked_bar_chart,
                color: Colors.grey.shade500,
              ),
              onPressed: () {
                ref.read(currentPageStateProvider.state).state = 1;
              },
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.grey.shade100,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.all_out,
                color: Colors.grey.shade500,
              ),
              onPressed: () {
                ref.read(currentPageStateProvider.state).state = 3;
              },
            ),
            IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.grey.shade500,
              ),
              onPressed: () {
                ref.read(currentPageStateProvider.state).state = 4;
              },
            ),
          ],
        ),
      ),
    );
  }
}
