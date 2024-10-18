import 'package:cybersquare/core/constants/api_endpoints.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:cybersquare/core/services/api_services.dart';
import 'package:http/http.dart';

Future<Response> getAcademicYearApi() async {
  String strUrl = '${url_base2}company/$constCompanyID$url_get_academic_years';
  Map<String, String> headerData = {
    "Content-Type": "application/json; charset=UTF-8",
    "authorization": constUserToken,
  };
  final querparams = {"type": "all"};
  final Response response = await getMethodApi(
    strUrl,
    header: headerData,
    queryParams: querparams,
  );

  return response;
}
