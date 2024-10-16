part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoadingState extends LoginState {}

class DomainValid extends LoginState {}

class DomainInvalid extends LoginState {}

class OtpDomainValid extends LoginState {}

class OtpDomainInvalid extends LoginState {}

class SignLoadingState extends LoginState {}

class SignError extends LoginState {}

class SignSuccess extends LoginState {}

class OtpDetailsLoadingState extends LoginState {}

class OtpDetailsSuccessState extends LoginState {}

class OtpValid extends LoginState {}

class OtpInvalid extends LoginState {}
