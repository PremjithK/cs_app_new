part of 'activities_bloc.dart';

@immutable
sealed class ActivitiesEvent {}

final class FetchActivities extends ActivitiesEvent {
  final int pageNo;
  final int limit;

  FetchActivities({required this.pageNo, required this.limit});
}