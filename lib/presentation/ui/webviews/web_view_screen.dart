// import 'dart:io';

// import 'package:cybersquare/core/constants/colors.dart';
// import 'package:cybersquare/core/utils/user_info.dart';
// import 'package:cybersquare/logic/providers/course_detail_screen_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class WebViewScreen extends StatefulWidget {
//   final String? strUrl;
//   final String? strTitle;
//   final int? screenStatus;
//   final ValueChanged<int>? onSubmitBtnPressed;
//   final Orientation? currentOrientation;


//   const WebViewScreen({
//     Key? key,
//     @required this.strUrl,
//     @required this.strTitle,
//     @required this.screenStatus,
//     this.currentOrientation,
//     this.onSubmitBtnPressed,
//   }) : super(key: key);
//   static const routeName = "/WebViewScreen";
//   @override
//   _WebViewScreenState createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   bool isLoading = false;
//   bool showHide = false;
//   bool hideText = false;
//   WebViewController? _webViewController;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if(widget.strTitle == "Geeky bird game" || widget.strTitle == "Geeky bird programmable"){
//       setState(() {
//         showHide =true;
//       });
//     }

//     if(widget.screenStatus == 1){
//       landscapeModeOnly();
//     }
//     if (Platform.isAndroid) WebView.platform = AndroidWebView();
//   }

//   @override
//   void dispose() {

//     if(widget.screenStatus == 1){
//       if((widget.currentOrientation ?? MediaQuery.of(context).orientation) == Orientation.portrait) {
//         portraitModeOnly();
//         portraitModeOnly();
//       }
//       widget.onSubmitBtnPressed!(1);
//     }

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: color_bg_white,
//        appBar: widget.strTitle == "CS Lab"
//           ? setupAppbar(
//               context, widget.strTitle ?? "",
//               status: 2, loaderStatus: isLoading, avatar: Userlogo)
//           : hideText
//               ? null
//               : setupAppbarWithBack(context, widget.strTitle ?? "",
//                   status: 2,
//                   loaderStatus: isLoading,
//                   hidebar: showHide,
//                   hideText: hideText,
//                   isFromDrawer:
//                       true),
//       drawer: AppDrawer(avatar: Userlogo,),
//       body: Stack(
//         children:[
//           WillPopScope(
//             onWillPop: () => _handleBack(),
//             child: WebView(
//               gestureNavigationEnabled: true,
//               debuggingEnabled: true,
//               initialUrl: widget.strUrl,
//               javascriptMode: JavascriptMode.unrestricted,
//               onWebViewCreated: (WebViewController webViewController) {
//                 _webViewController = webViewController;
//               },
//               navigationDelegate: (NavigationRequest request) async {
//                 if (request.url.startsWith('http') && request.url != widget.strUrl && !request.url.contains("youtube.com")) {
//                   Uri uri = Uri.parse(request.url);
//                   if (await canLaunchUrl(uri)) {
//                     await launchUrl(uri);
//                     _webViewController!.goBack();
//                     return NavigationDecision.prevent;
//                   }
//                 }
//                 return NavigationDecision.navigate;
//               },
//               onPageStarted: (String url) {
//                 setState(() {
//                   isLoading = true;
//                 });
//               },
//               onProgress: (int progress) {
//               },
//               onPageFinished: (String url) async {
//                 setState(() {
//                   isLoading = false;
//                 });
//               },
//               onWebResourceError: (resourceError) {
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: showHide ==true ? FloatingActionButton(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         child: Icon(hideText?Icons.fullscreen_exit:Icons.fullscreen,color: Colors.black87,size: 26,),
//         onPressed: () => setState(() => hideText = !hideText),
//         tooltip: "Full Screen",
//       ):null,
//     );
//   }
//   Future<bool> _handleBack() async {
//     final prov = Provider.of<courseProvider>(context,listen: false);
//     prov.setmenuIndex(100);
//     if (_webViewController != null && await _webViewController!.canGoBack()) {
//       await _webViewController!.goBack();
//       return false; // Prevent app-level pop
//     } else {
//        Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => DashboardScreen(''))));
//       return false; 
//     }
//   }
// }