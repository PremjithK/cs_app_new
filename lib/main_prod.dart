import 'package:cybersquare/logic/blocs/login/login_bloc.dart';
import 'package:cybersquare/logic/providers/course_detail_screen_provider.dart';
import 'package:cybersquare/logic/providers/exam_screen_provider.dart';
import 'package:cybersquare/logic/providers/forgotpassword_model.dart';
import 'package:cybersquare/logic/providers/fullscreen_provider.dart';
import 'package:cybersquare/logic/providers/project_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:cybersquare/globals.dart';
import 'package:cybersquare/myapp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Config.isProduction = ProdConfig.isProduction;
  Config.urlBase2 = ProdConfig.urlBase2;
  Config.urlIdentityService = ProdConfig.urlIdentityService;
  Config.urlCourseWebview = ProdConfig.urlCourseWebview;
  Config.urlActivityWebview = ProdConfig.urlActivityWebview;
  Config.urlCsLab = ProdConfig.urlCsLab;
  Config.urlBaseImage = ProdConfig.urlBaseImage;

  await Upgrader.clearSavedSettings();
  final upgrader = Upgrader(
    storeController: UpgraderStoreController(
      oniOS: () => UpgraderAppStore(),
      onAndroid: () => UpgraderPlayStore(),
    ),
  );
  await upgrader.initialize();

  runApp(
    MultiBlocProvider(
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
      child: MyApp(upgrader: upgrader),
    ),
  );
}
class TrainingSessionsProvider {}

class ExamResultProvider {}
