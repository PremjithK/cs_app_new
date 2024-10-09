import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cybersquare/core/constants/api_endpoints.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future logLoginEvent(
      {required String status,
      String? loginid,
      String? userName,
      String? roleName,
      String? companyId,
      String? companyName}) async {
    if (isProduction) {
      await _analytics.logEvent(
        name: 'login_event',
        parameters: {
          'status': status,
          if (loginid != "" && loginid != null) 'user_login_id': loginid,
          if (userName != "" && userName != null) 'user_name': userName,
          if (roleName != "" && roleName != null) 'role_name': roleName,
          if (companyId != "" && companyId != null) 'company_id': companyId,
          if (companyName != "" && companyName != null) 'company_name': companyName,
        },
      );
    }
  }
}