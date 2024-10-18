import 'package:cybersquare/core/constants/api_endpoints.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:cybersquare/core/services/api_services.dart';
import 'package:http/http.dart' as http;

Future<http.Response> getActivitiesApi({
  required int page,
  required int limit,
  String? academicYearSelected,
}) async {
  String strUrl = url_base2 + url_activities;

  var postData = {
    "pageNo": page,
    "limit": limit,
    "fkUserLoginId": constLoginUserId,
    // "fkCompanyId": constCompanyID,
    //  "academicYearId": academicYearSelected??constCurrentAcademicYearId
  };
  if (academicYearSelected != null || constCurrentAcademicYearId != '') {
    postData["academicYearId"] =
        academicYearSelected ?? constCurrentAcademicYearId;
  }
  var headerData = {
    'authorization': constUserToken,
    // 'Content-Type': 'application/json; charset=UTF-8',
    // 'Origin': url_origin,
  };

  final response = await postMethodApi(postData, strUrl, headerData);
  return response;
}
