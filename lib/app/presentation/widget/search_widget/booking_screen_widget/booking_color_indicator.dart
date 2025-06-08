import 'package:flutter/material.dart';
import 'package:user_panel/core/utils/constant/constant.dart';

Row colorMarker(
    {required BuildContext context,
    required Color markColor,
    required String hintText}) {
  return Row(children: [
    Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          color: markColor,
          shape: BoxShape.rectangle,
        )),
    ConstantWidgets.width20(context),
    Text(hintText),
    ConstantWidgets.width40(context)
  ]);
}