import 'package:flutter/material.dart';

/// A toolbar component which has a back button as well
class ToolbarWithBackComponent extends StatelessWidget {
  final String title;
  final onPress;
  const ToolbarWithBackComponent({Key? key, required this.title, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: onPress,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: const TextStyle(
                fontFamily: 'GTWalsheimPro',
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
