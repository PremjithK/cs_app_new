import 'dart:convert';
import 'package:http/http.dart' as http;


  Future<http.Response> postMethodApi(
      var postData, String strUrl, var header) async {
    http.Client client = http.Client();
    final response = await client
        .post(
          Uri.parse(strUrl),
          headers: header,
          body: jsonEncode(postData),
        )
        .timeout(const Duration(seconds: 30));

    return response;
  }

  Future<http.Response> getMethodApi(String strUrl,
      {queryParams, header}) async {
    Uri uri = Uri.parse(strUrl);
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }
    http.Client client = http.Client();
    final response = await client
        .get(
          uri,
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }