// import 'dart:convert';
// import 'package:cybersquare/Common_Widgets/common_functions.dart';
// import 'package:cybersquare/Models/training_sessions_model.dart';
// import 'package:cybersquare/constants.dart';
// import 'package:cybersquare/server_connection.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class TrainingSessionsProvider extends ChangeNotifier {
//   late bool isLoading = false;

//   late String timeZone = '';

//   late Map<String, SessionDetail> _sessionData = <String, SessionDetail>{};
//   late List<DateTime> _sessionDates = <DateTime>[];
//   late List<SessionDetail> _sessionDetailList = <SessionDetail>[];

//   DateTime? startDate;
//   DateTime? endDate;

//   void setStartDate(BuildContext context, DateTime date) {
//     startDate = date;
//     notifyListeners();
//   }

//   void setEndDate(BuildContext context, DateTime date) {
//     if (startDate == null) {
//       showAlert(context, 'Please select the from date first');
//       return;
//     } else {
//       endDate = date;
//       notifyListeners();
//     }
//   }

//   void clearDateSelection() {
//     startDate = null;
//     endDate = null;
//     notifyListeners();
//   }

//   DateTime convertToDeviceTime(String date) {
//     DateTime gmtTime = DateTime.parse(date);

//     // Get the user's local time zone offset
//     var localOffset = DateTime.now().timeZoneOffset;

//     // Add the user's local time zone offset to the UTC DateTime
//     DateTime localNow = gmtTime.add(localOffset);

//     // Format the local DateTime as a string
//     return localNow;
//   }

//   Future<void> getTrainingSessions(BuildContext context) async {
//     isLoading = true;
//     notifyListeners();
//     timeZone = await getIanaTimeZone();

//     var payload = {
//       'companyId': constCompanyID,
//       'timeZone': timeZone,
//       'userId': constLoginUserId,
//     };

//     if (startDate != null) {
//       payload.addAll(
//         {
//           'scheduleStartTime': DateFormat('yyyy-MM-dd').format(startDate!),
//         },
//       );
//     }

//     if (endDate != null) {
//       payload.addAll(
//         {
//           'scheduleEndTime': DateFormat('yyyy-MM-dd').format(endDate!),
//         },
//       );
//     }

//     final headers = {
//       'authorization': constUserToken,
//     };

//     try {
//       final response = await getMethodApi(
//         url_base2 + url_load_training_sessions,
//         header: headers,
//         queryParams: payload,
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = TrainingSessionsModel.fromJson(jsonDecode(response.body));

//         if (data.statusCode == 201 || data.statusCode == 200) {
//           _sessionData = data.sessionDetails!;

//           // Mapping session dates to its own list
//           final List<String> dateList = _sessionData.keys.toList();
//           _sessionDates = dateList.map((date) {
//             return DateTime.parse(date);
//           }).toList();

//           _sessionDetailList = _sessionData.values.toList();

//           isLoading = false;
//           notifyListeners();
//         } else {
//           isLoading = false;
//           notifyListeners();
//           showAlert(context, str_some_error_occurred_msg);
//         }
//       } else {
//         isLoading = false;
//         notifyListeners();
//         showAlert(context, str_some_error_occurred_msg);
//       }
//     } catch (e) {
//       isLoading = false;
//       showAlert(context, str_some_error_occurred_msg);
//       notifyListeners();
//     }
//   }

//   Map<String, SessionDetail> get sessionData => _sessionData;

//   List<DateTime> get sessionDates => _sessionDates;

//   List<SessionDetail> get sessionDetailsList => _sessionDetailList;
// }
