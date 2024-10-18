import 'dart:convert';
import 'dart:io';
import 'package:cybersquare/data/models/login_domain_model.dart';
import 'package:cybersquare/logic/blocs/login/login_bloc.dart';
import 'package:cybersquare/logic/providers/forgotpassword_model.dart';
import 'package:cybersquare/presentation/ui/dashboard/dashboard_screen.dart';
import 'package:cybersquare/presentation/ui/login/newscreen.dart';
import 'package:cybersquare/presentation/ui/login/qr_scanner_screen.dart';
import 'package:cybersquare/presentation/ui/login/webscreen.dart';
import 'package:flutter/material.dart';
import 'package:cybersquare/core/constants/api_endpoints.dart';
import 'package:cybersquare/core/constants/const_strings.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:cybersquare/core/services/analytics.dart';
import 'package:cybersquare/core/services/api_services.dart';
import 'package:cybersquare/core/utils/common_functions.dart';
import 'package:cybersquare/core/utils/user_info.dart';
import 'package:cybersquare/data/repositories/course_repo.dart';
import 'package:cybersquare/logic/providers/course_detail_screen_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

companysettingsApi() async {
  if (constIsConnectedToInternet) {
    String strUrl = '${url_base2}company/$constCompanyID';

    final response = await getMethodApi(strUrl);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data["companyDetails"] != null) {
        constLoginData.addAll(data);
        saveLoginStatus(1);
        // saveUserLogo(constLoginData);
        getUserLogo(constLoginData);
        // saveconstCompanyID(constLoginData);
        getCompanyIDFromActiveUserData(constLoginData);
        // saveconstCurrentAcademicYearId(constLoginData);
        getCurrentAcademicYearID(constLoginData);
        // String strJson = jsonEncode(data);
        saveLoginData(data);
      }
    } else {
      throw Exception(response.body);
    }
  }
}

loginaccestokenApi(
    {required BuildContext context,
    required String username,
    required String password}) async {
  //postmethodapi with status code 200 , 400 and 500
  if (constIsConnectedToInternet) {
    String strUrl = '${url_identity_service}login';
    Platform.isAndroid ? PlatformOs = "android" : PlatformOs = "ios";

    var postData = {
      "company_id": constCompanyID,
      "password": password,
      "username": username,
      "os": PlatformOs,
      "from": "Mobile"
    };

    var headerData = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final prov = Provider.of<courseProvider>(context, listen: false);
    final response = await postMethodApi(postData, strUrl, headerData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data["access_token"] != null) {
        constUserToken = data["access_token"];
        // saveAccessToken(data["access_token"]);
      }
      constLoginData.addAll(data);
      constLoginStatus = 1;
      constLoginUserId = constLoginData["active_user_data"]["userLoginId"];
      getUserRoleMappingID(constLoginData);
      await getUserActualName(constLoginData);
      await getroleName(constLoginData);
      saveLoginStatus(1);
      saveToken(constUserToken);
      saveLoginData(data);
      bool courseEmpty = await loadCoursesForCandidatesApi(context);
      getUserLogo(constLoginData);
      if (courseEmpty == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) {
                return DashboardScreen(avatar: Userlogo,);
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
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) {
                return DashboardScreen(avatar: Userlogo,);
                // CoursesListScreen(screenStatus: 1,strTitle: "",avatar: Userlogo,);
              },
              fullscreenDialog: true),
        );
      }
      AnalyticsService.logLoginEvent(
          loginid: constLoginUserId,
          userName: constActualUserName,
          roleName: constRoleName,
          companyId: constCompanyID,
          companyName: constcompanyName,
          status: 'login_successful');
      // context.read<LoginBloc>().add(LoginInitialEvent());
      // setState(() {
      //   isLoading = false;
      // });
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      AnalyticsService.logLoginEvent(status: 'login_failed');
      showAlert(context: context, strMsg: data["message"]);
    }
  } else {
    showAlert(context: context, strMsg: str_no_network_msg);
  }
}

loadUserProfileDetailsApi(
  BuildContext context,
) async {
  if (constIsConnectedToInternet) {
    String strUrl = url_base2 + url_scorecard;
    var postData = {
      // "academicYearId":"6421e0cfd0d7c86398c7e0f3",
      "userLoginId": constLoginUserId,
      "type": "detailed",
    };
    var headerData = {
      'authorization': constUserToken,
    };

    final response = await postMethodApi(postData, strUrl, headerData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data["userDetails"] != null) {
        if (data["userDetails"]["profile"] != null) {
          if (data["userDetails"]["profile"]["userPic"] != null) {
            Userlogo = data["userDetails"]["profile"]["userPic"];
            constLoginData
                .addAll({"userPic": data["userDetails"]["profile"]["userPic"]});
            saveLoginData(constLoginData);
          }
        }
      }
    } else {
      throw Exception('Api call failed');
    }
  } else {
    showAlert(context: context, strMsg: str_no_network_msg);
  }
}

loadloguserdataApi(BuildContext context) async {
  //postmethodapi with status code 200 , 400 and 500
  if (constIsConnectedToInternet) {
    String strUrl = url_base2 + url_load_log_user_data;

    var postData = {"UserDataObjId": constLoginUserId};

    var headerData = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await postMethodApi(postData, strUrl, headerData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      String decodedData = json.decode(response.body);
      Map<String, dynamic> data = json.decode(decodedData);

      // add access_token key and constloginid value into constLoginData
      constLoginData.addAll(data);
      saveLoginData(constLoginData);
      getUserLogo(constLoginData);
    } else {
      throw Exception('Api call failed');
    }
  } else {
    showAlert(context: context, strMsg: str_no_network_msg);
  }
}

checkdomainApi(String domain, BuildContext context) async {
  String? extractSchoolName(String url) {
    final regex = RegExp(r'^(https?://)?([^/.]*)');
    final match = regex.firstMatch(url);
    return match != null ? match.group(2) : '';
  }

  String? schoolName = extractSchoolName(domain);

  // emit(LoadingState());
  // Perform the API call
  final postData = {
    'domainName': schoolName,
  };

  final header = {
    'Content-Type': 'application/json',
    'origin': isProduction
        ? 'https://${schoolName!}.cybersquare.org'
        : 'https://${schoolName!}.dev99lms.com'
  };

  final strUrl = url_base2 + url_checkdomain;
  final response = await postMethodApi(postData, strUrl, header);

  if (response.statusCode == 200 || response.statusCode == 201) {
    // Parse the response and emit success state
    final dynamic data = jsonDecode(response.body);
    final dynamic data1 = json.decode(data);
    final responseData = DomainValidation.fromJson(data1);
    if (responseData.result!.toUpperCase() != 'NEW') {
      if (responseData.parentCompanyId != null) {
        constMainCompanyID = responseData.parentCompanyId!.oid.toString();
      } else {
        constMainCompanyID = responseData.companyId!.oid.toString();
      }
      if (responseData.companyId != null) {
        constCompanyID = responseData.companyId!.oid.toString();
        constcompanyName = responseData.companyName.toString();
        // emit(OtpDomainValid());
      }
    } else {
      constCompanyID = '';
      constMainCompanyID = '';
      throw Exception('Invalid Domain');
    }
  } else {
    throw Exception('Invalid Domain');
  }
}

loginQrApi(String qrcodeData, BuildContext context) async {
  //postmethodapi with status code 200 , 400 and 500
  if (constIsConnectedToInternet) {
    String strUrl = "${url_identity_service}loginWithQrCode";
    Platform.isAndroid ? PlatformOs = "android" : PlatformOs = "ios";

    var postData = {
      "qrCodeLoginId": qrcodeData,
      "os": PlatformOs,
      "from": "Mobile"
    };

    var headerData = {
      'Content-Type': 'application/json; charset=UTF-8',
      "authorization": constUserToken,
    };

    final response = await postMethodApi(postData, strUrl, headerData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = json.decode(response.body);
      constUserToken = data["access_token"];
      constLoginData.addAll(data);
      constLoginStatus = 1;
      constLoginUserId = constLoginData["active_user_data"]["userLoginId"];
      getUserRoleMappingID(constLoginData);
      await getUserActualName(constLoginData);
      getCompanyIDFromActiveUserData(constLoginData);
      await getroleName(constLoginData);
      getUserLogo(constLoginData);
      saveLoginStatus(1);
      saveToken(constUserToken);
      saveLoginData(data);
      bool isCourseAvailable = await loadCoursesForCandidatesApi(context);
      await companysettingsApi();
      if (isCourseAvailable == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) {
                return  DashboardScreen(avatar: Userlogo,);
                // CoursesListScreen(screenStatus: 1,strTitle: "",avatar: Userlogo,);
              },
              fullscreenDialog: true),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) {
                return  DashboardScreen(avatar: Userlogo,);
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
      }
      AnalyticsService.logLoginEvent(
          loginid: constLoginUserId,
          userName: constActualUserName,
          roleName: constRoleName,
          companyId: constCompanyID,
          companyName: constcompanyName,
          status: 'login_successful');
    } else {
      QRscanner.isScanning.value = false;
      AnalyticsService.logLoginEvent(status: 'login_failed');
      showAlert(context: context, strMsg: "Invalid QR Code");
    }
  } else {
    QRscanner.isScanning.value = false;
    showAlert(context: context, strMsg: str_no_network_msg);
  }
}

// FORGOT PASSWORD API'S

forgotPasswordDetailsApi(BuildContext context, String username) async {
  FocusScope.of(context).unfocus();
  if (constIsConnectedToInternet) {
    String strUrl = url_identity_service + url_forgot_password;

    // setState(() {
    //   isLoading = true;
    // });

    var postData = {"username": username, "company_id": constCompanyID};

    var headerData = {
      'Content-Type': 'application/json; charset=UTF-8',
      // 'Origin': http+url_origin,
    };

    final response = await postMethodApi(postData, strUrl, headerData);
    // setState(() {
    //   isLoading = false;
    // });
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (data["mobile_array"] != null || data["email_array"] != null) {
        if (data["mobile_array"] != null) {
          mobile_list.addAll(data["mobile_array"]);
        }
        if (data["email_array"] != null) {
          email_list.addAll(data["email_array"]);
        }
        constLoginUserId = data["user_login_id"];
        Provider.of<ForgotpswdProvider>(context, listen: false)
            .setotpEmailvalidated(true);
      } else {
        String strError = data["message"] ??
            "Sorry ! There is no contact information available to provide login";
        showAlert(context: context, strMsg: strError);
        throw Exception(strError);
      }
    } else {
      String strError = data["message"] ??
          "Sorry ! There is no contact information available to provide login";
      showAlert(context: context, strMsg: strError);
      throw Exception(strError);
    }
  } else {
    showAlert(context: context, strMsg: str_no_network_msg);
  }
}

sentOtpApi(BuildContext context) async {
  if (constIsConnectedToInternet) {
    String strUrl = url_identity_service + url_sent_otp;

    // setState(() {
    //   isLoading = true;
    // });

    var postData = {
      "userLoginId": constLoginUserId,
      "mobile_index_array":
          Provider.of<ForgotpswdProvider>(context, listen: false)
              .selectedmobileIndexes,
      "email_index_array":
          Provider.of<ForgotpswdProvider>(context, listen: false)
              .selectedemailIndexes,
      "company_id": constCompanyID
    };

    var headerData = {
      'Content-Type': 'application/json; charset=UTF-8',
      // 'Origin': http+url_origin,
    };

    final response = await postMethodApi(postData, strUrl, headerData);
    // setState(() {
    //   isLoading = false;
    // });
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Fluttertoast.showToast(
        msg: 'OTP successfully sent',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      String strError =
          data["message"] ?? "Failed to reset password, please try again later";
      showAlert(context: context, strMsg: strError);
    }
  } else {
    showAlert(context: context, strMsg: str_no_network_msg);
  }
}

validateOtpApi(BuildContext context, String otpEntered) async {
  if (constIsConnectedToInternet) {
    String strUrl = url_identity_service + url_otp_validation;

    // setState(() {
    //   isLoading = true;
    // });

    var postData = {
      "userLoginId": constLoginUserId,
      "otp": otpEntered,
      "company_id": constCompanyID
    };

    var headerData = {
      'Content-Type': 'application/json; charset=UTF-8',
      // 'Origin': http+url_origin,
    };

    final response = await postMethodApi(postData, strUrl, headerData);
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (data["access_token"] != null) {
        constUserToken = data["access_token"];
      }
    } else {
      String strError =
          data["message"] ?? "Failed to login, please try again later";
      showAlert(
        context: context,
        strMsg: strError,
      );
      throw Exception(strError);
    }
  } else {
    showAlert(context: context, strMsg: str_no_network_msg);
  }
}

loadloguserdatafotOtploginApi(BuildContext context) async {
  //postmethodapi with status code 200 , 400 and 500
  if (constIsConnectedToInternet) {
    String strUrl = url_base2 + url_load_log_user_data;

    var postData = {"UserDataObjId": constLoginUserId};

    var headerData = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await postMethodApi(postData, strUrl, headerData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      String decodedData = json.decode(response.body);
      Map<String, dynamic> data = json.decode(decodedData);

      // add access_token key and constloginid value into constLoginData
      constLoginData.addAll(data);
      constLoginData.addAll({"access_token": constUserToken});
      constLoginStatus = 1;
      constLoginUserId = constLoginData["userLoginId"];
      getUserRoleMappingID(constLoginData);
      await getUserActualName(constLoginData);
      await getroleName(constLoginData);
      saveLoginStatus(1);
      saveLoginData(constLoginData);
      bool isCourseAvailable = await loadCoursesForCandidatesApi(context);
      if (isCourseAvailable == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) {
                return  DashboardScreen(avatar: Userlogo,);
                // CoursesListScreen(screenStatus: 1,strTitle: "",avatar: Userlogo,);
              },
              fullscreenDialog: true),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) {
                return DashboardScreen(avatar: Userlogo,);
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
      }
      AnalyticsService.logLoginEvent(
          loginid: constLoginUserId,
          userName: constActualUserName,
          roleName: constRoleName,
          companyId: constCompanyID,
          companyName: constcompanyName,
          status: 'login_successful');
      context.read<LoginBloc>().add(LoginInitialEvent());
    } else {
      AnalyticsService.logLoginEvent(status: 'login_failed');
      showAlert(
          context: context, strMsg: "Failed to login, please try again later");
      throw Exception('Api call failed');
    }
  } else {
    showAlert(context: context, strMsg: str_no_network_msg);
  }
}
