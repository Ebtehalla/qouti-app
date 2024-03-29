// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:no_name_ecommerce/model/slider_model.dart';
import 'package:no_name_ecommerce/view/home/no_app_permission_page.dart';
import 'package:no_name_ecommerce/view/utils/api_url.dart';

class SliderService with ChangeNotifier {
  List<SliderItem> sliderImageList = [];
  fetchSlider(BuildContext context) async {
    if (sliderImageList.isNotEmpty) return;

    var response = await http.get(Uri.parse(ApiUrl.sliderUri));

    if (response.statusCode == 200) {
      var data = SliderModel.fromJson(jsonDecode(response.body));

      sliderImageList = data.data;
      notifyListeners();
    } else if (response.statusCode == 403) {
      //no app permission
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const NoAppPermissionPage(),
        ),
      );
    } else {
      print('slider fetch error ${response.body}');
    }
  }
}
