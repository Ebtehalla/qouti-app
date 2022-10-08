import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:no_name_ecommerce/services/country_states_service.dart';
import 'package:no_name_ecommerce/services/profile_service.dart';
import 'package:no_name_ecommerce/view/utils/config.dart';
import 'package:no_name_ecommerce/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditService with ChangeNotifier {
  XFile? imageFile;

  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  final ImagePicker _picker = ImagePicker();
  Future pickImage() async {
    imageFile = await _picker.pickImage(source: ImageSource.gallery);
    notifyListeners();
    if (imageFile != null) {
      return imageFile;
    } else {
      return null;
    }
  }

  setDefault() {
    imageFile = null;
    notifyListeners();
  }

  String countryCode = 'BD';

  setCountryCode(code) {
    countryCode = code;
    notifyListeners();
  }

  updateProfile(name, email, phone, zip, address, context) async {
    setLoadingTrue();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var countryId = Provider.of<CountryStatesService>(context, listen: false)
        .selectedCountryId;

    var stateId = Provider.of<CountryStatesService>(context, listen: false)
        .selectedStateId;

    var dio = Dio();
    // dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers["Authorization"] = "Bearer $token";

    var formData;
    if (imageFile != null) {
      formData = FormData.fromMap({
        'name': name,
        'email': email,
        'phone': phone,
        'file': await MultipartFile.fromFile(imageFile!.path,
            filename: 'profileImage$name$zip${imageFile!.path}.jpg'),
        'country': countryId,
        'state': stateId,
        'address': address,
        'zipcode': zip,
        'country_code': countryCode
      });
    } else {
      formData = FormData.fromMap({
        'name': name,
        'email': email,
        'phone': phone,
        'country': countryId,
        'state': stateId,
        'address': address,
        'zipcode': zip,
        'country_code': countryCode
      });
    }
    var response = await dio.post(
      '$baseApi/user/update-profile',
      data: formData,
    );

    if (response.statusCode == 201) {
      setLoadingFalse();
      OthersHelper().showToast('Profile updated successfully', Colors.black);
      print(response.data);
      Navigator.pop(context);

      //re fetch profile data again
      Provider.of<ProfileService>(context, listen: false)
          .getProfileDetails(isFromProfileupdatePage: true);
      return true;
    } else {
      setLoadingFalse();
      print('error updating profile' + response.data);
      OthersHelper().showToast('Something went wrong', Colors.black);
      return false;
    }
  }

  // Future submitSubscription(name, email, phone, cityId, areaId, countryId,
  //     postCode, address, about, context, File file, String filename) async {
  //   setLoadingTrue();

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString('token');

  //   ///MultiPart request
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse(
  //         "https://nazmul.xgenious.com/qixer_with_api/api/v1/user/update-profile"),
  //   );
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Authorization": "Bearer $token",
  //     // "Content-type": "multipart/form-data"
  //   };
  //   request.files.add(
  //     http.MultipartFile(
  //       'file',
  //       file.readAsBytes().asStream(),
  //       file.lengthSync(),
  //       filename: filename,
  //       // contentType: MediaType('image','jpeg'),
  //     ),
  //   );
  //   request.headers.addAll(headers);
  //   request.fields.addAll({
  //     'name': 'ccc',
  //     'email': 'c@c',
  //     'phone': '554',
  //     'service_city': '2',
  //     'service_area': '2',
  //     'country_id': '2',
  //     'post_code': '222',
  //     'address': 'asdfa',
  //     'about': 'asdsfd'
  //   });
  //   print("request: " + request.toString());
  //   var res = await request.send();
  //   print("This is response:" + res.toString());
  //   print(res.statusCode);
  //   setLoadingFalse();
  //   if (res.statusCode == 201) {
  //     Navigator.pop(context);
  //     Provider.of<ProfileService>(context, listen: false).getProfileDetails();
  //   } else {
  //     OthersHelper().showToast(
  //         'Something went wrong. status code ${res.statusCode}', Colors.black);
  //   }
  //   return true;
  // }
}