import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:no_name_ecommerce/services/common_service.dart';
import 'package:no_name_ecommerce/view/utils/api_url.dart';
import 'package:no_name_ecommerce/view/utils/translate_strings.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TranslateStringService with ChangeNotifier {
  bool isloading = false;

  var tStrings;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  fetchTranslatedStrings(BuildContext context) async {
    if (tStrings != null) {
      //if already loaded. no need to load again
      return;
    }
    var connection = await checkConnection(context);
    if (connection) {
      //internet connection is on
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      setLoadingTrue();

      var data = jsonEncode({
        'strings': jsonEncode(translateStrings),
      });

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      var response = await http.post(Uri.parse(ApiUrl.translateUri),
          headers: header, body: data);
      if (response.statusCode == 200) {
        tStrings = jsonDecode(response.body)['strings'];
        notifyListeners();
      } else {
        //something went wrong
      }
    }
  }

  getString(String staticString) {
    if (tStrings == null) {
      return staticString;
    }
    if (tStrings.containsKey(staticString)) {
      return tStrings[staticString];
    } else {
      return staticString;
    }
  }
}
