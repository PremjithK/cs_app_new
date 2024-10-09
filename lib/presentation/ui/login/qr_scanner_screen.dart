
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cybersquare/core/constants/api_endpoints.dart';
import 'package:cybersquare/core/constants/asset_images.dart';
import 'package:cybersquare/core/constants/colors.dart';
import 'package:cybersquare/core/constants/const_strings.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:cybersquare/core/services/analytics.dart';
import 'package:cybersquare/core/services/api_services.dart';
import 'package:cybersquare/core/utils/user_info.dart';
import 'package:cybersquare/logic/blocs/login/login_bloc.dart';
import 'package:cybersquare/logic/providers/course_detail_screen_provider.dart';
import 'package:cybersquare/presentation/widgets/common_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';

class QRscanner extends StatefulWidget {
  const QRscanner({Key? key}) : super(key: key);
  static ValueNotifier<bool> isScanning = ValueNotifier(false);

  @override
  State<QRscanner> createState() => _QRscannerState();
}

class _QRscannerState extends State<QRscanner> {
  QRViewController? _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool flashON = false;
  bool courseEmpty = false;
  static ValueNotifier<bool> _isScanning = QRscanner.isScanning;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    } else if (Platform.isIOS) {
      _controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Image.asset(
                img_cybersquare_logo,
                fit: BoxFit.contain,
                height: 60,
                width: 150
              ),
              centerTitle: true,
          backgroundColor: const Color(0xfffef8f8),
        ),
      body: Stack(
        children: [
          QRView(
          key: _qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(borderRadius: 30, borderColor: color_login_btn, borderLength: 50, borderWidth: 8,),
        ),
        // need a round button for flashligh on and off with flashlight icon
        Positioned(
          bottom: 50,
          left: MediaQuery.of(context).size.width/2 - 25,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white
            ),
            child: IconButton(
            onPressed: () async {
              await _controller?.toggleFlash();
              setState(() {
                if (flashON == true) {
                  flashON = false;
                } else {
                  flashON = true;
                }
              });
            },
            icon: FutureBuilder<bool?>(
              future: _controller?.getFlashStatus(),
              builder: (context, snapshot) {
                return Icon(Icons.flash_on,color: flashON ? Colors.green:Colors.black,);})),
          ),
          
        ),
        Positioned(
          bottom: 120,
          left: MediaQuery.of(context).size.width / 2 - 90,
          child: Container(
            height: 40,
            width: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: TextButton.icon(
              label: const Text('Upload from gallery',style: TextStyle(
                fontSize: 12,
                color: Colors.black
              ),),
              onPressed: () {
                pickfiles();
              },
              icon: const Icon(
                Icons.image_outlined,
                color: Colors.black,
                size: 16,
              ),
            ),
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _isScanning,
          builder: (context, IsScanning, child) =>  Visibility(
            visible: IsScanning,
            child:  Center(child: progressIndicator())),
        )
        ],
      ),
    );
  }
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
      _controller?.scannedDataStream.listen((scanData) async {
        // Handle the scanned data as desired
        _controller!.pauseCamera();
        context.read<LoginBloc>().add(QrSignEvent());
        try {
            String qrcodedata = scanData.code.toString();
            await loginlmsToken(qrcodedata);
            await loadloguserdata();
        } catch (e) {
          showAlertforinvalidQR("Invalid QR code");
        }
        _controller!.resumeCamera();
        
      });
    });
  }

  loginlmsToken(String qrcodeData) async{
    //postmethodapi with status code 200 , 400 and 500
    if (constIsConnectedToInternet) {
      String strUrl = "${url_identity_service}loginWithQrCode";
      Platform.isAndroid ? PlatformOs = "android" : PlatformOs = "ios";

      var postData = {
        "qrCodeLoginId" : qrcodeData,
        "os" : PlatformOs,
        "from": "Mobile"
      };

      var headerData = {
        'Content-Type': 'application/json; charset=UTF-8',
        "authorization": constUserToken,
      };

      try {
        final prov = Provider.of<courseProvider>(context,listen: false);
        final response = await postMethodApi(postData, strUrl, headerData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> data = json.decode(response.body);
          constUserToken = data["access_token"];
          constLoginData.addAll(data);
          constLoginStatus = 1;
          constLoginUserId = constLoginData["active_user_data"]["userLoginId"];
          getUserRoleMappingID(constLoginData);
          await getUserActualName(constLoginData);
          getCompanyIDFromActiveUserData(constLoginData);
          await getroleName(constLoginData);
          getUserLogo(constLoginData);
          saveLoginStatus(1);
          saveToken(constUserToken);
          saveLoginData(data);
          await loadCoursesForCandidates();
          if (courseEmpty == true) {
            prov.setmenuIndex(102); //102 is set for cs lab
            Orientation currentOrientation = MediaQuery.of(context).orientation;
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) {
            //         return WebViewScreen(
            //           strUrl: url_cslab+constUserToken,
            //           strTitle: 'CS Lab',
            //           screenStatus: 2,
            //           currentOrientation: currentOrientation,
            //           onSubmitBtnPressed: (int stat) {
            //             enableRotation();
            //           },
            //         );
            //       },
            //       fullscreenDialog: true),
            // );
          } else {
            prov.setmenuIndex(101); //101 is set for course screen
          //   Navigator.pushReplacement<void, void>(
          //   context,
          //   MaterialPageRoute<void>(
          //     builder: (BuildContext context) => CoursesListScreen(screenStatus: 1,strTitle: "",avatar: Userlogo,)
          //   ),
          // );
          }
          await companysettings();
          AnalyticsService.logLoginEvent(loginid: constLoginUserId, userName: constActualUserName, roleName: constRoleName, companyId: constCompanyID, companyName: constcompanyName, status: 'login_successful');
        }
        else{
          AnalyticsService.logLoginEvent(status: 'login_failed');
          showAlert("Failed to login, please try again later");
        }
      } on SocketException catch (_) {
        _isScanning.value = false;
        showAlert(str_some_error_occurred_msg);
      } on TimeoutException catch (_) {
        _isScanning.value = false;
        showAlert(connection_time_out);
      }
    }else {
      _isScanning.value = false;
      showAlert(str_no_network_msg);
    }
  }

  loadloguserdata() async{
    //postmethodapi with status code 200 , 400 and 500
    if (constIsConnectedToInternet) {
      String strUrl = url_base2 + url_load_log_user_data;

      var postData = {
        "UserDataObjId" : constLoginUserId
      };

      var headerData = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      try {
        final response = await postMethodApi(postData, strUrl, headerData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          String decodedData = json.decode(response.body);
          Map<String, dynamic> data = json.decode(decodedData);

          // add access_token key and constloginid value into constLoginData
          constLoginData.addAll(data);
          saveLoginData(constLoginData);
        }
      } on SocketException catch (_) {
        showAlert(str_some_error_occurred_msg);
      } on TimeoutException catch (_) {
        showAlert(connection_time_out);
      }
    }else {
      showAlert(str_no_network_msg);
    }
  }

  companysettings() async {
    if (constIsConnectedToInternet) {
      String strUrl = '${url_base2}company/$constCompanyID';

      try {
        final response = await getMethodApi(strUrl);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> data = json.decode(response.body);
          if (data["companyDetails"] != null) {
            constLoginData.addAll(data);
            saveLoginStatus(1);
            // saveUserLogo(constLoginData);
            getUserLogo(constLoginData);
            // saveconstCompanyID(constLoginData);
            getCompanyIDFromCompanySettings(constLoginData);
            // saveconstCurrentAcademicYearId(constLoginData);
            getCurrentAcademicYearID(constLoginData);
            // String strJson = jsonEncode(data);
            saveLoginData(data);
            if (data["companyDetails"]["company_obj"]?["companyName"] != null) {
              constcompanyName = data["companyDetails"]["company_obj"]["companyName"];
            }
            
          }
        }
        else{
          showAlert("Failed to login, please try again later");
        }
      } on SocketException catch (_) {
        // setState(() {
        //   isLoading = false;
        // });
        showAlert(str_some_error_occurred_msg);
      } on TimeoutException catch (_) {
        setState(() {
          // isLoading = false;
        });
        showAlert(connection_time_out);
      }
    }
  }

  loadCoursesForCandidates()async{
      String strUrl = url_base2 + url_courses_list;

      var postData = {
            // "userLoginId": constLoginUserId,
            // "companyId": constCompanyID,
            "requestFromBatchProgressCandidateSide": ""
          };

      var headerData = {
      "Content-Type": "application/json; charset=UTF-8",
      "authorization": constUserToken,
      };

      try {
        final response = await postMethodApi(postData, strUrl, headerData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> data = json.decode(response.body);
          // Map<String, dynamic> data = json.decode(decodedData);
          if (data["courseObj"].isEmpty) {
            courseEmpty = true;
          }

        }
      } on SocketException catch (_) {
        showAlert(str_some_error_occurred_msg);
      } on TimeoutException catch (_) {
        showAlert(connection_time_out);
      }
  }

  pickfiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    try {
      if (result != null) {
        _controller!.pauseCamera();
        _isScanning.value = true;
        var str = await Scan.parse(result.files.single.path!);
        if (str != null) {
            await loginlmsToken(str);
            await loadloguserdata();
        }else{
          _isScanning.value = false;
          showAlertforinvalidQR("Invalid QR code");
        }
      }
    } catch (e) {
       _isScanning.value = false;
       print(e);
      showAlertforinvalidQR("Invalid QR code");
    }
     _isScanning.value = false;
    _controller!.resumeCamera();
  }

  void showAlert(String strMsg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: Text(strMsg),
        actions: [
          CupertinoDialogAction(
            child: const Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void showAlertforinvalidQR(String strMsg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: Text(strMsg),
        actions: [
          CupertinoDialogAction(
            child: const Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}