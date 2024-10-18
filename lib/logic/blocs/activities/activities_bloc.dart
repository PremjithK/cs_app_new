import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cybersquare/data/models/activities_model.dart';
import 'package:cybersquare/data/repositories/activities_repo.dart';
import 'package:meta/meta.dart';

part 'activities_event.dart';
part 'activities_state.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  ActivitiesBloc() : super(ActivitiesInitial()) {
    on<FetchActivities>(_fetchActivities);
  }

  int page = 0;
  bool isPaginationLoading = false;
  List<ActivitiesModel> activities = [];

  FutureOr<void> _fetchActivities(
    FetchActivities event,
    Emitter<ActivitiesState> emit,
  ) async {
    if (page == 0) {
      activities.clear();
      emit(ActivitiesLoading());
    } else {
      isPaginationLoading = true;
    }
    try {
      final response = await getActivitiesApi(page: page, limit: event.limit);
      if (response.statusCode == 200) {
        dynamic data = json.decode(response.body);
        if (data['statusCode'] != null &&
            data["statusCode"] == 403 &&
            data['forceLogout'] != null &&
            data["forceLogout"] == true) {
          // return logoutUser(context, 0);
        } else if (data['statusCode'] != null && data['statusCode'] == 200) {
          List<dynamic> a = data['activities'];
          List<ActivitiesModel> list =
              a.map((d) => ActivitiesModel.fromJson(d)).toList();

          if (page == 0) {
            emit(ActivitiesLoaded(list));
          } else {
            activities.addAll(list);
            emit(ActivitiesLoaded(activities.toSet().toList()));
          }
          isPaginationLoading = false;
        }
      }
    } on SocketException catch (_) {
      emit(ActivitiesError());
    } on TimeoutException catch (_) {
      emit(ActivitiesTimeout());
    }
  }
}
