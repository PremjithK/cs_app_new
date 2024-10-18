// ignore_for_file: non_constant_identifier_names

import 'package:cybersquare/data/models/academic_year_list_model.dart';
import 'package:cybersquare/data/models/side_menu_model.dart';
import 'package:flutter/material.dart';

String PlatformOs="";
int constDeviceType = 1;//1 --> phone, 2 --> tablet
bool constIsConnectedToInternet = true;
bool isTablet = false;

List<RegionMenuStructure> listSideMenu = [];
List<AcademicYear> constListAcademicYearData = [];

int constLoginStatus = 0;
String constUserToken = "";
Map<String, dynamic> constLoginData = {};
String institute="";
String constaccesstoken = "";
String companyIDforForgotpassword = "";
String userLoginIdforgotpass = "";
String constCompanyID = "";
String constcompanyName = "";
String constMainCompanyID = "";
String constCurrentAcademicYearId = "";
String constLoginUserId = "";
String constRoleMappingId = "";
String Userlogo = "";
String constActualUserName = "";
String constRoleName = "";
Color? syllabusclr;
String? objstatus;
String? objstatus1;
String Status = "";
String Coursemapid = "";
int Reload =0;
List mobile_list = [];
List email_list = [];