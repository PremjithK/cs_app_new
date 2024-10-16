// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cybersquare/core/constants/asset_images.dart';
import 'package:cybersquare/core/constants/colors.dart';
import 'package:cybersquare/core/constants/lottie.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:cybersquare/logic/blocs/login/login_bloc.dart';
import 'package:cybersquare/logic/providers/forgotpassword_model.dart';
import 'package:cybersquare/presentation/widgets/common_widgets.dart';
import 'package:cybersquare/presentation/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);
  static const routeName = "/ForgotPasswordScreen";

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final txtEmailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final focusNode = FocusNode();

  int statShowPassword = 0;
  int statSignedIn = 0;
  bool isLoading = false;
  bool otpValidated = false;
  String otpEntered = '';

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool courseEmpty = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.mobile) || 
        result.contains(ConnectivityResult.ethernet)) {
      setState(() {
          constIsConnectedToInternet = true;
        });
    }else{
      setState(() {
          constIsConnectedToInternet = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    // txtEmailController.text = "habitat.0948@99lms.com";
    return PopScope(
      canPop: false,
      onPopInvoked: (bool value) {
        final provider =
            Provider.of<ForgotpswdProvider>(context, listen: false);
        if (provider.otpEmailvalidated == false && provider.otpSent == true) {
          provider.setotpEmailvalidated(true);
          provider.setotpSent(false);
        } else if (provider.otpEmailvalidated == true &&
            provider.otpSent == false) {
          provider.setotpEmailvalidated(false);
        }

        Provider.of<ForgotpswdProvider>(context, listen: false)
            .selectedmobileIndexes
            .clear();
        Provider.of<ForgotpswdProvider>(context, listen: false)
            .selectedemailIndexes
            .clear();
        Provider.of<ForgotpswdProvider>(context, listen: false).resetState();
        email_list.clear();
        mobile_list.clear();
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        extendBody: true,
        body: SingleChildScrollView(
          child: GestureDetector(
            child: setupView(),
            onTap: () {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }

  Widget setupView() {
    final txtTitle = widgetText(
        "login with OTP",
        "",
        constDeviceType == 1 ? 22 : 27,
        color_login_text_black,
        TextAlign.left,
        FontWeight.w800,
        0);

    final verificationTitle = widgetText(
        "Verification",
        "",
        constDeviceType == 1 ? 22 : 27,
        color_login_text_black,
        TextAlign.left,
        FontWeight.w800,
        0);

    final containerTxtFieldEmail = Container(
      height: constDeviceType == 1 ? 50 : 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: color_login_border_gray),
      ),
      child: Padding(
        padding: constDeviceType == 1
            ? const EdgeInsets.only(
                left: 16,
                right: 16,
              )
            : const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 5,
                bottom: 5,
              ),
        child: widgetTxtField(
            "Enter your username",
            "",
            constDeviceType == 1 ? 15 : 16,
            color_login_text_gray,
            FontWeight.w400,
            txtEmailController,
            1),
      ),
    );

    final recievepasswordtxt = widgetText(
        "How would you like to receive OTP for login?",
        "",
        constDeviceType == 1 ? 14 : 16,
        Colors.black,
        TextAlign.left,
        FontWeight.w800,
        0);

    final verificationText = widgetText(
        "We have sent a 6 digit code to your email/mobile number.Please enter the code below",
        "",
        constDeviceType == 1 ? 14 : 16,
        Colors.black,
        TextAlign.left,
        FontWeight.w800,
        0);

    phonepasswordcheckbox(BuildContext context, int ind, String mobno,
        {required bool isChecked}) {
      return Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (value) {
              Provider.of<ForgotpswdProvider>(context, listen: false)
                  .togglemobileIndex(ind);
            },
          ),
          Text(
            'Via SMS to $mobno',
          ),
        ],
      );
    }

    emailpasswordcheckbox(BuildContext context, int ind, String email,
        {required bool isChecked}) {
      return Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (value) {
              Provider.of<ForgotpswdProvider>(context, listen: false)
                  .toggleemailIndex(ind);
              // Handle checkbox value change
            },
          ),
          Expanded(
            child: Text(
              'Via Email on $email',
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      );
    }

    final btnNext = SizedBox(
      height: constDeviceType == 1 ? 50 : 60,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
          backgroundColor: WidgetStateProperty.all<Color>(
            color_login_btn,
          ),
        ),
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is OtpDetailsLoadingState) {
              return Center(
                child: Lottie.asset(
                  lottie_animation_login,
                  width: 50,
                  height: 50,
                  repeat: true,
                  fit: BoxFit.contain,
                ),
              );
            } else {
              return widgetText(
                "Next",
                "",
                constDeviceType == 1 ? 16 : 17,
                Colors.white,
                TextAlign.center,
                FontWeight.w700,
                0,
              );
            }
            // return Container();
          },
        ),
        onPressed: () async {
          email_list.clear();
          mobile_list.clear();
          final provider =
              Provider.of<ForgotpswdProvider>(context, listen: false);

          if (txtEmailController.text.isEmpty) {
            showAlert("Please enter email", 0);
          } else {
            context.read<LoginBloc>().add(OtploginDetails(
                context: context, username: txtEmailController.text));
            // await forgotPassword();
          }
          provider.selectedemailIndexes.clear();
          provider.selectedmobileIndexes.clear();
        },
      ),
    );

    final btnSentOTP = SizedBox(
      height: constDeviceType == 1 ? 50 : 60,
      child: ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0))),
            backgroundColor: WidgetStateProperty.all<Color>(
              color_login_btn,
            ),
          ),
          child: isLoading
              ? Container(
                  // color: Colors.blueGrey,
                  child: Center(
                    child: Lottie.asset(
                      lottie_animation_login,
                      width: 50,
                      height: 50,
                      repeat: true,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : widgetText(
                  "Send OTP",
                  "",
                  constDeviceType == 1 ? 16 : 17,
                  Colors.white,
                  TextAlign.center,
                  FontWeight.w700,
                  0,
                ),
          onPressed: () async {
            otpController.clear();
            final provider =
                Provider.of<ForgotpswdProvider>(context, listen: false);
            if (provider.selectedemailIndexes.isNotEmpty ||
                provider.selectedmobileIndexes.isNotEmpty) {
              context.read<LoginBloc>().add(SentOtpEvent(context: context));
              provider.setotpEmailvalidated(false);
              provider.setotpSent(true);
            } else {
              showAlert("Please select atleast one option", 0);
            }
          }),
    );

    final btnOtpLogin = BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is OtpValid) {
                  context
                      .read<LoginBloc>()
                      .add(OtpLoginEvent(context: context));
                }
      },
      child: SizedBox(
        height: constDeviceType == 1 ? 50 : 60,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0))),
            backgroundColor: WidgetStateProperty.all<Color>(
              color_login_btn,
            ),
          ),
          child: isLoading
              ? Center(
                  child: Lottie.asset(
                    lottie_animation_login,
                    width: 50,
                    height: 50,
                    repeat: true,
                    fit: BoxFit.contain,
                  ),
                )
              : widgetText(
                  "Login",
                  "",
                  constDeviceType == 1 ? 16 : 17,
                  Colors.white,
                  TextAlign.center,
                  FontWeight.w700,
                  0,
                ),
          onPressed: () async {
            context
                .read<LoginBloc>()
                .add(ValidateOtpEvent(context: context, otp: otpEntered));
            // if (otpValidated == true) {
            //   await companysettings();
            //   await loadloguserdata();
            // }
          },
        ),
      ),
    );

    final btnForgotPassword = TextButton.icon(
      onPressed: () {
        Navigator.pop(context);
        Provider.of<ForgotpswdProvider>(context, listen: false).resetState();
        mobile_list.clear();
        email_list.clear();
        Provider.of<ForgotpswdProvider>(context, listen: false)
            .selectedmobileIndexes
            .clear();
        Provider.of<ForgotpswdProvider>(context, listen: false)
            .selectedemailIndexes
            .clear();
      },
      icon: Icon(
        Icons.arrow_back,
        color: Colors.red,
      ),
      label: widgetText(
        "Back to sign in",
        "",
        constDeviceType == 1 ? 16 : 18,
        Colors.red,
        TextAlign.center,
        FontWeight.w400,
        0,
      ),
    );

    final btnResentOtp = Wrap(
      children: [
        Text(
          'Didnt received the verification code? ',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        InkWell(
            onTap: () {
              otpController.clear();
              context.read<LoginBloc>().add(SentOtpEvent(context: context));
            },
            child: Text(
              'Resend OTP',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ))
      ],
    );

    final screenwidth = MediaQuery.of(context).size.width;
    final mainColumn1 = SizedBox(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: constDeviceType == 1 ||
                MediaQuery.of(context).orientation == Orientation.portrait
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.center,
        children: [
          Padding(
            padding: constDeviceType == 1
                ? const EdgeInsets.only(left: 20, right: 20, top: 25) //60
                : const EdgeInsets.only(left: 30, right: 30, top: 30),
            child: txtTitle,
          ),
          Padding(
            padding: constDeviceType == 1
                ? const EdgeInsets.only(left: 20, right: 20, top: 20) //7
                : const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: containerTxtFieldEmail,
          ),
          Padding(
            padding: constDeviceType == 1
                ? const EdgeInsets.only(left: 20, right: 20, top: 20)
                : const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: btnNext,
          ),
          Padding(
            padding: constDeviceType == 1
                ? const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 16)
                : const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 16),
            child: btnForgotPassword,
          ),
        ],
      ),
    );
    final mainColumn2 =
        Consumer<ForgotpswdProvider>(builder: (context, provider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: constDeviceType == 1 ||
                MediaQuery.of(context).orientation == Orientation.portrait
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.center,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
          //   child: containerTitleImg,
          // ),
          Padding(
            padding: constDeviceType == 1
                ? const EdgeInsets.only(left: 20, right: 20, top: 25) //60
                : const EdgeInsets.only(left: 30, right: 30, top: 30),
            child: txtTitle,
          ),
          // Padding(
          //   padding: constDeviceType == 1
          //       ? const EdgeInsets.only(left: 20, right: 20, top: 20) //7
          //       : const EdgeInsets.only(left: 30, right: 30, top: 20),
          //   child: containerTxtFieldEmail,
          // ),
          Padding(
            padding: constDeviceType == 1
                ? const EdgeInsets.only(left: 20, right: 20, top: 15) //35
                : const EdgeInsets.only(left: 30, right: 30, top: 10),
            child: recievepasswordtxt,
          ),
          Visibility(
            visible: mobile_list.isNotEmpty,
            child: Padding(
                padding: constDeviceType == 1
                    ? const EdgeInsets.only(left: 20, right: 20, top: 10) //35
                    : const EdgeInsets.only(left: 30, right: 30, top: 10),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: mobile_list.length,
                      itemBuilder: (context, index) {
                        return phonepasswordcheckbox(
                            context, index, mobile_list[index],
                            isChecked:
                                provider.selectedmobileIndexes.contains(index));
                      }),
                )),
          ),
          Visibility(
            visible: email_list.isNotEmpty,
            child: Padding(
                padding: constDeviceType == 1
                    ? const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10) //35
                    : const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: email_list.length,
                      itemBuilder: (context, index) {
                        return emailpasswordcheckbox(
                            context, index, email_list[index],
                            isChecked:
                                provider.selectedemailIndexes.contains(index));
                      }),
                )),
          ),
          Padding(
            padding: constDeviceType == 1
                ? const EdgeInsets.only(left: 20, right: 20, top: 20)
                : const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: btnSentOTP,
          ),
          Padding(
            padding: constDeviceType == 1
                ? const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 16)
                : const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 16),
            child: btnForgotPassword,
          ),
        ],
      );
    });

    final mainColumn3 = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: constDeviceType == 1 ||
              MediaQuery.of(context).orientation == Orientation.portrait
          ? MainAxisAlignment.spaceEvenly
          : MainAxisAlignment.center,
      children: [
        Padding(
          padding: constDeviceType == 1
              ? const EdgeInsets.only(left: 20, right: 20, top: 25) //60
              : const EdgeInsets.only(left: 30, right: 30, top: 30),
          child: verificationTitle,
        ),
        Padding(
          padding: constDeviceType == 1
              ? const EdgeInsets.only(left: 20, right: 20, top: 15) //35
              : const EdgeInsets.only(left: 30, right: 30, top: 10),
          child: verificationText,
        ),
        Padding(
          padding: constDeviceType == 1
              ? const EdgeInsets.only(
                  left: 20, right: 20, top: 30, bottom: 20) //35
              : const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 20),
          child: otpField(),
        ),
        Padding(
          padding: constDeviceType == 1
              ? const EdgeInsets.only(left: 20, right: 20, top: 20)
              : const EdgeInsets.only(left: 30, right: 30, top: 20),
          child: btnOtpLogin,
        ),
        Padding(
          padding: constDeviceType == 1
              ? const EdgeInsets.only(left: 20, right: 20, top: 10)
              : const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Center(child: btnResentOtp),
        ),
        Padding(
          padding: constDeviceType == 1
              ? const EdgeInsets.only(left: 20, right: 20)
              : const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: btnForgotPassword,
        ),
      ],
    );

    final containerLoginBG =
        Consumer<ForgotpswdProvider>(builder: (context, provider, child) {
      return Container(
          margin: constDeviceType == 1
              ? MediaQuery.of(context).orientation == Orientation.portrait
                  ? EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.04)
                  : EdgeInsets.only(bottom: 0)
              : MediaQuery.of(context).orientation == Orientation.portrait
                  ? EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.05)
                  : EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2),
          width: constDeviceType == 1
              ? MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width * 0.88
                  : MediaQuery.of(context).size.width * 0.6
              : MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width * 0.85
                  : MediaQuery.of(context).size.width * 0.42,
          // height: screenwidth < 380 // for very small width phone like samsung fold
          //     ? 450
          //     :  MediaQuery.of(context).orientation == Orientation.portrait
          //             ? (MediaQuery.of(context).size.height * 0.60) < 350
          //                 ? 300
          //                 : MediaQuery.of(context).size.height * 0.45
          //             : MediaQuery.of(context).size.height * 0.45,
          //         // : MediaQuery.of(context).orientation == Orientation.portrait
          //         //     ?  MediaQuery.of(context).size.height * 0.50
          //         //     : 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.red,
                offset: Offset(
                    4.0, 4.0), // set the offset to control the shadow position
                // blurRadius: 4.0, // set the blur radius to control the shadow intensity
              ),
            ],
          ),
          child: SingleChildScrollView(
              child: provider.otpEmailvalidated
                  ? mainColumn2
                  : provider.otpSent
                      ? mainColumn3
                      : mainColumn1));
    });

    final containerBgImg = SizedBox(
        height: constDeviceType == 1
            ? MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.6 < 350
                    ? MediaQuery.of(context).size.height * 0.45
                    : MediaQuery.of(context).size.height * 0.5
                : MediaQuery.of(context).size.height * 0.7
            : MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.47
                : MediaQuery.of(context).size.height,
        width: constDeviceType == 1 ||
                MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width * 0.55,
        child: Container(
          color: Colors.transparent,
        ));

    final mainRowFoTab = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        containerBgImg,
        SingleChildScrollView(
          child: containerLoginBG,
        ),
      ],
    );

    final mainStack = Stack(
      children: [
        Visibility(
          visible: (constDeviceType == 2) ||
              (constDeviceType == 1 &&
                  MediaQuery.of(context).orientation == Orientation.portrait &&
                  screenwidth > 350),
          child: Positioned(
            top: constDeviceType == 1
                ? MediaQuery.of(context).size.height * 0.06
                : MediaQuery.of(context).orientation == Orientation.portrait
                    ? 0
                    : MediaQuery.of(context).size.height * 0.15,
            child: SizedBox(
              height: constDeviceType == 1 ? 350 : 500,
              width: constDeviceType == 1 ? 400 : 650,
              child: Image.asset(
                img_forgot_password_key_image,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Visibility(
          visible: constDeviceType == 1 ||
              MediaQuery.of(context).orientation == Orientation.portrait,
          child: MediaQuery.of(context).orientation == Orientation.portrait
              ? Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: containerLoginBG,
                  ),
                )
              : Container(
                  color: Colors.transparent,
                  // height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: containerLoginBG,
                  ),
                ),
        ),
        Visibility(
          visible: constDeviceType == 2 &&
              MediaQuery.of(context).orientation == Orientation.landscape,
          child: mainRowFoTab,
        ),
        Visibility(
          visible: false, //isLoading,
          child: Container(
            color: color_black_overlay,
            child: Center(
              child: progressIndicator(),
            ),
          ),
        ),
      ],
    );

    return Container(
      color: Color(0xfffef8f8),
      height: MediaQuery.of(context).size.height,
      child: mainStack,
    );
  }

  TextField widgetTxtField(
      String txtValue,
      String fontName,
      double txtFontSize,
      Color txtColor,
      FontWeight fontWt,
      TextEditingController txtController,
      int status) {
    return TextField(
      // cursorColor: Colors.black,
      autocorrect: false,
      autofocus: false,
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.emailAddress,
      obscureText: false,
      textInputAction: TextInputAction.done,
      controller: txtEmailController,
      decoration: setupTxtFieldDecoration(txtValue, status),
      style: TextStyle(
        color: txtColor,
        fontSize: txtFontSize,
        // fontFamily: fontName,
        fontWeight: fontWt,
      ),
      onEditingComplete: () => FocusScope.of(context).unfocus(),
    );
  }

  InputDecoration setupTxtFieldDecoration(String strHint, int status) {
    return InputDecoration(
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      contentPadding: const EdgeInsets.only(left: 0),
      // contentPadding: EdgeInsets.only(left: 16.0, bottom: 10.0),
      hintText: strHint,

      hintStyle: const TextStyle(
        color: Colors.black26,
        fontSize: 16.0,
        // fontFamily: FONT_PRODUCT_SANS,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  otpField() {
    // 6 digit otpfield by pinput package
    return Pinput(
      length: 6,
      controller: otpController,
      focusNode: focusNode,
      // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
      // listenForMultipleSmsOnAndroid: true,
      defaultPinTheme: PinTheme(
          width: 56,
          height: 56,
          textStyle: TextStyle(fontSize: 30),
          decoration: BoxDecoration(
            color: Color(0xffEEF5FF),
            borderRadius: BorderRadius.circular(10),
          )),
      focusedPinTheme: PinTheme(
        width: 56,
        height: 56,
        textStyle: TextStyle(fontSize: 30),
        decoration: BoxDecoration(
          color: Color(0xffEEF5FF),
          border: Border.all(
            color: Color(0xffB4D4FF), // Change color for focus
            width: 2, // Increase width for bolder appearance
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: (value) {
        otpEntered = value;
      },
    );
  }

  void showAlert(String strMsg, int status) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: Text(
          strMsg,
          overflow: TextOverflow.visible,
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
              if (status == 1) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
