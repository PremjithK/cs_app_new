import 'dart:async';

import 'package:cybersquare/connectivity.dart';
import 'package:cybersquare/core/constants/asset_images.dart';
import 'package:cybersquare/core/constants/colors.dart';
import 'package:cybersquare/core/constants/const_strings.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:cybersquare/core/utils/common_functions.dart';
import 'package:cybersquare/data/models/academic_year_list_model.dart';
import 'package:cybersquare/data/models/activities_model.dart';
import 'package:cybersquare/data/models/live_classroom_model.dart';
import 'package:cybersquare/data/models/news_events_model.dart';
import 'package:cybersquare/globals.dart';
import 'package:cybersquare/logic/blocs/activities/activities_bloc.dart';
import 'package:cybersquare/logic/blocs/live_class/live_class_bloc.dart';
import 'package:cybersquare/logic/blocs/news_and_events/news_and_events_bloc.dart';
import 'package:cybersquare/presentation/ui/app_drawer/app_drawer.dart';
import 'package:cybersquare/presentation/ui/dashboard/course_progress_dialog.dart';
import 'package:cybersquare/presentation/widgets/custom_app_bar.dart';
import 'package:cybersquare/presentation/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.avatar});

  final String avatar;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  late ConnectivityManager connectivityManager;

  //? Academic Year
  String? academicYearSelected =
      constCurrentAcademicYearId.isNotEmpty ? constCurrentAcademicYearId : null;
  List<AcademicYear> academicYearList = [];

  final activityScrollController = ScrollController();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final NewsAndEventsBloc _newsBloc = NewsAndEventsBloc();
  final LiveClassBloc _liveClassBloc = LiveClassBloc();
  final ActivitiesBloc _activitiesBloc = ActivitiesBloc();

  @override
  void initState() {
    super.initState();

    connectivityManager = ConnectivityManager(
      onConnected: () {
        if(mounted) {
          _newsBloc.add(FetchNewsAndEvents());
        _liveClassBloc.add(FetchLiveClasses());
        _activitiesBloc.add(
          FetchActivities(
            pageNo: 0,
            limit: _activitiesBloc.activities.length,
          ),
        );
        }
      },
      onDisconnected: () {
        if (mounted) {
          showAlert(context: context, strMsg: str_no_network_msg);
        }
      },
    );

    if (constCurrentAcademicYearId.isNotEmpty &&
        constListAcademicYearData.isNotEmpty) {
      academicYearList = constListAcademicYearData;
    }
    _activitiesBloc.page = 0;
    activityScrollController.addListener(() {
      if (activityScrollController.position.atEdge &&
          activityScrollController.position.pixels != 0) {
        if (!_activitiesBloc.isPaginationLoading) {
          _activitiesBloc.add(
            FetchActivities(
              pageNo: ++_activitiesBloc.page,
              limit: _activitiesBloc.activities.length,
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _newsBloc.add(FetchNewsAndEvents());
    _liveClassBloc.add(FetchLiveClasses());
    _activitiesBloc.add(
      FetchActivities(
        pageNo: 0,
        limit: _activitiesBloc.activities.length,
      ),
    );

    return PopScope(
      canPop: onBackPressCallback(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: color_bg,
        appBar: setupAppbar(context, str_dashboard, avatar: widget.avatar),
        drawer: AppDrawer(avatar: widget.avatar),
        body: GestureDetector(
          onVerticalDragEnd: (drag) {
            if (drag.primaryVelocity == 0.0) {
              _refreshIndicatorKey.currentState?.deactivate();
              // setState(() {
              //   indicator = false;
              // });
            } else {
              _refreshIndicatorKey.currentState?.show();
              // setState(() {
              //   indicator = true;
              // });
            }
          },
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 1500));
              if (_activitiesBloc.state is! ActivitiesLoading &&
                  !_activitiesBloc.isPaginationLoading) {
                _activitiesBloc.add(
                  FetchActivities(
                    pageNo: 0,
                    limit: 10,
                  ),
                );
              }
              _newsBloc.add(FetchNewsAndEvents());
              _liveClassBloc.add(FetchLiveClasses());
            },
            child: SafeArea(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                // child: newsListApiStatus == 0 && activityListApiStatus == 0
                //     ? constIsConnectedToInternet
                //         ? getDashboard()
                //         : setupEmptyView(str_no_network_msg)
                //     : getDashboard(),
                child: constIsConnectedToInternet
                    ? newDashboard()
                    : setupEmptyView(str_no_network_msg),
              ),
            ),
          ),
        ),
      ),
    );
  }

  newDashboard() {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: activityScrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              //! LIVE CLASS IMMEMDIATE
              BlocBuilder<LiveClassBloc, LiveClassState>(
                bloc: _liveClassBloc,
                builder: (context, state) {
                  if (state is LiveClassError) {
                    return setupEmptyView(str_some_error_occurred_msg);
                  }
                  if (state is LiveClassTimeout) {
                    return setupEmptyView(str_some_error_occurred_msg);
                  }
                  if (state is LiveClassLoaded) {
                    if (state.data == null) {
                      return const SizedBox();
                    } else {
                      if (state.data!.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Swipe down to refresh",
                              style: GoogleFonts.getFont(
                                globalFontName,
                                color: Colors.black38,
                              ),
                            ),
                          ),
                        );
                      }
                      return Center(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          itemCount: state.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            final liveClass = state.data![index];

                            return _immediateClass(context, liveClass);
                          },
                        ),
                      );
                    }
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              const SizedBox(height: 10),
              //! NEWS AND EVENTS
              BlocBuilder<NewsAndEventsBloc, NewsAndEventsState>(
                bloc: _newsBloc,
                builder: (context, state) {
                  if (state is NewsAndEventsLoading) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Loading(true),
                    );
                  }
                  if (state is NewsAndEventsError) {
                    return setupEmptyView(str_some_error_occurred_msg);
                  }
                  if (state is NewsAndEventsLoaded) {
                    if (state.newsAndEvents.isEmpty) {
                      return setupEmptyView(str_news_empty);
                    } else {
                      return Column(
                        children: [
                          const SizedBox(height: 16),
                          _customText(str_news_and_update, title: true),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.newsAndEvents.length,
                            padding: const EdgeInsets.only(top: 7),
                            itemBuilder: (context, index) {
                              return _newsItem(state.newsAndEvents[index]);
                            },
                          ),
                        ],
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),

              //! ACTIVITIES
              const SizedBox(height: 16),
              _customText(str_activity_feed, title: true),
              const SizedBox(height: 16),
              BlocBuilder<ActivitiesBloc, ActivitiesState>(
                bloc: _activitiesBloc,
                builder: (context, state) {
                  if (state is ActivitiesLoading) {
                    return Loading(true);
                  }
                  if (state is ActivitiesError) {
                    return setupEmptyView(str_some_error_occurred_msg);
                  }
                  if (state is ActivitiesTimeout) {
                    return setupEmptyView(str_connection_timeout);
                  }
                  if (state is ActivitiesLoaded) {
                    if (state.activities.isEmpty) {
                      return setupEmptyView(str_activity_empty);
                    }
                    int actLen = 0;
                    if (_activitiesBloc.isPaginationLoading) {
                      actLen = state.activities.length + 1;
                    } else {
                      actLen = state.activities.length;
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: actLen,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final activity = state.activities[index];
                        return _activityItem(activity);
                      },
                    );
                  }
                  return setupEmptyView(str_some_error_occurred_msg);
                },
              )
            ],
          ),
        ),
        //! COURSE PROGRESS BUTTON
        Visibility(
          visible: _newsBloc.state is! NewsAndEventsLoading,
          child: _courseProgressButton(),
        ),
      ],
    );
  }

  _courseProgressButton() {
    return Positioned(
      right: 0,
      top: 155,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return const CourseProgressDialog();
            },
          );
        },
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                )),
            child: Image.asset(
              img_progress,
              width: 20,
              height: 20,
            )),
      ),
    );
  }

  Widget setupTextRow(String strTitle, String strValue,
      {status = 0, isLink = false}) {
    final txtTitle = widgetText(
      strTitle,
      "",
      constDeviceType == 1 ? 14.5 : 16,
      color_login_text_black,
      TextAlign.left,
      FontWeight.w600,
      0,
    );

    final txtCenter = widgetText(
      ":",
      "",
      constDeviceType == 1 ? 14.5 : 16,
      color_login_text_black,
      TextAlign.left,
      FontWeight.w600,
      0,
    );
    final txtValue = isLink
        ? GestureDetector(
            child: Text(
              strValue,
              textAlign: TextAlign.left,
              style: GoogleFonts.getFont(
                globalFontName,
                shadows: [
                  const Shadow(color: Colors.blue, offset: Offset(0, -5))
                ],
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue,
                decorationThickness: 1,
                fontSize: constDeviceType == 1 ? 14.5 : 16,
                fontWeight: FontWeight.w600,
                color: Colors.transparent,
                letterSpacing: status == 1 ? 0.48 : 0,
              ),
            ),
            onTap: () {
              if (strValue != "NA") {
                _launchURL(strValue);
              }
            },
          )
        : widgetText(
            strValue,
            // "strValue strValue strValue strValue strValue strValue strValue strValue strValue strValue strValue strValue strValue strValue123",
            "",
            constDeviceType == 1 ? 14.5 : 16,
            color_login_text_black,
            TextAlign.left,
            FontWeight.w600,
            0,
          );

    Widget btnCopy = SizedBox(
      height: 20,
      width: 20,
      child: InkWell(
        child: const Icon(
          Icons.copy,
          size: 20,
          color: Colors.blue,
        ),
        onTap: () {
          Clipboard.setData(ClipboardData(text: strValue));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            margin: EdgeInsets.symmetric(
              horizontal: (MediaQuery.of(context).size.width - 120) / 2,
              vertical: 10,
            ),
            content: widgetText("Copied", "", constDeviceType == 1 ? 15 : 16,
                Colors.white, TextAlign.center, FontWeight.w600, 0),
          ));
        },
      ),
    );
    if (status == 1) {}
    final rowDetails = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 110,
              child: txtTitle,
            ),
          ),
        ),
        txtCenter,
        Expanded(
          // flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: txtValue,
          ),
        ),
        Visibility(
          visible: status == 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: btnCopy,
          ),
        )
      ],
    );
    return Container(child: rowDetails);
  }

  Widget _immediateClass(BuildContext context, LiveClass obj) {
    String strStartTime = "";
    if (obj.startTime != null) {
      DateTime temp = obj.startTime!;
      final DateFormat formatterMonth = DateFormat('hh:mm a');
      strStartTime = formatterMonth.format(temp);
    }

    if (obj.endTime != null) {
      DateTime temp = obj.endTime!;
      final DateFormat formatterMonth = DateFormat('hh:mm a');
      if (strStartTime != "") {
        strStartTime = "$strStartTime - ${formatterMonth.format(temp)}";
      } else {
        strStartTime = formatterMonth.format(temp);
      }
    }

    String strMeetingCode = "NA";
    if (obj.googleCalendarEvent != null) {
      if (obj.googleCalendarEvent!.isNotEmpty) {
        if (obj.googleCalendarEvent![0].conferenceData != null) {
          strMeetingCode =
              obj.googleCalendarEvent![0].conferenceData!.conferenceId ?? "NA";
        }
      }
    }
    String strZoomLink = obj.zoomMeetingJoinUrl ?? "NA";
    String strMeetingLink = obj.googleMeetingLink ?? "NA";
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          setupTextRow("Name", obj.name ?? ""),
          const SizedBox(height: 16),
          setupTextRow("Time", strStartTime),
          Visibility(
            visible: obj.presenter != null && obj.presenter != "",
            child: const SizedBox(height: 16),
          ),
          Visibility(
            visible: obj.presenter != null && obj.presenter != "",
            child: setupTextRow("Presenter", obj.presenter ?? ""),
          ),
          const SizedBox(height: 16),
          setupTextRow("Zoom", strZoomLink,
              status: strZoomLink != "NA" ? 1 : 0,
              isLink: strZoomLink != "NA" ? true : false),
          const SizedBox(height: 16),
          setupTextRow("Meeting link", strMeetingLink,
              status: strMeetingLink != "NA" ? 1 : 0,
              isLink: strMeetingLink != "NA" ? true : false),
          const SizedBox(height: 16),
          setupTextRow("Meeting code", strMeetingCode,
              status: strMeetingCode != "NA" ? 1 : 0),
          const SizedBox(height: 16),
          Visibility(
              visible: strZoomLink != "NA" || strMeetingLink != "NA",
              child: Container(
                width: 80,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300)),
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: widgetText(
                              "Join",
                              "",
                              14,
                              color_login_text_black,
                              TextAlign.left,
                              FontWeight.w500,
                              0),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    if (strZoomLink != "NA") {
                      // _launchURL(strZoomLink);
                    } else if (strMeetingLink != "NA") {
                      // _launchURL(strMeetingLink);
                    }
                  },
                ),
              )),
          Visibility(
            visible: strZoomLink != "NA" || strMeetingLink != "NA",
            child: const SizedBox(height: 5),
          ),
        ],
      ),
    );
  }

  Widget _activityItem(ActivitiesModel activity) {
    int totalCompletedCourses =
        activity.submittedCount != null ? activity.submittedCount! : 0;
    int material = activity.materialcount!;
    material == 0 ? material = 1 : material = material;
    double progress = totalCompletedCourses / material * 100;

    //double progress = totalCompletedCourses / activity.materialcount! * 100;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.075),
                blurRadius: 10,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.asset(img_user,width: 40,height: 40,),
              // SizedBox(width: 10,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.getFont(
                                globalFontName,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: activity.teacherName.toString(),
                                  style: GoogleFonts.getFont(
                                    globalFontName,
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const TextSpan(
                                  text: " $str_has_assigned ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                TextSpan(
                                  text: activity.activityName.toString(),
                                  style: GoogleFonts.getFont(
                                    globalFontName,
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const TextSpan(
                                  text: " $str_to_you",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          getFormattedDate(activity.createdDate),
                          style: GoogleFonts.getFont(
                            globalFontName,
                            color: Colors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          "$str_subject : ",
                          style: GoogleFonts.getFont(
                            globalFontName,
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          activity.subjectName.toString(),
                          style: GoogleFonts.getFont(
                            globalFontName,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        customButton(
                          str_try_now,
                          onTap: () {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => ActivityView(activity.id!,
                            //           activity.activityName, constLoginUserId),
                            //     ),
                            //   ).then((value) => setState(() {
                            //         // getActivitiesApi();
                            //       }));
                          },
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 150,
                                    minWidth: 80,
                                  ),
                                  child: roundedProgress(progress),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "$str_completed $totalCompletedCourses $str_of ${activity.materialcount!}",
                                  //  activity.materials!.length.toString(),
                                  style: GoogleFonts.getFont(
                                    globalFontName,
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

_customText(text, {title = false, align = Alignment.centerLeft}) {
  return Align(
    alignment: align,
    child: Text(
      text,
      style: GoogleFonts.getFont(
        globalFontName,
        color: title ? Colors.black : color_text,
        fontSize: title ? 18 : 15,
        fontWeight: title ? FontWeight.w700 : FontWeight.w500,
      ),
      textAlign: TextAlign.left,
    ),
  );
}

Widget _newsItem(NewsAndEvents news) {
  BoxDecoration decoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
  );
  return Container(
    decoration: decoration,
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          img_notification,
          width: 40,
          height: 40,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      news.title!,
                      style: GoogleFonts.getFont(
                        globalFontName,
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 5),
                  // const Text(
                  //   "5 hours ago",
                  //   style: TextStyle(color: Colors.grey, fontSize: 10),
                  // ),
                ],
              ),
              const SizedBox(height: 5),
              // Text(
              //   news.description!,
              //   style: const TextStyle(
              //       color: Colors.grey,
              //       fontSize: 12
              //   ),
              //   maxLines: 2,
              // ),
              Html(data: news.description!),
              const SizedBox(height: 5),
              Text(
                "Read More",
                style: GoogleFonts.getFont(
                  globalFontName,
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

void _launchURL(String strUrl) async {
  // if (!await launch(strUrl)) throw 'Could not launch $strUrl';
  // await canLaunch(strUrl)
  //     ? await launch(strUrl)
  //     : showAlertWithMessage(context, str_some_error_occurred_msg);
}
