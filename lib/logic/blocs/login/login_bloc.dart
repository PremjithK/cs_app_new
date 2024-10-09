import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:cybersquare/data/repositories/authentication_repo.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<SignEvent>((event, emit) async {
      emit(SignLoadingState());
      try {
        await companysettingsApi();
        await loginaccestokenApi(context: event.context, username: event.username, password: event.password);
        await loadUserProfileDetailsApi();
        await loadloguserdataApi();
        emit(SignSuccess());
      } catch (e) {
        emit(SignError());
      }
    });

    on<DomainValidationEvent>((event, emit) async {
      try {
        emit(LoadingState());
        await checkdomainApi(event.domain);
        emit(DomainValid()); 
      } catch (e) {
        emit(DomainInvalid());
      }
    });

    on<OtpDomainValidationEvent>((event, emit) async {
      try {
        emit(LoadingState());
        await checkdomainApi(event.domain);
        emit(OtpDomainValid());
      } catch (e) {
        emit(OtpDomainInvalid());
      }
    });

    on<QrSignEvent>((event, emit) async {
      try{
        // await loginlmsToken(event.qrcode);
      } catch(e){
        print(e);
      }
    });
  }
}
