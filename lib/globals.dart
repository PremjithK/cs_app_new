class Config {
  static late bool isProduction;
  static late String urlBase2;
  static late String urlIdentityService;
  static late String urlCourseWebview;
  static late String urlActivityWebview;
  static late String urlCsLab;
  static late String urlBaseImage;
}

class DevConfig extends Config {
  static bool isProduction = false;
  static String urlBase2 = 'https://api-v2.dev99lms.com/';
  static String urlIdentityService = 'https://identity-service.dev99lms.com/';
  static String urlCourseWebview = 'https://cs.dev99lms.com/candidate/#/candidateCourseViewWebView/';
  static String urlActivityWebview = 'https://cs.dev99lms.com/candidate/#/activityWebView/';
  static String urlCsLab ='https://cslab.dev99lms.com/?token=';
  static String urlBaseImage='https://99lmsfileuploadfolder.s3.ap-south-1.amazonaws.com/uploaded_test/';
}

class ProdConfig extends Config {
  static bool isProduction = true;
  static String urlBase2 = 'https://adminapi.99lms.com/';
  static String urlIdentityService = 'https://identity-service.99lms.com/';
  static String urlCourseWebview = 'https://cs.cybersquare.org/candidate/#/candidateCourseViewWebView/';
  static String urlActivityWebview = 'https://cs.cybersquare.org/candidate/#/activityWebView/';
  static String urlCsLab ='https://cslab.cybersquare.org/?token=';
  static String urlBaseImage='https://99lmsfileuploadfolder.s3.ap-south-1.amazonaws.com/uploaded/';
}
