import 'package:cybersquare/presentation/ui/login/newscreen.dart';
import 'package:cybersquare/presentation/ui/login/webscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:cybersquare/data/repositories/course_repo.dart';
import 'package:cybersquare/presentation/ui/login/login_screen.dart';
import 'package:cybersquare/core/utils/user_info.dart';
import 'package:upgrader/upgrader.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.upgrader}) : super(key: key);
  final Upgrader upgrader;
  
  // This widget is the root of your application.
  bool courseEmpty= false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: Color(0xffFEF8F8)
      ),
      title: 'Cyber Square',
      routes: {
        // LoginScreen.routeName: (context) => LoginScreen(),
        // CoursesListScreen.routeName: (context) => CoursesListScreen(avatar: "",),
      },
        home: UpgradeAlert(
        showIgnore: false,
        showReleaseNotes: false,
        dialogStyle: UpgradeDialogStyle.cupertino,
        cupertinoButtonTextStyle: const TextStyle(
          fontSize: 14,
          // color: color_cybersquare_red,
        ),
        upgrader: upgrader,
        child: FutureBuilder<int>(
          future: readLoginStatus(),
          builder: (context, snapshot) {
            double ratio = MediaQuery.of(context).size.width /
                MediaQuery.of(context).size.height;
            if ((ratio >= 0.65) && (ratio < 1.5)) {
              isTablet = true;
              constDeviceType = 2;
            } else {
              isTablet = false;
              constDeviceType = 1;
            }
            if (isTablet) {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
                DeviceOrientation.portraitUp,
                // DeviceOrientation.portraitDown,
              ]);
            } else {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
                DeviceOrientation.portraitUp,
                // DeviceOrientation.portraitDown,
              ]);
            }
        
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              constLoginStatus = snapshot.data ?? 0;
              if (constLoginStatus == 1) {

                if(constUserToken != "" && constLoginData.isNotEmpty) {
                  // return loadCoursesForCandidatesApi(context);
                  return FutureBuilder(
                    future: loadCoursesForCandidatesApi(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return LoginScreen();
                        }
                        if (snapshot.data == true) {
                          // snapshot data true means there is course available for the student, so show the course list screen
                          Orientation currentOrientation = MediaQuery.of(context).orientation;
                          return newscreen1();
                          
                        } else {
                          return newscreen();
                          // WebViewScreen(
                          //           strUrl: url_cslab+constUserToken,
                          //           strTitle: 'CS Lab',
                          //           screenStatus: 2,
                          //           currentOrientation: currentOrientation,
                          //           onSubmitBtnPressed: (int stat) {
                          //             enableRotation();
                          //           },
                          //         );
                        }
                      } else {
                        return newscreen();
                        // WebViewScreen(
                          //           strUrl: url_cslab+constUserToken,
                          //           strTitle: 'CS Lab',
                          //           screenStatus: 2,
                          //           currentOrientation: currentOrientation,
                          //           onSubmitBtnPressed: (int stat) {
                          //             enableRotation();
                          //           },
                          //         );
                      }
                    },
                  );
                }
                else {
                  return const LoginScreen();
                }
              } else {
                return const LoginScreen();
              }
            } else {
              return Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
              );
            }
          },
        ),
      ),
      //MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
  
}