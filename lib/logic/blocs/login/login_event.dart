part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class DomainValidationEvent extends LoginEvent {
  final String domain;
  DomainValidationEvent({required this.domain});
}

class OtpDomainValidationEvent extends LoginEvent {
  final String domain;
  OtpDomainValidationEvent({required this.domain});
}

class SignEvent extends LoginEvent {
  final BuildContext context;
  final String username;
  final String password;
  SignEvent({required this.context, required this.username, required this.password});
}

class QrSignEvent extends LoginEvent {
  
  // QrSignEvent({required this.context, required this.username, required this.password});
}