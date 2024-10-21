import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cybersquare/data/models/live_classroom_model.dart';
import 'package:cybersquare/data/repositories/live_classroom_repo.dart';
import 'package:meta/meta.dart';

part 'live_class_event.dart';
part 'live_class_state.dart';

class LiveClassBloc extends Bloc<LiveClassEvent, LiveClassState> {
  LiveClassBloc() : super(LiveClassInitial()) {
    on<FetchLiveClasses>(_fetchLiveClasses);
  }

  FutureOr<void> _fetchLiveClasses(
    FetchLiveClasses event,
    Emitter<LiveClassState> emit,
  ) async {
    emit(LiveClassLoading());

    try {
      final response = await getLiveClassApi();

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['statusCode'] != null &&
            data["statusCode"] == 403 &&
            data['forceLogout'] != null &&
            data["forceLogout"] == true) {
        } else if (data['statusCode'] != null && data["statusCode"] == 200) {
          LiveClassroomData liveClassData = liveClassroomDataFromJson(
            response.body,
          );

          emit(LiveClassLoaded(liveClassData.liveClasses));
        } else {
          emit(LiveClassError(message: data['message']));
        }
      }
    } on SocketException catch (_) {
      emit(LiveClassError());
    } on TimeoutException catch (_) {
      emit(LiveClassTimeout());
    }
  }
}
