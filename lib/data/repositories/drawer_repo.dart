import 'package:cybersquare/core/constants/api_endpoints.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:cybersquare/core/services/api_services.dart';
import 'package:http/http.dart' as http;

Future<http.Response> getMenuDataApi() async {
  Map<String, dynamic> payload = {
    "userLoginId": constLoginUserId,
    "ismobile": true,
    "from": "mobile"
  };
  Map<String, String> headerData = {
    "authorization": constUserToken,
  };

  String uri = url_base2 + url_side_menu;

  final response = await postMethodApi(payload, uri, headerData);
  return response;
}
