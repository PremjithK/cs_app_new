// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:cybersquare/core/constants/api_endpoints.dart';
import 'package:cybersquare/core/constants/asset_images.dart';
import 'package:cybersquare/core/constants/colors.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:cybersquare/core/services/api_services.dart';
import 'package:cybersquare/globals.dart';
import 'package:cybersquare/logic/providers/course_detail_screen_provider.dart';
import 'package:cybersquare/presentation/widgets/widget_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

bool isFullScreen = false;
AppBar setupAppbar(BuildContext context, String strTitle,
    {status = 0, loaderStatus = false, avatar = ""}) {
  //status: 2-> show progress instead of profile icon, 3-> from profile screen(don't show profile icon)
  final btnMenu = Builder(builder: (context) {
    return SizedBox(
      width: 55,
      height: 55,
      child: Center(
        child: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () async {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
    );
  });

  final btnDropdown = SizedBox(
    height: 40,
    width: constDeviceType == 1 ? 200 : 230,
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
          menuWidth: 160,
          focusColor: Colors.transparent,
          dropdownColor: Colors.white,
          iconSize: 0,
          elevation: 8,
          isExpanded: true,
          onChanged: (String? newValue) {
            if (newValue == "Profile") {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (BuildContext context) =>
              //         ProfileScreen("Profile", avatar),
              //   ),
              // );
            }
            if (newValue == "Logout") {
              // showAlertLogout(str_logout_confirmation_msg, context);
            }
            if (newValue == "Switch Account") {
              // AccountsManager.instance.showAccountSwitcher(context);
            }
          },
          items: status != 3
              ? ["Switch Account", "Profile", "Logout"]
                  .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.getFont(
                        globalFontName,
                        color: Colors.black,
                        fontSize: constDeviceType == 1 ? 15 : 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList()
              : ["Switch Account", "Logout"]
                  .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.getFont(
                        globalFontName,
                        color: Colors.black,
                        fontSize: constDeviceType == 1 ? 15 : 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList()),
    ),
  );
  final viewProfilePic = Container(
    width: constDeviceType == 1 ? 35 : 40,
    height: constDeviceType == 1 ? 35 : 40,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white, width: 3),
      shape: BoxShape.circle,
    ),
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      child: FadeInImage(
        placeholder: AssetImage(img_user_placeholder),
        image: NetworkImage(avatar),
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset(
            img_user_placeholder,
            fit: BoxFit.contain,
          );
        },
        fit: BoxFit.contain,
      ),
    ),
  );

  final stackDropDown = SizedBox(
    width: 100,
    child: Stack(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: viewProfilePic,
        ),
        btnDropdown,
      ],
    ),
  );

  final appbar = AppBar(
    backgroundColor: color_cybersquare_red,
    centerTitle: false,
    title: widgetText(
      strTitle,
      "",
      constDeviceType == 1 ? 20 : 22,
      Colors.white,
      TextAlign.left,
      FontWeight.bold,
      0,
    ),
    leading: btnMenu,
    actions: [
      Visibility(
        visible: true,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 16,
          ),
          child: stackDropDown,
        ),
      ),
      Visibility(
        visible: loaderStatus && status == 2,
        child: Padding(
          padding: EdgeInsets.only(right: 16, top: 15, bottom: 15),
          child: SizedBox(
            width: 26,
//            height: 10,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ],
  );
  return appbar;
}

AppBar setupAppbarWithBack(BuildContext context, String strTitle,
    {status = 0,
    loaderStatus = false,
    hidebar = false,
    hideText = false,
    reload = 0,
    isFromDrawer = false}) {
  final prov = Provider.of<courseProvider>(context, listen: false);
  final btnBack = SizedBox(
    // width: 55,
    height: 55,
    child: Center(
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 25,
        ),
        onPressed: () async {
          if (isFromDrawer == true) {
            prov.setmenuIndex(100); //100 for setting to dashboard
          }
          if (reload == 1) {
            // Navigator.pushReplacement<void, void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (BuildContext context) => CoursesListScreen(
            //       screenStatus: 1,
            //       strTitle: strTitle,
            //       avatar: Userlogo,
            //     ),
            //   ),
            // );
          } else {
            if (isFromDrawer == true) {
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: ((context) {
              //   return DashboardScreen('');
              // })));
            } else {
              Navigator.pop(context);
            }
          }
        },
      ),
    ),
  );

  return AppBar(
    backgroundColor: color_cybersquare_red,
    centerTitle: false,
    titleSpacing: 0,
    title: widgetText(
        strTitle,
        "",
        constDeviceType == 1
            ? status == 1
                ? 19
                : 20
            : 22,
        Colors.white,
        TextAlign.left,
        FontWeight.w700,
        0),
    leading: btnBack,
    actions: [
      Visibility(
        visible: loaderStatus,
        child: Padding(
          padding: EdgeInsets.only(right: 16, top: 15, bottom: 15),
          child: SizedBox(
            width: 26,
//            height: 10,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

void showAlertLogout(String strMsg, BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (BuildContext context) => CupertinoAlertDialog(
      content: Text(
        strMsg,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text("Logout This Device"),
          onPressed: () async {
            Provider.of<courseProvider>(context, listen: false)
                .setmenuIndex(100);
            Navigator.of(context).pop();
            // AccountsManager.instance.logoutCurrentUser(context);
          },
        ),
        CupertinoDialogAction(
          child: const Text("Logout All Devices"),
          onPressed: () {
            Provider.of<courseProvider>(context, listen: false)
                .setmenuIndex(100);
            Navigator.of(context).pop();
            // AccountsManager.instance.logoutCurrentUser(context, true);
          },
        ),
        CupertinoDialogAction(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
    /*{
      return LogoutDialog();
    }*/
  );
}

logoutApi(BuildContext context, bool fromAlldevices) async {
  // post method api call
  String strUrl = '${url_identity_service}logout';

  var postData = {
    "allDevices": fromAlldevices,
  };

  var headerData = {
    "Content-Type": "application/json; charset=UTF-8",
    "authorization": constUserToken,
  };

  try {
    final response = await postMethodApi(postData, strUrl, headerData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = json.decode(response.body);
    } else {}
  } on SocketException catch (_) {}
}
