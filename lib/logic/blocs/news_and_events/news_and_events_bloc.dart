import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cybersquare/data/models/news_events_model.dart';
import 'package:cybersquare/data/repositories/news_and_events_repo.dart';
import 'package:meta/meta.dart';

part 'news_and_events_event.dart';
part 'news_and_events_state.dart';

class NewsAndEventsBloc extends Bloc<NewsAndEventsEvent, NewsAndEventsState> {
  NewsAndEventsBloc() : super(NewsAndEventsInitial()) {
    on<FetchNewsAndEvents>(_fetchNewsAndEvents);
  }

  FutureOr<void> _fetchNewsAndEvents(
    FetchNewsAndEvents event,
    Emitter<NewsAndEventsState> emit,
  ) async {
    emit(NewsAndEventsLoading());
    try {
      final response = await getNewsAndEventsApi();
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['statusCode'] != null &&
            data["statusCode"] == 403 &&
            data['forceLogout'] != null &&
            data["forceLogout"] == true) {
          // return logoutUser(context, 0);
        } else if (data['statusCode'] != null && data["statusCode"] == 200) {
          NewsEventsModel newsEventsModel = NewsEventsModel.fromJson(data);
          List<NewsAndEvents> newsList = newsEventsModel.newsAndEvents!;
          emit(NewsAndEventsLoaded(newsList));
        } else {
          emit(NewsAndEventsError());
        }
      } else {
        emit(NewsAndEventsError());
      }
    } on SocketException catch (_) {
      emit(NewsAndEventsError());
    } on TimeoutException catch (_) {
      emit(NewsAndEventsTimeout());
    }
  }
}
