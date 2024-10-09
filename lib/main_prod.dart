import 'package:flutter/material.dart';
import 'package:cybersquare/globals.dart';
import 'package:cybersquare/myapp.dart';
import 'package:upgrader/upgrader.dart';

Future<void> main() async{
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


  runApp( MyApp(upgrader: upgrader,));
}