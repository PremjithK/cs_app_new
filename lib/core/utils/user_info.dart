import 'package:cybersquare/core/constants/user_details.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';


Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

//**************** LOGIN STATUS **************************
Future<File> get _localFileForLoginStatus async {
  final path = await _localPath;
  return File('$path/loginStatus.txt');
}

Future<int> readLoginStatus() async {
  try {
    final file = await _localFileForLoginStatus;

    // Read the file
    String contents = await file.readAsString();
    int logStat = int.parse(contents);
    String str = await loadLoginData();
    if (logStat == 1) {
      if (str != "") {
        Map<String, dynamic> data = json.decode(str);
      }
    }
    return logStat;
  } catch (e) {
    // If encountering an error, return 0
    return 0;
  }
}

getUserActualName(Map<String, dynamic> loginData) {
  if (loginData["active_user_data"] != null) {
    constActualUserName = loginData["active_user_data"]["username"]??'';
  }else if(loginData["ActiveUserData"] != null){
    constActualUserName = loginData["ActiveUserData"]["username"]??'';
  }

}

getroleName(Map<String, dynamic> loginData) {
  if (loginData["active_user_data"] != null) {
    constRoleName = loginData["active_user_data"]["fkRoleName"]??'';
  }else if(loginData['fkRoleIds'] != null){
    if (loginData['fkRoleIds'].isNotEmpty) {
      constRoleName = loginData["fkRoleIds"][0]["roleName"]??'';
    }
  }

}

getUserRoleMappingID(Map<String, dynamic> loginData) {
  if (loginData["active_user_data"] != null) {
    constRoleMappingId = loginData["active_user_data"]["roleMappingId"]??'';
  }
}

getUserLogo(Map<String, dynamic> loginData) {
  // Login value = Login.fromJson(loginData);
  if(loginData["active_user_data"] != null) {
    Userlogo = loginData["active_user_data"]["avatar"] ?? "";
  }else{
    Userlogo = "";
  }
}

getCurrentAcademicYearID(Map<String, dynamic> loginData) {
  if (loginData["companyDetails"]["companySettings"] != null) {
    Map<String, dynamic> tempCompanySettings = loginData["companyDetails"]["companySettings"];
    if(tempCompanySettings.containsKey("currentAcademicYear")) {
      constCurrentAcademicYearId =
          loginData["companyDetails"]["companySettings"]["currentAcademicYear"] ?? "";
    }
    else {
      constCurrentAcademicYearId = "";
    }
  }
}

getCompanyIDFromActiveUserData(Map<String, dynamic> loginData) {
  if (loginData["active_user_data"] != null) {
    if (loginData["active_user_data"]["childCompanyId"] != null) {
      constCompanyID = loginData["active_user_data"]["childCompanyId"];
    } else {
      constCompanyID = loginData["active_user_data"]["companyId"];
    }
    constMainCompanyID = loginData["active_user_data"]["companyId"];
  }
}

getCompanyIDFromCompanySettings(Map<String, dynamic> loginData) {
  if (loginData["companyDetails"]["companySettings"] != null) {
    if (loginData["companyDetails"]["companySettings"]["childCompanyId"] != null &&
        loginData["companyDetails"]["companySettings"]["childCompanyId"] != "") {
      constCompanyID = loginData["companyDetails"]["companySettings"]["childCompanyId"];
    }
    else {
      constCompanyID = loginData["companyDetails"]["companySettings"]["companyId"];
    }
      constMainCompanyID = loginData["companyDetails"]["companySettings"]["companyId"];
  }
}


saveLoginStatus(int loginStatus) async {
  final file = await _localFileForLoginStatus;

  // Write the file
  file.writeAsString('$loginStatus');
}

//**************** LOGIN DATA **************************
Future<File> get _localFileForLoginData async {
  final path = await _localPath;
  final file = File('$path/loginData.txt');

  // Check if the file exists, if not, create it
  if (!(await file.exists())) {
    try {
      await file.create(recursive: true); // Creates the file and necessary directories
      // You can add initial content to the file if needed
      // await file.writeAsString('Initial content');
    } catch (e) {
      throw e; // Throw the error to handle it at a higher level
    }
  }

  return file;
}

Future<String> loadLoginData() async {
  try {
    final file = await _localFileForLoginData;

    // Read the file
    String contents = await file.readAsString();
    return contents;
  } catch (e) {
    // If encountering an error, return 0
    return "";
  }
}

saveLoginData(var loginData) async {
  final file = await _localFileForLoginData;
  String currentContent = await file.readAsString();
  String strJson = "";
  if (loginData != "") {
     if (currentContent != "") {
       Map<String, dynamic> newmap = json.decode(currentContent);
       newmap.addAll(loginData);
       strJson = jsonEncode(newmap);
       file.writeAsString(strJson);
     }else{
      strJson = jsonEncode(loginData);
      file.writeAsString(strJson);
     }
  }else{
    file.writeAsString(strJson);
  }
}

//**************** TOKEN **************************
Future<File> get _localFileForToken async {
  final path = await _localPath;
  return File('$path/loginToken.txt');
}

Future<String> loadToken() async {
  try {
    final file = await _localFileForToken;

    // Read the file
    String contents = await file.readAsString();

    return contents;
  } catch (e) {
    // If encountering an error, return 0
    return "";
  }
}

saveToken(String token) async {
  final file = await _localFileForToken;

  // Write the file
  file.writeAsString(token);
}

void landscapeModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

void portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

void enableRotation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);
}