import '../../utils/constants.dart';
import 'package:flutter/material.dart';

/// A custom component used as a standard button throughout the project
class PrimaryButton extends StatelessWidget {
  final String title;
  // ignore: prefer_typing_uninitialized_variables
  final onPress;
  final Color color;

  const PrimaryButton(
      {Key? key,
      required this.title,
      required this.color,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // <-- match_parent
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
        ),
        onPressed: onPress,
        child: Text(
          title,
          style: const TextStyle(
              fontFamily: 'GTWalsheimPro',
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
