part of 'news_and_events_bloc.dart';

@immutable
sealed class NewsAndEventsState {}

final class NewsAndEventsInitial extends NewsAndEventsState {}

final class NewsAndEventsLoading extends NewsAndEventsState {}

final class NewsAndEventsLoaded extends NewsAndEventsState {
  final List<NewsAndEvents> newsAndEvents;
  NewsAndEventsLoaded(this.newsAndEvents);
}

final class NewsAndEventsError extends NewsAndEventsState {}

final class NewsAndEventsTimeout extends NewsAndEventsState {}
