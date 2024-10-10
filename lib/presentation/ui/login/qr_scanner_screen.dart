
import 'dart:io';

import 'package:cybersquare/core/constants/asset_images.dart';
import 'package:cybersquare/core/constants/colors.dart';
import 'package:cybersquare/logic/blocs/login/login_bloc.dart';
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
        String qrcodedata = scanData.code.toString();
        context.read<LoginBloc>().add(QrSignEvent(context: context, qrcodeData: qrcodedata));
        _controller!.resumeCamera();
        
      });
    });
  }

  pickfiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    _controller!.pauseCamera();
    _isScanning.value = true;
    if (result != null) {
      var str = await Scan.parse(result.files.single.path!);
      context.read<LoginBloc>().add(QrSignEvent(context: context, qrcodeData: str!));
    }else{
      _isScanning.value = false;
      showAlert("Invalid QR code");
    }
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
}