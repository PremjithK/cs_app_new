import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cybersquare/presentation/ui/login/forgot_password_screen.dart';
import 'package:cybersquare/presentation/ui/login/qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cybersquare/core/constants/asset_images.dart';
import 'package:cybersquare/core/constants/colors.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:cybersquare/core/utils/common_functions.dart';
import 'package:cybersquare/logic/blocs/login/login_bloc.dart';
import 'package:cybersquare/logic/providers/forgotpassword_model.dart';
import 'package:cybersquare/presentation/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final txtEmailController = TextEditingController();
  final txtPasswordController = TextEditingController();
  final txtDomainController = TextEditingController();
  final FocusNode _domainfocusNode = FocusNode();
  int statShowPassword = 0;
  int statSignedIn = 0;
  bool isLoading = false;
  String avatar = "";
  String? domain;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  Orientation currentOrientation = Orientation.landscape;
  // Companies? dropdownvalue;
  bool _isEnabled = false;
  // GetDomainModel user = GetDomainModel();
  bool courseEmpty = false;

  void initState() {
    // TODO: implement initState
    super.initState();
    currentOrientation = Orientation.landscape;
    initConnectivity();
    _domainfocusNode.addListener(_onFocusChange);
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
    } on PlatformException catch (e) {
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
    } else {
      setState(() {
        constIsConnectedToInternet = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return GestureDetector(
          onTap: () {},
          child: setupView(),
        );

        // if (constraints.maxWidth < 600) {
        //   return Container(
        //     height: double.infinity,
        //     width: double.infinity,
        //     color: Colors.red,);
        // } else {
        //   return Container(
        //     height: double.infinity,
        //     width: double.infinity,
        //     color: Colors.blue
        //   );
        // }
      }),
    );
  }

  Widget setupView() {
    bool smallScreen = MediaQuery.of(context).size.height < 800;

    final welcometxt = widgetText(
        "Welcome!",
        "",
        smallScreen
            ? 25
            : constDeviceType == 1
                ? 30
                : 24,
        color_login_text_black,
        TextAlign.left,
        FontWeight.w700,
        0);
    final txtTitle = widgetText(
        "1. Open your Cyber Square account on any web browser.\n2. Find the QR code on your dashboard.\n3. Scan the QR code using mobile app to securely login to your account.",
        "",
        constDeviceType == 1 ? 14 : 18,
        color_login_text_black,
        TextAlign.left,
        FontWeight.normal,
        0);
    final txtInst = widgetText(
        institute, "", 15, Colors.black54, TextAlign.left, FontWeight.w700, 0);

    final txtEmail = widgetText("User name", "", constDeviceType == 1 ? 14 : 16,
        color_login_text_black, TextAlign.left, FontWeight.w400, 0);

    final txtDomain = widgetText(
        "School Domain",
        "",
        constDeviceType == 1 ? 14 : 16,
        color_login_text_black,
        TextAlign.left,
        FontWeight.w400,
        0);

    final containerTxtFieldEmail = Container(
      height: constDeviceType == 1 ? 50 : 60,
      decoration: BoxDecoration(
        color: Colors.white,
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

    final txtPassword = widgetText(
      "Password",
      "",
      constDeviceType == 1 ? 14 : 16,
      color_login_text_black,
      TextAlign.left,
      FontWeight.w400,
      0,
    );

    final btnHide = SizedBox(
      width: 30,
      // color: Colors.green,
      child: Center(
        child: IconButton(
          highlightColor: Colors.transparent,
          onPressed: () {
            setState(() {
              if (statShowPassword == 1) {
                statShowPassword = 0;
              } else {
                statShowPassword = 1;
              }
            });
          },
          icon: Icon(
            statShowPassword == 1 ? Icons.visibility_off : Icons.visibility,
            color: color_login_text_black,
            size: 22,
          ),
        ),
      ),
    );

    iconValidate(int status) {
      return SizedBox(
        width: 30,
        // color: Colors.green,
        child: Center(
          child: status == 1
              ? const SizedBox()
              : status == 2
                  ? LoadingAnimationWidget.fourRotatingDots(
                      color: color_cybersquare_red, size: 25)
                  : status == 3
                      ? const Icon(
                          FontAwesomeIcons.check,
                          color: Colors.green,
                          size: 25,
                        )
                      : status == 4
                          ? const Icon(
                              FontAwesomeIcons.xmark,
                              color: Colors.red,
                              size: 25,
                            )
                          : const SizedBox(),
        ),
      );
    }

    final rowPassword = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: widgetTxtField(
              "Enter your password",
              "",
              constDeviceType == 1 ? 15 : 16,
              color_login_text_gray,
              FontWeight.w400,
              txtPasswordController,
              2),
        ),
        btnHide,
      ],
    );

    final rowDomain = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: widgetTxtField(
              "Enter school URL",
              "",
              constDeviceType == 1 ? 15 : 16,
              color_login_text_gray,
              FontWeight.w400,
              txtPasswordController,
              3),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              // 1 = loading, 2 = valid, 3 = invalid
              if (state is LoginInitial) {
                return iconValidate(1);
              } else if (state is LoadingState) {
                return iconValidate(2);
              } else if (state is DomainValid) {
                return iconValidate(3);
              } else if (state is DomainInvalid || state is OtpDomainInvalid) {
                return iconValidate(4);
              } else {
                return iconValidate(5);
              }
            },
          ),
        )
      ],
    );

    final containerTxtFieldPassword = Container(
      height: constDeviceType == 1 ? 50 : 60,
      width: MediaQuery.of(context).size.width - 32,
      decoration: BoxDecoration(
        // color: Colors.yellow,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: color_login_border_gray),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: rowPassword,
      ),
    );

    final containerTxtFieldDomain = Column(
      children: [
        Container(
          height: constDeviceType == 1 ? 50 : 60,
          width: MediaQuery.of(context).size.width - 32,
          decoration: BoxDecoration(
            // color: Colors.yellow,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: color_login_border_gray),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: rowDomain,
          ),
        ),
        Align(
            alignment: Alignment.topLeft,
            child: widgetText('School URL eg: Example.cybersquare.org', '', 12,
                const Color(0xffA7A7A7), TextAlign.left, FontWeight.w400, 0))
      ],
    );

    final btnQrscan = Container(
      width: constDeviceType == 1 ? 30 : 30,
      height: smallScreen
          ? 35
          : constDeviceType == 1
              ? 45
              : 55,
      decoration: BoxDecoration(
        border: Border.all(
          color: color_cybersquare_red,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner_sharp,
              color: color_cybersquare_red,
              size: smallScreen ? 15 : 20,
            ),
            const SizedBox(
              width: 10,
            ),
            widgetText(
              "Login with QR",
              "",
              smallScreen
                  ? 14
                  : constDeviceType == 1
                      ? 16
                      : 17,
              color_cybersquare_red,
              TextAlign.center,
              FontWeight.w400,
              0,
            ),
          ],
        ),
        onTap: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => QRscanner()));
        },
      ),
    );

    final btnLogin = SizedBox(
      width: constDeviceType == 1 ? 30 : 30,
      height: smallScreen
          ? 35
          : constDeviceType == 1
              ? 45
              : 55,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0))),
          backgroundColor: MaterialStateProperty.all<Color>(
            color_login_btn,
          ),
        ),
        child: widgetText(
          "Sign In",
          "",
          smallScreen
              ? 14
              : constDeviceType == 1
                  ? 16
                  : 17,
          Colors.white,
          TextAlign.center,
          FontWeight.w400,
          0,
        ),
        onPressed: () async {
          if (txtDomainController.text.isEmpty) {
            showAlert(context: context, strMsg: "Please enter domain");
          } else if (constCompanyID == '') {
            showAlert(context: context, strMsg: 'Invalid domain');
          } else if (txtEmailController.text.isEmpty) {
            showAlert(context: context, strMsg: "Please enter Username");
          } else {
            const bool isValid = true;
            //     EmailValidator.validate(txtEmailController.text);
            if (isValid == false) {
              showAlert(context: context, strMsg: "Please enter valid email");
            } else if (txtPasswordController.text.isEmpty) {
              showAlert(context: context, strMsg: "Please enter Password");
            } else {
              FocusScope.of(context).unfocus();
              // setState(() {
              //   isLoading = true;
              // });
              // login();
              context.read<LoginBloc>().add(SignEvent(
                  context: context,
                  username: txtEmailController.text,
                  password: txtPasswordController.text));
              // await companysettingsApi();
              // await loginaccestoken();
              // await loadUserProfileDetails();
              // await loadloguserdata();
            }
          }
        },
      ),
    );

    final btnForgotPassword = BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is OtpDomainValid) {
          final provider =
              Provider.of<ForgotpswdProvider>(context, listen: false);
          provider.setotpEmailvalidated(false);
          provider.setotpSent(false);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) {
                  return ForgotPasswordScreen();
                  // newscreen();
                },
                fullscreenDialog: true),
          );
        } else if (state is OtpDomainInvalid) {
          showAlert(context: context, strMsg: 'Invalid domain!');
        }
      },
      child: TextButton(
        onPressed: () {
          if (txtDomainController.text.isEmpty) {
            showAlert(context: context, strMsg: 'Please enter domain');
          } else {
            context.read<LoginBloc>().add(OtpDomainValidationEvent(context,
                domain: txtDomainController.text));
          }
        },
        child: widgetText(
          "Sign In using OTP",
          "",
          smallScreen
              ? 12
              : constDeviceType == 1
                  ? 14
                  : 16,
          color_cybersquare_red,
          TextAlign.center,
          FontWeight.w400,
          0,
        ),
      ),
    );

    final OrDivider = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xffDFDFDF),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        widgetText(
          "or",
          "",
          constDeviceType == 1 ? 14 : 16,
          const Color(0xffA7A7A7),
          TextAlign.center,
          FontWeight.w400,
          0,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xffDFDFDF),
          ),
        ),
      ],
    );

    final mainColumn = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: constDeviceType == 1 ||
                MediaQuery.of(context).orientation == Orientation.portrait
            ? MainAxisAlignment.center
            : MainAxisAlignment.center,
        children: [
          Padding(
            padding: constDeviceType == 1
                ? const EdgeInsets.only(left: 20, right: 20, top: 10) //60
                : const EdgeInsets.only(left: 30, right: 30, top: 40),
            child: welcometxt,
          ),
          Padding(
            padding: smallScreen
                ? const EdgeInsets.only(left: 20, right: 20, top: 10)
                : constDeviceType == 1
                    ? const EdgeInsets.only(left: 20, right: 20, top: 15) //35
                    : const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: txtDomain,
          ),
          Padding(
            padding: constDeviceType == 1
                ? const EdgeInsets.only(left: 20, right: 20, top: 10) //7
                : const EdgeInsets.only(left: 30, right: 30, top: 10),
            child: containerTxtFieldDomain,
          ),
          Padding(
            padding: smallScreen
                ? const EdgeInsets.only(left: 20, right: 20, top: 10)
                : constDeviceType == 1
                    ? const EdgeInsets.only(left: 20, right: 20, top: 15) //35
                    : const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: txtEmail,
          ),
          Padding(
            padding: constDeviceType == 1
                ? const EdgeInsets.only(left: 20, right: 20, top: 10) //7
                : const EdgeInsets.only(left: 30, right: 30, top: 10),
            child: containerTxtFieldEmail,
          ),
          Padding(
            padding: smallScreen
                ? const EdgeInsets.only(left: 20, right: 20, top: 10)
                : constDeviceType == 1
                    ? const EdgeInsets.only(left: 20, right: 20, top: 15) //20
                    : const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: txtPassword,
          ),
          Padding(
            padding: constDeviceType == 1
                ? const EdgeInsets.only(left: 20, right: 20, top: 10) //7
                : const EdgeInsets.only(left: 30, right: 30, top: 10),
            child: containerTxtFieldPassword,
          ),
          Padding(
            padding: constDeviceType == 1
                ? const EdgeInsets.only(left: 20, right: 20, top: 20)
                : const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: btnLogin,
          ),
          Padding(
            padding: constDeviceType == 1
                ? const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  )
                : const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
            child: btnForgotPassword,
          ),
          Padding(
            padding: constDeviceType == 1
                ? const EdgeInsets.only(left: 20, right: 20, top: 0)
                : const EdgeInsets.only(left: 20, right: 20, top: 0),
            child: OrDivider,
          ),
          Padding(
            padding: smallScreen
                ? const EdgeInsets.only(left: 20, right: 20, bottom: 20)
                : constDeviceType == 1
                    ? const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 25)
                    : const EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 30),
            child: btnQrscan,
          ),
        ],
      ),
    );

    final containerLoginBG = Container(
      margin: constDeviceType == 1
          ? EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05)
          : MediaQuery.of(context).orientation == Orientation.portrait
              ? EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.05)
              : EdgeInsets.only(
                  top: (MediaQuery.of(context).size.height -
                          (MediaQuery.of(context).size.height * 0.65)) /
                      2,
                  left: MediaQuery.of(context).size.width * 0.03),
      width: constDeviceType == 1
          ? MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.88
              : MediaQuery.of(context).size.width * 0.6
          : MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.75
              : MediaQuery.of(context).size.width * 0.4,
      height: constDeviceType == 1
          ? MediaQuery.of(context).orientation == Orientation.portrait
              ? null
              : MediaQuery.of(context).size.shortestSide * 0.9
          : null,
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
      child: mainColumn,
    );
    final containerBgImg = SizedBox(
        height: constDeviceType == 1
            ? MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.6 < 450
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
          visible: constDeviceType == 1 ||
              MediaQuery.of(context).orientation == Orientation.portrait,
          child: containerBgImg,
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
        Visibility(
          visible: constDeviceType == 2 &&
              MediaQuery.of(context).orientation == Orientation.landscape,
          child: mainRowFoTab,
        ),
        Positioned(
          bottom: 0,
          child: Visibility(
            visible: constDeviceType == 1 ||
                MediaQuery.of(context).orientation == Orientation.portrait,
            child: MediaQuery.of(context).orientation == Orientation.portrait
                ? Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: containerLoginBG,
                    ),
                  )
                : Container(
                    color: const Color.fromARGB(0, 185, 48, 48),
                    // height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: containerLoginBG,
                    ),
                  ),
          ),
        ),
        Align(
          // MediaQuery.of(context).orientation == Orientation.portrait?  Alignment.topCenter : Alignment.topLeft,
          alignment: MediaQuery.of(context).orientation == Orientation.portrait
              ? Alignment.topCenter
              : Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
                top: smallScreen
                    ? 10
                    : constDeviceType == 1
                        ? MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? 50
                            : 0
                        : 70,
                left: constDeviceType == 1
                    ? 0
                    : MediaQuery.of(context).orientation == Orientation.portrait
                        ? 0
                        : 50),
            child: Image.asset(img_cybersquare_logo,
                fit: BoxFit.contain,
                height: constDeviceType == 1 ? 100 : 150,
                width: constDeviceType == 1 ? 170 : 270),
          ),
        ),
        Visibility(
          visible: (constDeviceType == 2) ||
              (constDeviceType == 1 &&
                  MediaQuery.of(context).orientation == Orientation.portrait),
          child: Positioned(
            top: constDeviceType == 1
                ? MediaQuery.of(context).size.height * 0.12
                : MediaQuery.of(context).orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.height * 0.18
                    : MediaQuery.of(context).size.height * 0.25,
            left: constDeviceType == 1
                ? MediaQuery.of(context).size.width * 0.45
                : MediaQuery.of(context).orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.width * 0.5
                    : MediaQuery.of(context).size.width * 0.25,
            child: Container(
              height: smallScreen
                  ? MediaQuery.of(context).size.longestSide * 0.2
                  : constDeviceType == 1
                      ? MediaQuery.of(context).size.longestSide * 0.2
                      : MediaQuery.of(context).size.longestSide * 0.35,
              width: constDeviceType == 1 ? 200 : 350,
              child: Image.asset(
                img_login_mascot,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        _isEnabled == true
            ? Positioned(
                top: 30,
                left: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      _isEnabled = false;
                    });
                  },
                ))
            : Container(),
        BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Visibility(
              visible: state is SignLoadingState ? true : false,
              child: Container(
                color: color_black_overlay,
                child: Center(
                  child: progressIndicator(),
                ),
              ),
            );
          },
        ),
      ],
    );

    return Container(
      color: const Color(0xfffef8f8),
      height: MediaQuery.of(context).size.height,
      child: mainStack,
    );
  }

  Text widgetText(String txtValue, String fontName, double txtFontSize,
      Color txtColor, TextAlign txtAlign, FontWeight fontWt, int status) {
    return Text(
      txtValue,
      textAlign: txtAlign,
      style: GoogleFonts.poppins(
        color: txtColor,
        fontSize: txtFontSize,
        // fontFamily: fontName,
        fontWeight: fontWt,
      ),
    );
  }

  void _onFocusChange() {
    // Check if the TextField has lost focus
    if (!_domainfocusNode.hasFocus && txtDomainController.text.isNotEmpty) {
      context.read<LoginBloc>().add(
          DomainValidationEvent(context, domain: txtDomainController.text));
    } else {
      context.read<LoginBloc>().add(LoginInitialEvent());
    }
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
        focusNode: status == 3 ? _domainfocusNode : null,
        textCapitalization: TextCapitalization.none,
        keyboardType:
            status == 1 ? TextInputType.emailAddress : TextInputType.text,
        obscureText: status == 2 && statShowPassword == 0,
        textInputAction:
            status == 1 ? TextInputAction.next : TextInputAction.done,
        controller: status == 1
            ? txtEmailController
            : status == 2
                ? txtPasswordController
                : txtDomainController,
        decoration: setupTxtFieldDecoration(txtValue, status),
        style: GoogleFonts.poppins(
          color: txtColor,
          fontSize: txtFontSize,
          // fontFamily: fontName,
          fontWeight: fontWt,
        ),
        onEditingComplete: () {
          status == 3
              ? context.read<LoginBloc>().add(DomainValidationEvent(context,
                  domain: txtDomainController.text))
              : null;
          status == 1 || status == 3
              ? FocusScope.of(context).nextFocus()
              : FocusScope.of(context).unfocus();
        });
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
        color: Color(0xffa2a2a2),
        fontSize: 16.0,
        // fontFamily: FONT_PRODUCT_SANS,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
