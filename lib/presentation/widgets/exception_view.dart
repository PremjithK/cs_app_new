import 'package:cybersquare/core/constants/colors.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:cybersquare/presentation/widgets/widget_text.dart';
import 'package:flutter/material.dart';

Widget setupExceptionView(String strMsg, {status = 0}) {
  return Container(
    padding: EdgeInsets.all(constDeviceType == 1
        ? status == 1
            ? 30
            : 16
        : 30),
    child: Center(
      child: widgetText(
          strMsg,
          "",
          constDeviceType == 1 ? 16 : 18,
          color_login_text_black,
          TextAlign.center,
          status == 1 ? FontWeight.w500 : FontWeight.w500,
          0),
    ),
  );
}

Widget setupEmptyListView(String strMsg, {status = 0}) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(color: color_black_10, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: color_bg_grey),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Center(
        child: widgetText(
            strMsg,
            "",
            constDeviceType == 1 ? 16 : 18,
            color_login_text_black,
            TextAlign.center,
            status == 1 ? FontWeight.w500 : FontWeight.w500,
            0),
      ),
    ),
  );
}
