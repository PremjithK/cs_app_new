import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cybersquare/core/constants/api_endpoints.dart';
import 'package:cybersquare/core/constants/colors.dart';
import 'package:cybersquare/core/constants/const_strings.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:cybersquare/core/services/api_services.dart';
import 'package:cybersquare/core/utils/common_functions.dart';
import 'package:cybersquare/data/models/course_progress_model.dart';
import 'package:cybersquare/globals.dart';
import 'package:cybersquare/presentation/widgets/exception_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

Color courseCompleteColor = const Color(0xff56c8c0);
Color courseIncompleteColor = const Color(0xffec548d);
Color progressBgColor = const Color(0xfff1f2f3);

class CourseProgressDialog extends StatefulWidget {
  const CourseProgressDialog({super.key});

  @override
  State<CourseProgressDialog> createState() => _CourseProgressDialogState();
}

class _CourseProgressDialogState extends State<CourseProgressDialog> {
  List<CourseProgressModel> progressList = [];
  bool isDataNotLoaded = true;
  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isDataNotLoaded = true;
    // initConnectivity();
    // _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    // if (_connectivitySubscription != null) {
    //   _connectivitySubscription.cancel();
    // }
    super.dispose();
  }

  // Future<void> initConnectivity() async {
  // ConnectivityResult result = ConnectivityResult.none;
  // try {
  // result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //   }
  //   if (!mounted) {
  //     return Future.value(null);
  //   }
  //   return _updateConnectionStatus(result);
  // }

  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   switch (result) {
  //     case ConnectivityResult.wifi:
  //       setState(() {
  //         constIsConnectedToInternet = true;
  //       });
  //       break;
  //     case ConnectivityResult.mobile:
  //       setState(() {
  //         constIsConnectedToInternet = true;
  //       });
  //       break;
  //     case ConnectivityResult.none:
  //       setState(() {
  //         constIsConnectedToInternet = false;
  //       });
  //       break;
  //     default:
  //       setState(() {
  //         constIsConnectedToInternet = false;
  //       });
  //       break;
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: isDataNotLoaded
          ? constIsConnectedToInternet
              ? courseProgressApi()
              : setupExceptionView(str_no_network_msg)
          : mainUi(context),
    );
  }

  Widget mainUi(context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customText("Course Progress", title: true),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  color: color_text,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: color_login_border_gray,
          ),
          progressList.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: progressList.length,
                    itemBuilder: (context, index) {
                      int matCount = progressList[index].materialCount == 0
                          ? 1
                          : progressList[index].materialCount ?? 0;
                      int subCount = progressList[index].submittedCount ?? 0;
                      double progress = subCount / matCount * 100;
                      String name = progressList[index].name ?? "";
                      return progressItem(name, progress);
                    },
                  ),
                )
              : setupEmptyView(str_no_data_found)
        ],
      ),
    );
  }

  Widget customText(text, {title = false}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.getFont(
          globalFontName,
          color: title ? Colors.black : color_text,
          fontSize: title ? 18 : 13,
          fontWeight: title ? FontWeight.w700 : FontWeight.w500,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget progressItem(label, num progress) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: customText(label),
            ),
            customText("${progress.toStringAsFixed(2)}%"),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation(
              progress == 100 ? courseCompleteColor : courseIncompleteColor),
          value: double.parse(progress.toStringAsFixed(2)) / 100,
          backgroundColor: progressBgColor,
          minHeight: 10,
        ),
      ],
    );
  }

  Widget courseProgressApi() {
    String strUrl = url_base2 + url_course_progress;
    var postData = {
      "companyId": constCompanyID,
      "userLoginId": constLoginUserId,
    };

    var headerData = {
      'authorization': constUserToken,
    };

    return FutureBuilder<Response>(
      future: postMethodApi(postData, strUrl, headerData),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return setupExceptionView(str_some_error_occurred_msg);
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          try {
            Response response = snapshot.data!;
            final data = jsonDecode(response.body);
            if (response.statusCode == 200) {
              if (data['statusCode'] != null &&
                  data["statusCode"] == 403 &&
                  data['forceLogout'] != null &&
                  data["forceLogout"] == true) {
                // return logoutUser(context, 1);
              } else if (data['statusCode'] != null &&
                  data['statusCode'] == 200) {
                List<dynamic> model = data['courses'];
                log(data['courses'].toString());
                progressList =
                    model.map((e) => CourseProgressModel.fromJson(e)).toList();
                isDataNotLoaded = false;
                return mainUi(context);
              } else {
                return setupExceptionView(str_some_error_occurred_msg);
              }
            } else {
              return setupExceptionView(str_some_error_occurred_msg);
            }
          } on SocketException catch (_) {
            return setupExceptionView(str_no_network_msg);
          } on TimeoutException catch (_) {
            return setupExceptionView(str_connection_timeout);
          }
          return const SizedBox();
        } else {
          return Loading(true);
        }
      },
    );
  }
}
