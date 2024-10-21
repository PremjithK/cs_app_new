part of 'live_class_bloc.dart';

@immutable
sealed class LiveClassState {}

final class LiveClassInitial extends LiveClassState {}

final class LiveClassLoading extends LiveClassState {}

final class LiveClassLoaded extends LiveClassState {
  final List<LiveClass>? data;
  LiveClassLoaded(this.data);
}

final class LiveClassError extends LiveClassState {
  final String? message;
  LiveClassError({this.message});
}

final class LiveClassTimeout extends LiveClassState {}
