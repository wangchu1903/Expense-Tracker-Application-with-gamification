import 'package:expense_manager/utils/save_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_manager/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('check if token, email and name are saved in shared preferencees',
      () async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(SaveData.email, "wangchu1903@gmail.com");
    final email = await SaveData.getEmail();
    expect(email, "wangchu1903@gmail.com");
  });
}
