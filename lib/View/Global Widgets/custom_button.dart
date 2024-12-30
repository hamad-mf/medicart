import 'package:flutter/material.dart';
import 'package:medicart/Utils/color_constants.dart';

// ignore: must_be_immutable
class customButton extends StatelessWidget {
  String text;
  final void Function()? onPressed;
   customButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      
        style: ButtonStyle(
            textStyle: WidgetStatePropertyAll(TextStyle(
                color: ColorConstants.mainwhite,
                fontWeight: FontWeight.w600,
                fontSize: 18)),
            minimumSize: WidgetStatePropertyAll(Size(175, 50)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            backgroundColor: WidgetStatePropertyAll(ColorConstants.appbar)),
        onPressed: onPressed,
        child: Text(text));
  }
}
