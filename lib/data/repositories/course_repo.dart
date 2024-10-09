import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cybersquare/core/constants/api_endpoints.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:cybersquare/core/services/api_services.dart';
import 'package:cybersquare/logic/providers/course_detail_screen_provider.dart';
import 'package:cybersquare/presentation/ui/login/newscreen.dart';
import 'package:provider/provider.dart';

loadCoursesForCandidatesApi(BuildContext ctx) async{
    // final prov = Provider.of<courseProvider>(ctx,listen: false);
      String strUrl = url_base2 + url_courses_list;

      var postData = {
            "userLoginId": constLoginUserId,
            "companyId": constCompanyID,
            "requestFromBatchProgressCandidateSide": ""
          };

      var headerData = {
      "Content-Type": "application/json; charset=UTF-8",
      "authorization": constUserToken,
      };

      try {
        final prov = Provider.of<courseProvider>(ctx, listen: false);
        final response = await postMethodApi(postData, strUrl, headerData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> data = json.decode(response.body);
          // Map<String, dynamic> data = json.decode(decodedData);
          if (data["courseObj"].isEmpty) {
            prov.setmenuIndex(102); //102 is set for cs lab
            Orientation currentOrientation = MediaQuery.of(ctx).orientation;
            Navigator.push(
              ctx,
              MaterialPageRoute(
                  builder: (context) {
                    return const newscreen();
                    // WebViewScreen(
                    //   strUrl: url_cslab+constUserToken,
                    //   strTitle: 'CS Lab',
                    //   screenStatus: 2,
                    //   currentOrientation: currentOrientation,
                    //   onSubmitBtnPressed: (int stat) {
                    //     enableRotation();
                    //   },
                    // );
                  },
                  fullscreenDialog: true),
            );
          }else{
            prov.setmenuIndex(101); //101 is set for course screen
            Navigator.pushReplacement<void, void>(
            ctx,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const newscreen(),
              // CoursesListScreen(screenStatus: 1,strTitle: "",avatar: Userlogo,)
            ),
          );
          }

        }
      } on SocketException catch (_) {

        // showAlert(ctx,str_some_error_occurred_msg);
      
      } on TimeoutException catch (_) {

        // showAlert(ctx,connection_time_out);
      
      }
  }