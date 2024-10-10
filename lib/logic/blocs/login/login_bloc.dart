// ignore_for_file: use_build_context_synchronously
import 'package:bloc/bloc.dart';
import 'package:cybersquare/core/constants/const_strings.dart';
import 'package:cybersquare/core/utils/common_functions.dart';
import 'package:cybersquare/presentation/ui/login/qr_scanner_screen.dart';
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
        await loadUserProfileDetailsApi(event.context);
        await loadloguserdataApi(event.context);
        emit(SignSuccess());
      } catch (e) {
        showAlert(event.context, str_some_error_occurred_msg);
        emit(SignError());
      }
    });

    on<DomainValidationEvent>((event, emit) async {
      try {
        emit(LoadingState());
        await checkdomainApi(event.domain,event.context);
        emit(DomainValid()); 
      } catch (e) {
        emit(DomainInvalid());
      }
    });

    on<OtpDomainValidationEvent>((event, emit) async {
      try {
        emit(LoadingState());
        await checkdomainApi(event.domain,event.context);
        emit(OtpDomainValid());
      } catch (e) {
        emit(OtpDomainInvalid());
      }
    });

    on<QrSignEvent>((event, emit) async {
      try{
        await loginQrApi(event.qrcodeData, event.context);
        await loadloguserdataApi(event.context);
        QRscanner.isScanning.value = false;
      } catch(e){
        QRscanner.isScanning.value = false;
        showAlert(event.context, 'Invalid QR code');
      }
    });
  }
}
