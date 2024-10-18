part of 'news_and_events_bloc.dart';

@immutable
sealed class NewsAndEventsEvent {}

class FetchNewsAndEvents extends NewsAndEventsEvent {}
