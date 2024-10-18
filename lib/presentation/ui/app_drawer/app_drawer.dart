// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cybersquare/core/constants/api_endpoints.dart';
import 'package:cybersquare/core/constants/asset_images.dart';
import 'package:cybersquare/core/constants/colors.dart';
import 'package:cybersquare/core/constants/const_strings.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:cybersquare/data/models/side_menu_model.dart';
import 'package:cybersquare/data/repositories/drawer_repo.dart';
import 'package:cybersquare/globals.dart';
import 'package:cybersquare/logic/providers/course_detail_screen_provider.dart';
import 'package:cybersquare/presentation/ui/dashboard/dashboard_screen.dart';
import 'package:cybersquare/presentation/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  final String avatar;
  const AppDrawer({super.key, required this.avatar});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String strEmail = "";
  String strName = "";
  String logo = "";
  @override
  Widget build(BuildContext context) {
    logo = widget.avatar;

    return listSideMenu.isNotEmpty
        ? setupMenu()
        : constIsConnectedToInternet
            ? getMenuData()
            : setupMenu();
  }

  Widget getMenuData() {
    return FutureBuilder<http.Response>(
      future: getMenuDataApi(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return setupMenu();
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          var data = json.decode(snapshot.data!.body);
          if (data["statusCode"] == 403 && data["forceLogout"] == true) {
            // return logoutUser(context, 1);
            return SizedBox();
          } else if (data != null &&
              snapshot.data!.body.contains("menuStructure")) {
            if (data["menuStructure"] != null) {
              var allCategoriesTemp = data["menuStructure"] as List;
              if (allCategoriesTemp.isNotEmpty) {
                var allCategories =
                    data["menuStructure"][0]["regionMenuStructure"] as List;
                listSideMenu = allCategories
                    .map<RegionMenuStructure>(
                        (json) => RegionMenuStructure.fromJson(json))
                    .toList();
              }
            }
          }

          return setupMenu();
        } else {
          return Center(
            child: progressIndicator(),
          );
        }
      },
    );
  }

  Widget setupMenu() {
    final viewProfilePic = Container(
      width: constDeviceType == 1 ? 90 : 100,
      height: constDeviceType == 1 ? 90 : 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 3),
        shape: BoxShape.circle,
        // image: DecorationImage(
        //   // image: constUserImg == "" || constIsConnectedToInternet == false
        //   //     ? AssetImage(img_user_placeholder)
        //   //     : NetworkImage(url_img_base + constUserImg),
        //   image: NetworkImage(widget.avatar),
        //   fit: BoxFit.contain, //constUserImg == "" ? BoxFit.contain :
        // ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        child: FadeInImage(
          placeholder: AssetImage(img_user_placeholder),
          image: NetworkImage(widget.avatar),
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

    if (constLoginData["active_user_data"] != null) {
      if (constLoginData["active_user_data"]["username"] != null) {
        strName = constLoginData["active_user_data"]["username"];
      }
    } else if (constLoginData["ActiveUserData"] != null) {
      strName = constLoginData["ActiveUserData"]["username"] ?? "";
    }

    if (strName != "") {
      strName = strName.toUpperCase();
    }

    if (constLoginData["ActiveUserData"] != null) {
      strEmail = constLoginData["ActiveUserData"]["userName"] ?? "";
    }

    final txtUserName = Text(
      strName,
      textAlign: TextAlign.center,
      // maxLines: 3,
      style: GoogleFonts.getFont(
        globalFontName,
        color: color_side_menu_text,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );

    final txtUserEmail = Text(
      strEmail,
      textAlign: TextAlign.center,
      // maxLines: 2,
      style: GoogleFonts.getFont(
        globalFontName,
        color: color_side_menu_text,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
    );

    final columnUserDetails = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: viewProfilePic,
        ),
        // viewProfilePic,
        Padding(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: txtUserName,
        ),
        Padding(
          padding: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 30),
          child: txtUserEmail,
        ),
      ],
    );

    final viewUserBg = Container(
      // height: constDeviceType == 1
      //     ? MediaQuery.of(context).orientation == Orientation.landscape
      //     ? (MediaQuery.of(context).size.height * 0.7)
      //     : (MediaQuery.of(context).size.height / 2) - 60
      //     : (MediaQuery.of(context).size.height / 2) - 60,
      // decoration: BoxDecoration(
      // image: DecorationImage(
      //   image: AssetImage(img_menu_bg),
      //   fit: BoxFit.cover,
      // ),
      // ),
      color: color_cybersquare_red,
      child: columnUserDetails,
    );

    final listviewBuilder = ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: listSideMenu.length,
      padding: EdgeInsets.all(0),
      itemBuilder: (BuildContext context, int index) {
        return setupMenuItems(index, 2);
      },
    );

    final mainColumn = ListView(
      padding: EdgeInsets.all(0.0),
      children: [
        viewUserBg,
        setupMenuItems(1, 1),
        listviewBuilder,
      ],
    );
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: constDeviceType == 1
          ? MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.75
              : MediaQuery.of(context).size.width * 0.50
          : MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.45
              : MediaQuery.of(context).size.width * 0.35,
      child: Drawer(
        child: mainColumn,
      ),
    );
  }

  Widget setupMenuItems(int itemIndex, int status) {
    final prov = Provider.of<courseProvider>(context, listen: false);
    //status: 1-> Dashboard, 2-> Others,, 4 -> Logout
    // 3-> Settings
    String strTitle = "";
    String strPath = "";
    String strSubPath = "";
    String tileIcon = img_menu_icon;
    if (status == 1) {
      strTitle = str_side_menu_1;
    } else if (status == 3) {
      strTitle = str_side_menu_18;
    } else if (status == 4) {
      strTitle = str_side_menu_19;
    } else {
      strTitle = listSideMenu[itemIndex].menuName ?? "";

      if (strTitle.toUpperCase() == "MY COURSES" ||
          strTitle.toUpperCase() == "EXAMS") {
        strPath = listSideMenu[itemIndex].menuName ?? "";
      } else {
        if (listSideMenu[itemIndex].actions != null) {
          if (listSideMenu[itemIndex].actions!.isNotEmpty) {
            strPath = listSideMenu[itemIndex].actions![0].stateName ?? "";
            if (strPath == state_program_game) {
              strSubPath = listSideMenu[itemIndex].params != null
                  ? listSideMenu[itemIndex].params!.game ?? ""
                  : "";
            }
          } else {
            strPath = listSideMenu[itemIndex].menuName ?? "";
          }
        } else {
          strPath = listSideMenu[itemIndex].menuName ?? "";
        }
      }
    }

    IconData? ic = getIcon(strTitle, strPath, strSubPath);
    final itemRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 25),
          child: SizedBox(
            height: 16,
            width: 16,
            child: ic == null
                ? Container()
                : FaIcon(
                    ic,
                    size: 16,
                    color: prov.menuIndex == itemIndex &&
                                strTitle != "Dashboard" ||
                            prov.menuIndex == 100 && strTitle == "Dashboard" ||
                            prov.menuIndex == 101 && strTitle == "My Courses" ||
                            prov.menuIndex == 102 && strTitle == "CS Lab"
                        ? color_cybersquare_red
                        : Colors.black45,
                  ),
            // Image.asset(
            //   tileIcon,
            //   fit: BoxFit.contain,
            // ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              strTitle,
              textAlign: TextAlign.left,
              style: GoogleFonts.getFont(
                globalFontName,
                color: prov.menuIndex == itemIndex && strTitle != "Dashboard" ||
                        prov.menuIndex == 100 && strTitle == "Dashboard" ||
                        prov.menuIndex == 101 && strTitle == "My Courses" ||
                        prov.menuIndex == 102 && strTitle == "CS Lab"
                    ? color_cybersquare_red
                    : color_login_text_black,
                fontSize: 16,
                // fontFamily: FONT_AVENIR_ROMAN,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.42,
              ),
            ),
          ),
        ),
      ],
    );

    final itemAction = InkWell(
      child: Padding(
        padding: EdgeInsets.only(
            top: status == 1 ? 25 : 16, bottom: (status == 4) ? 25 : 16),
        child: itemRow,
      ),
      onTap: () {
        Scaffold.of(context).closeDrawer();
        if (strTitle == "Dashboard") {
          prov.setmenuIndex(100);
        } else if (strTitle == "My Courses") {
          prov.setmenuIndex(101);
        } else if (strTitle == "CS Lab") {
          prov.setmenuIndex(102);
        } else {
          prov.setmenuIndex(itemIndex);
        }
        sideMenuAction(strTitle, strPath, strSubPath);
      },
    );

    return Container(
      child: itemAction,
    );
  }

  IconData? getIcon(String strTitle, String strPath, String strSubPath) {
    if (strTitle == "Dashboard") {
      return FontAwesomeIcons.house;
    } else if (strPath.toUpperCase() == "MY COURSES") {
      return FontAwesomeIcons.graduationCap;
    } else if (strPath.toUpperCase() == "EXAMS") {
      return FontAwesomeIcons.clipboard;
    } else if (strPath == state_profile) {
      return FontAwesomeIcons.user;
    } else if (strPath == state_live_classroom) {
      return FontAwesomeIcons.desktop;
    } else if (strPath == state_my_activities) {
      return FontAwesomeIcons.listCheck;
    } else if (strPath == state_scoreCard) {
      return FontAwesomeIcons.book;
    } else if (strPath == state_progress_report) {
      return FontAwesomeIcons.chartLine;
    } else if (strPath == state_projects) {
      return FontAwesomeIcons.briefcase;
    } else if (strPath == state_academic_profile) {
      return FontAwesomeIcons.chartArea;
    } else if (strPath == state_digital_fest) {
      return FontAwesomeIcons.ticketSimple;
    } else if (strPath == state_cslab) {
      return FontAwesomeIcons.terminal;
    } else if (strPath == state_program_game) {
      if (strSubPath == state_param_visual_coding_jr) {
        return FontAwesomeIcons.github;
      } else if (strSubPath == state_param_app_inventor) {
        return FontAwesomeIcons.tabletScreenButton;
      } else if (strSubPath == state_param_geeky_bird) {
        return FontAwesomeIcons.gamepad;
      } else if (strSubPath == state_param_geeky_bird_programable) {
        return FontAwesomeIcons.gamepad;
      } else if (strTitle.toUpperCase() == "GAMES") {
        return FontAwesomeIcons.gamepad;
      } else if (strSubPath == "") {
        return FontAwesomeIcons.github;
      }
    } else if (strTitle.toUpperCase() == "TRAINING SESSIONS") {
      return FontAwesomeIcons.calendarDays;
    } else if (strTitle.toUpperCase() == "LMS IDE") {
      return FontAwesomeIcons.creditCard;
    } else if (strTitle.toUpperCase().contains("WEB HOSTING")) {
      return FontAwesomeIcons.earthAmericas;
    }
    return null;
  }

  sideMenuAction(String strTitle, String strPath, String strSubPath) {
    //Dashboard
    // My Courses
    // Live Class Room
    // Exams
    // My Activities
    // Scorecard
    // Progress report
    // Visual Coding 2.0
    // Visual Coding 2.0 Junior
    // MIT app inventor
    // Geeky bird game
    // Geeky bird programmable
    // Games
    // Projects
    // Lms IDE
    // Academic profile
    // Digital Fest
    //Logout

    if (strTitle == "Dashboard") {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => DashboardScreen(avatar: Userlogo),
        ),
      );
    } else if (strPath.toUpperCase() == "MY COURSES") {
      // Navigator.pushReplacement<void, void>(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) => CoursesListScreen(
      //       screenStatus: 1,
      //       strTitle: strTitle,
      //       avatar: logo,
      //     ),
      //   ),
      // );
    } else if (strPath.toUpperCase() == "EXAMS") {
      // Navigator.pushReplacement<void, void>(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) => CoursesListScreen(
      //       screenStatus: 2,
      //       strTitle: strTitle,
      //       avatar: logo,
      //     ),
      //   ),
      // );
    } else if (strPath == state_profile) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (BuildContext context) =>
      //         ProfileScreen(strTitle, widget.avatar),
      //   ),
      // );
    } else if (strPath == state_live_classroom) {
      // Navigator.pushReplacement<void, void>(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) => LiveClassroomScreen(
      //       strTitle: strTitle,
      //       avatar: logo,
      //     ),
      //   ),
      // );
    } else if (strPath == state_my_activities) {
      // Navigator.pushReplacement<void, void>(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) => MyActivitiesScreen(strTitle, logo),
      //   ),
      // );
    } else if (strPath == state_scoreCard) {
      // Navigator.pushReplacement<void, void>(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) => ScorecardScreen(strTitle, logo),
      //   ),
      // );
    } else if (strPath == state_progress_report) {
      // Navigator.pushReplacement<void, void>(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) => ProgressReportScreen(
      //       strTitle: strTitle,
      //     ),
      //   ),
      // );
    } else if (strPath == state_projects) {
      // Navigator.pushReplacement<void, void>(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) => ProjectsListScreen(
      //       strTitle: strTitle,
      //       avatar: logo,
      //     ),
      //   ),
      // );
    } else if (strPath == state_academic_profile) {
      // Navigator.pushReplacement<void, void>(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) =>
      //         AcademicProfileScreen(strTitle, logo),
      //   ),
      // );
    } else if (strPath == state_digital_fest) {
      // Navigator.pushReplacement<void, void>(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) => DigitalFestScreen(
      //       strTitle: strTitle,
      //       avatar: logo,
      //     ),
      //   ),
      // );
    } else if (strPath == state_cslab) {
      Orientation currentOrientation = MediaQuery.of(context).orientation;
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) {
      //         return WebViewScreen(
      //           strUrl: url_cslab + constUserToken,
      //           strTitle: strTitle,
      //           screenStatus: 2,
      //           currentOrientation: currentOrientation,
      //           onSubmitBtnPressed: (int stat) {
      //             enableRotation();
      //           },
      //         );
      //       },
      //       fullscreenDialog: true),
      // );
    } else if (strPath == state_program_game) {
      if (strSubPath == state_param_visual_coding_jr) {
        Orientation currentOrientation = MediaQuery.of(context).orientation;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) {
        //         return WebViewScreen(
        //           strUrl: url_visual_coding_jr,
        //           strTitle: strTitle,
        //           screenStatus: 1,
        //           currentOrientation: currentOrientation,
        //           onSubmitBtnPressed: (int stat) {
        //             enableRotation();
        //           },
        //         );
        //       },
        //       fullscreenDialog: true),
        // );
      } else if (strSubPath == state_param_app_inventor) {
        Orientation currentOrientation = MediaQuery.of(context).orientation;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) {
        //         return WebViewScreen(
        //           strUrl: url_app_inventor,
        //           strTitle: strTitle,
        //           screenStatus: 1,
        //           currentOrientation: currentOrientation,
        //           onSubmitBtnPressed: (int stat) {
        //             enableRotation();
        //           },
        //         );
        //       },
        //       fullscreenDialog: true),
        // );
      } else if (strSubPath == state_param_geeky_bird) {
        Orientation currentOrientation = MediaQuery.of(context).orientation;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) {
        //         return WebViewScreen(
        //           strUrl: url_geeky_bird,
        //           strTitle: strTitle,
        //           screenStatus: 1,
        //           currentOrientation: currentOrientation,
        //           onSubmitBtnPressed: (int stat) {
        //             enableRotation();
        //           },
        //         );
        //       },
        //       fullscreenDialog: true,),
        // );
      } else if (strSubPath == state_param_geeky_bird_programable) {
        Orientation currentOrientation = MediaQuery.of(context).orientation;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) {
        //         return WebViewScreen(
        //           strUrl: url_geeky_bird_programable,
        //           strTitle: strTitle,
        //           screenStatus: 1,
        //           currentOrientation: currentOrientation,
        //           onSubmitBtnPressed: (int stat) {
        //             enableRotation();
        //           },
        //         );
        //       },
        //       fullscreenDialog: true),
        // );
      } else if (strTitle == "Games") {
        Orientation currentOrientation = MediaQuery.of(context).orientation;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) {
        //         return WebViewScreen(
        //           strUrl: url_code_combat,
        //           strTitle: strTitle,
        //           screenStatus: 1,
        //           currentOrientation: currentOrientation,
        //           onSubmitBtnPressed: (int stat) {
        //             enableRotation();
        //           },
        //         );
        //       },
        //       fullscreenDialog: true),
        // );
      } else if (strSubPath == "") {
        Orientation currentOrientation = MediaQuery.of(context).orientation;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) {
        //         return WebViewScreen(
        //           strUrl: url_visual_coding,
        //           strTitle: strTitle,
        //           screenStatus: 1,
        //           currentOrientation: currentOrientation,
        //           onSubmitBtnPressed: (int stat) {
        //             enableRotation();
        //           },
        //         );
        //       },
        //       fullscreenDialog: true),
        // );
      }
    } else if (strTitle.toUpperCase() == "TRAINING SESSIONS") {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => TrainingSessionsScreen(
      //             strTitle: 'Training Sessions',
      //           )),
      // );
    } else if (strTitle.toUpperCase() == "LMS IDE") {
    } else if (strTitle.toUpperCase() == "WEB HOSTING") {
      // showAlertWithMessage(
      //   context,
      //   "This feature is compatible with Desktop only",
      // );
    }
  }

  // void showAlertLogout(String strMsg) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     barrierColor: Colors.black.withOpacity(0.3),
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       content: Text(strMsg),
  //       actions: [
  //         CupertinoDialogAction(
  //           child: const Text("No"),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //         CupertinoDialogAction(
  //           child: const Text("Yes"),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             // saveLoginData("");
  //             // saveLoginStatus(0);
  //             // saveToken("");

  //             constLoginData = {};
  //             constLoginStatus = 0;
  //             constUserToken = "";

  //             Navigator.pushReplacement<void, void>(
  //               context,
  //               MaterialPageRoute<void>(
  //                 builder: (BuildContext context) => LoginScreen(),
  //               ),
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
