import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cybersquare/globals.dart';
import 'package:cybersquare/logic/blocs/login/login_bloc.dart';
import 'package:cybersquare/logic/providers/course_detail_screen_provider.dart';
import 'package:cybersquare/logic/providers/exam_screen_provider.dart';
import 'package:cybersquare/logic/providers/forgotpassword_model.dart';
import 'package:cybersquare/logic/providers/fullscreen_provider.dart';
import 'package:cybersquare/logic/providers/project_screen_provider.dart';
import 'package:cybersquare/myapp.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  Config.isProduction = DevConfig.isProduction;
  Config.urlBase2 = DevConfig.urlBase2;
  Config.urlIdentityService = DevConfig.urlIdentityService;
  Config.urlCourseWebview = DevConfig.urlCourseWebview;
  Config.urlActivityWebview = DevConfig.urlActivityWebview;
  Config.urlCsLab = DevConfig.urlCsLab;
  Config.urlBaseImage = DevConfig.urlBaseImage;

  await Upgrader.clearSavedSettings();
  final upgrader = Upgrader(
    storeController: UpgraderStoreController(
        oniOS: () => UpgraderAppStore(),
        onAndroid: () => UpgraderPlayStore(),
    ),
  );
  await upgrader.initialize();


  runApp( MultiBlocProvider(
    providers: [
    // Provider<ForgotpswdProvider>(create: (_) => ForgotpswdProvider()),
    ChangeNotifierProvider(create: (_) => ForgotpswdProvider()),
    ChangeNotifierProvider(create: (_) => courseProvider()),
    ChangeNotifierProvider(create: (_) => FullScreenProvider()),
    // ChangeNotifierProvider(create: (_) => ExamResultProvider()),
    ChangeNotifierProvider(create: (_) => ExamScreenProvider()),
    // ChangeNotifierProvider(create: (_) => TrainingSessionsProvider()),
    ChangeNotifierProvider(create: (_) => ProjectScreenProvider()),
    BlocProvider(create: (context) => LoginBloc()),
  ],
    child: MyApp(upgrader: upgrader,)));
}

class TrainingSessionsProvider {
}

class ExamResultProvider {
}