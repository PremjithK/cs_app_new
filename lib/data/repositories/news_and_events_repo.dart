import 'package:cybersquare/core/constants/api_endpoints.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:cybersquare/core/services/api_services.dart';
import 'package:http/http.dart' as http;

Future<http.Response> getNewsAndEventsApi() async {
  String strUrl = url_base2 + url_news_events;

  var postData = {
    "offset": 0,
    "limit": 3,
    "fkCompanyId": constCompanyID,
  };

  var headerData = {
    'authorization': constUserToken,
    // 'Content-Type': 'application/json; charset=UTF-8',
    // 'Origin': url_origin,
  };

  final response = await postMethodApi(postData, strUrl, headerData);

  return response;
}
