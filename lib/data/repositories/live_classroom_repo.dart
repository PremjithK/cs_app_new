import 'package:cybersquare/core/constants/api_endpoints.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:cybersquare/core/services/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<http.Response> getLiveClassApi() async {
  DateTime selectedDateTile = DateTime.now();
  final DateFormat formatterMonth = DateFormat('EEE, dd MMM yyyy');
  String strDate = "${formatterMonth.format(selectedDateTile)} 00:00:00 GMT";

  String strUrl = url_base2 + url_get_live_classroom_list;
  //  "https://api-v2.dev99lms.com/companySubscription/MobileApp?companyId=562de15e3c43a07b61c29188";
  Map<String, dynamic> postData = {
    "rmId": constRoleMappingId, //"5b39f777a9dbfc0664b9dd25",//
    "userLoginId": constLoginUserId, //"5b39f777a9dbfc0664b9dd26",//
    "date": strDate, //"Tue, 07 Dec 2021 00:00:00 GMT",
    "companyId": constMainCompanyID, //"562de15e3c43a07b61c29188",//
    "childCompanyId": constCompanyID,
  };
  Map<String, String> headerData = {
    "Content-Type": "application/json; charset=UTF-8",
    "authorization": constUserToken,
  };

  final response = await postMethodApi(postData, strUrl, headerData);

  return response;
}
