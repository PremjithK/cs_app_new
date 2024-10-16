part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class DomainValidationEvent extends LoginEvent {
  final BuildContext context;
  final String domain;
  DomainValidationEvent(this.context, {required this.domain});
}

class OtpDomainValidationEvent extends LoginEvent {
  final BuildContext context;
  final String domain;
  OtpDomainValidationEvent(this.context, {required this.domain});
}

class SignEvent extends LoginEvent {
  final BuildContext context;
  final String username;
  final String password;
  SignEvent({required this.context, required this.username, required this.password});
}

class QrSignEvent extends LoginEvent {
  final BuildContext context;
  final String qrcodeData;
  QrSignEvent({required this.context, required this.qrcodeData});
}

class OtploginDetails extends LoginEvent {
  final BuildContext context;
  final String username;

  OtploginDetails({required this.context, required this.username});
}

class SentOtpEvent extends LoginEvent {
  final BuildContext context;
  SentOtpEvent({required this.context});
}

class ValidateOtpEvent extends LoginEvent {
  final BuildContext context;
  final String otp;
  ValidateOtpEvent({required this.context, required this.otp});
}

class OtpLoginEvent extends LoginEvent {
  final BuildContext context;
  OtpLoginEvent({required this.context});
}