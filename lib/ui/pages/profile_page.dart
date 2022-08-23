import 'package:expense_manager/ui/components/primary_button.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/save_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

final emailProvider = FutureProvider<String>((ref) async {
  return await SaveData.getEmail();
});

final nameProvider = FutureProvider<String>((ref) async {
  return await SaveData.getName();
});

class _ProfilePageState extends ConsumerState<ProfilePage> {
  get child => null;

  _logout() {
    SaveData.saveData('', '', '');
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: const TextStyle(
                        fontFamily: 'GTWalsheimPro',
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes-thumbnail.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        border: Border.all(
                          color: Colors.grey,
                          width: 4.0,
                        ),
                      ),
                    ),
                    ref.watch(nameProvider).when(
                          data: (data) {
                            return Text(
                              data,
                              style: const TextStyle(
                                  fontFamily: 'GTWalsheimPro',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            );
                          },
                          error: (err, stack) => Text('Error: $err'),
                          loading: () => const CircularProgressIndicator(),
                        ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                          fontFamily: 'GTWalsheimPro',
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ref.watch(emailProvider).when(
                          data: (data) {
                            return Text(
                              data,
                              style: const TextStyle(
                                  fontFamily: 'GTWalsheimPro',
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            );
                          },
                          error: (err, stack) => Text('Error: $err'),
                          loading: () => const CircularProgressIndicator(),
                        ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 171, 67),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Points',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'GTWalsheimPro',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '100 Exp',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'GTWalsheimPro',
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_upward,
                                size: 40,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 35, 128, 251),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Achievements',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'GTWalsheimPro',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Good Saver',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'GTWalsheimPro',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.monetization_on,
                                size: 40,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    PrimaryButton(
                        title: "Logout",
                        color: primaryColor,
                        onPress: () {
                          _logout();
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
