// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';

// class ResultChartColors {
//   static Color get correct => const Color(0xFF58c598);
//   static Color get wrong => const Color(0xFFec4860);
//   static Color get pending => const Color(0xFF483D8B);
//   static Color get partial => const Color(0xFFffaf19);
//   static Color get unattempted => const Color(0xFFCBCBCB);
// }

// class ExamResultProvider with ChangeNotifier {
//   late bool isLoading = false;

//   // Exam Result Fields
//   late bool dontShowReportOnCompletion = false; // if true: hide reports
//   late bool showAnswersInReport = false; // for answers tab
//   late String examDuration = 'N/A';
//   late String yourTime = 'N/A';
//   late String markString = 'N/A';
//   late String attendedStudents = 'N/A';
//   late List<ChartData> chartData = [];
//   late bool timerEnabled = false;

//   late num totalMark = 0.0;
//   late num markScored = 0.0;

//   void resetData() {
//     //Clearing previous data
//     dontShowReportOnCompletion = false;
//     showAnswersInReport = false; // for answers tab
//     examDuration = 'N/A';
//     yourTime = 'N/A';
//     markString = 'N/A';
//     attendedStudents = 'N/A';
//     chartData = [];
//     totalMark = 0.0;
//     markScored = 0.0;
//     notifyListeners();
//   }

//   Future<void> getExamResults(
//     BuildContext context,
//     String courseMappingId,
//     String examId,
//   ) async {
//     String strUrl = url_base2 + url_get_exam_result;
//     final Map<String, String> header = {
//       "Content-Type": "application/json; charset=UTF-8",
//       "authorization": constUserToken,
//     };

//     final Map<String, String> postData = {
//       'courseMappingId': courseMappingId,
//       'examId': examId,
//     };

//     if (constIsConnectedToInternet) {
//       isLoading = true;
//       notifyListeners();
//       try {
//         final response = await postMethodApi(postData, strUrl, header);
//         if (response.statusCode == 200 || response.statusCode == 201) {
//           final Map<String, dynamic> data =
//               json.decode(json.decode(response.body));

//           if (data['resource']['elements'] != null &&
//               data['resource']['elements'][1] != null &&
//               data['resource']['elements'][1]['value'] != null) {
//             //^ Checking for dontShowReportOnCompletion
//             dontShowReportOnCompletion = (data['resource']['elements'][1]
//                     ['value']['dontShowReportOnCompletion'] as bool?) ??
//                 false;
//             showAnswersInReport = (data['resource']['elements'][1]['value']
//                     ['showAnswersInReport'] as bool?) ??
//                 false;
//           }
//           if (dontShowReportOnCompletion) {
//             isLoading = false;
//             notifyListeners();
//             return;
//           }
//           if (data['totalAttemptedStudents'] != null) {
//             attendedStudents = data['totalAttemptedStudents'].toString();
//           }
//           Map<String, dynamic> d = data['resource']['elements'][1]['value'];
          
//           //^ Checking if timer is enabled
//           timerEnabled = (d['TimerEnabled'] as bool?) ?? false;
//           examDuration = convertMillisecondsToString(d['actualDuration'] ?? 0);

//             //^ Calculating time taken by student for this exam
//             if (data['courseElement']['submittedOn'] != null &&
//                 data['courseElement']['timeObj'] != null) {
//               int submittedOn =
//                   data['courseElement']['submittedOn']['\$date'] ?? 0;
//               int startedOn =
//                   data['courseElement']['timeObj']['startTime'] ?? 0;

//               // Checking if timer was up or not
//               int timeTaken = submittedOn - startedOn;
//               if (timerEnabled) {
//               if (timeTaken >= (d['actualDuration'] ?? 0)) {
//                 yourTime = '$examDuration (Time Up)';
//               } else {
//                 yourTime = convertMillisecondsToString(submittedOn - startedOn);
//               }
//             } else {
//               yourTime = convertMillisecondsToString(submittedOn - startedOn);
//             }
//           }

//           if (data['courseElement']['markScored'] != null &&
//               data['courseElement']['totalMark'] != null) {
//             markScored = data['courseElement']['markScored'];

//             late int totalCount = 0;
//             late int correctCount = 0;
//             late int wrongCount = 0;
//             late int partialCount = 0;
//             late int pendingCount = 0;
//             late int unattempted = 0;

//             //! Calculating pie chart data
//             Map<dynamic, List<dynamic>> sectionedMaterials = {};

//             final sections = data['resource']['elements'][1]['value']
//                 ['sections'] as List<dynamic>;
//             final allMaterials =
//                 data['examDetails']['materials'] as List<dynamic>;

//             for (int i = 0; i < sections.length; i++) {
//               sectionedMaterials.addAll({sections[i]: []});
//               for (int j = 0; j < allMaterials.length; j++) {
//                 if (sections[i]['name'] == (allMaterials[j]['sectionName'])) {
//                   sectionedMaterials[sections[i]]?.add(allMaterials[j]);
//                 }
//               }
//             }

//             num marksToSubtract = 0.0;
//             num sectionMark = 0.0;
//             sectionedMaterials.forEach((section, materialList) {
//               // SECTIONWISE LOOPING
//               int currentSectionChoiceCount = 1;

//               for (var material in materialList) {
//                 num markScored = 0;
//                 if (material['markScored'] != null) {
//                   markScored = material['markScored'] as num? ?? 0;
//                 }
//                 num totalMarkOfMaterial = material['totalMark'] as num? ?? 0;
//                 sectionMark = totalMarkOfMaterial;

//                 if (section['choiceOfQuestions'] != null) {
//                   int secChoiceCount = section['choiceOfQuestions'] ?? 0;
//                   if (secChoiceCount > 0) {
//                     marksToSubtract =
//                         ((materialList.length - secChoiceCount) * sectionMark);
//                   }
//                   totalCount++;
//                   if (currentSectionChoiceCount >
//                       section['choiceOfQuestions']) {
//                     break;
//                   }
//                   currentSectionChoiceCount++;
//                 } else {
//                   totalCount++;
//                 }

//                 final userAnswer = material['elements'][1]['value']
//                     ['userAnswer'] as List<dynamic>?;

//                 if (userAnswer == null || userAnswer.isEmpty) {
//                   unattempted += 1;
//                 } else if (markScored > 0 && markScored < totalMarkOfMaterial) {
//                   partialCount += 1;
//                 } else if (markScored == totalMarkOfMaterial) {
//                   correctCount += 1;
//                 }else if (material['elements'][1]['value']['type'] == 'descriptive') {
//                   if(material['evaluationType']=='manual'){
//                     if(markScored>0){
//                       correctCount += 1;
//                     }else{
//                       wrongCount += 1;
//                     }
//                   }else{
//                     pendingCount += 1; 
//                   }
//                 }else {
//                   if (markScored <= 0) {
//                     wrongCount += 1;
//                   }
//                 }
//               }
//               totalMark = data['courseElement']['totalMark'] as num;
//               totalMark = totalMark - marksToSubtract;
//             });

//             String totalMarkString = totalMark.toString();
//             String markScoredString = markScored.toString();

//             if (markScoredString.contains('.0')) {
//               markScoredString = markScoredString.replaceFirst('.0', '');
//             }
//             if (totalMarkString.contains('.0')) {
//               totalMarkString =
//                   totalMarkString = totalMarkString.replaceFirst('.0', '');
//             }
//             //^ final string showing x out of y marks
//             markString = markScoredString;

//             //! Pushing data to piechart
//             num correctPercent = ((correctCount / totalCount) * 100);
//             num wrongPercent = ((wrongCount / totalCount) * 100);
//             num partialPercent = ((partialCount / totalCount) * 100);
//             num unattemptedPercent = ((unattempted / totalCount) * 100);
//             num pendingPercent = ((pendingCount / totalCount) * 100);

//             if (correctCount > 0) {
//               chartData.add(ChartData(
//                   'Correct', correctPercent, ResultChartColors.correct));
//             }
//             if (wrongCount > 0) {
//               chartData.add(
//                   ChartData('Wrong', wrongPercent, ResultChartColors.wrong));
//             }
//             if (partialCount > 0) {
//               chartData.add(ChartData(
//                   'Partial', partialPercent, ResultChartColors.partial));
//             }
//             if (unattempted > 0) {
//               chartData.add(ChartData('Unattempted', unattemptedPercent,
//                   ResultChartColors.unattempted));
//             }
//             if (pendingCount > 0) {
//               chartData.add(ChartData(
//                   'Pending', pendingPercent, ResultChartColors.pending));
//             }
//             notifyListeners();
//           }
//         } else if (response.statusCode == 403) {
//           return logoutUser(context, 0);
//         }
//       } on SocketException catch (_) {
//         showAlert(context, str_some_error_occurred_msg);
//       } on TimeoutException catch (_) {
//         showAlert(context, str_connection_timeout);
//       }
//       isLoading = false;
//       notifyListeners();
//     } else {
//       showAlert(context, str_no_network_msg);
//     }
//   }

//   String convertMillisecondsToString(int milliseconds) {
//     Duration duration = Duration(milliseconds: milliseconds);

//     int hours = duration.inHours;
//     int minutes = duration.inMinutes.remainder(60);
//     int seconds = duration.inSeconds.remainder(60);

//     List<String> parts = [];
//     if (hours > 0) {
//       parts.add(Intl.plural(hours, one: '$hours hour', other: '$hours hours'));
//     }
//     if (minutes > 0) {
//       parts.add(Intl.plural(minutes,
//           one: '$minutes minute', other: '$minutes minutes'));
//     }
//     if (seconds > 0 || parts.isEmpty) {
//       parts.add(Intl.plural(seconds,
//           one: '$seconds second', other: '$seconds seconds'));
//     }
//     return parts.join(', ');
//   }
// }
