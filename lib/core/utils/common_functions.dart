// ignore_for_file: non_constant_identifier_names

import 'package:cybersquare/core/constants/colors.dart';
import 'package:cybersquare/globals.dart';
import 'package:cybersquare/presentation/ui/dashboard/course_progress_dialog.dart';
import 'package:cybersquare/presentation/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void showAlert({required BuildContext context,required String  strMsg}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (BuildContext context) => CupertinoAlertDialog(
      content: Text(strMsg),
      actions: [
        CupertinoDialogAction(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

int backPressFlag = 0;
bool onBackPressCallback()  {
  backPressFlag++;
  Future.delayed(const Duration(seconds: 1), () {
    backPressFlag = 0;
  });
  if (backPressFlag == 1) {
    // showToast(str_exit_msg);
    return false;
  }
  if (backPressFlag == 2) {
    SystemNavigator.pop();
    return true;
  }
  return false;
}

Widget Loading(visible){
  return Visibility(
    visible: visible,
    child: Container(
      alignment: Alignment.center,
      color: color_bg,
      child:  progressIndicator()
    ),
  );
}

setupEmptyView(String strMsg) {
  return Container(
    alignment: Alignment.center,
    width: double.infinity,
    padding: const EdgeInsets.all(30),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color_input_border,width: 1)
    ),
    child: Text(
      strMsg,
      style: GoogleFonts.getFont(
        globalFontName,
        color:  color_text,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

customButton(text,{withIcon = false,icon = null,onTap,btnColor=color_primary}){
  return
    GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: btnColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        child:
        Row(
          children: [
            withIcon ? Padding(padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),child: icon,) :const SizedBox(width: 0,),
            Text(
              text,
              style: GoogleFonts.getFont(
                globalFontName,
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
}

getFormattedDate(d){
  // 2021-11-12T14:06:00.276
  DateTime date =  DateFormat("yyyy-MM-dd' 'HH:mm:ss").parse(d);
  String dayName = DateFormat('EEE').format(date);
  String month = DateFormat('MMM').format(date);
  String day = DateFormat('dd').format(date);
  String year = DateFormat('yyyy').format(date);
  String h = DateFormat('HH').format(date);
  String hr = DateFormat('hh').format(date);
  String m = DateFormat('mm').format(date);
  String a = int.parse(h)<12 ? "AM" : "PM";
  return "$dayName, $month $day $year\n$hr:$m $a";
}

roundedProgress(progress){
  return
    Container(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: LinearProgressIndicator(
            value: double.parse(progress.toString())/100,
           // value: 10.0/100,
            valueColor: AlwaysStoppedAnimation(
                progress==100 ? courseCompleteColor : courseIncompleteColor
            ),
            backgroundColor: progressBgColor,
            minHeight: 10
        ),
      ),
    );
}