import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:intl/intl.dart';
import 'package:no_name_ecommerce/services/campaign_service.dart';
import 'package:no_name_ecommerce/services/cart_services/cart_service.dart';
import 'package:no_name_ecommerce/services/category_service.dart';
import 'package:no_name_ecommerce/services/featured_product_service.dart';
import 'package:no_name_ecommerce/services/payment_services/stripe_service.dart';
import 'package:no_name_ecommerce/services/product_details_service.dart';
import 'package:no_name_ecommerce/services/profile_service.dart';
import 'package:no_name_ecommerce/services/recent_product_service.dart';
import 'package:no_name_ecommerce/services/rtl_service.dart';
import 'package:no_name_ecommerce/services/slider_service.dart';
import 'package:no_name_ecommerce/services/translate_string_service.dart';
import 'package:no_name_ecommerce/view/product/product_details_page.dart';
import 'package:no_name_ecommerce/view/utils/const_strings.dart';
import 'package:no_name_ecommerce/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkConnection(BuildContext context) async {
  var ln = Provider.of<TranslateStringService>(context, listen: false);

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    showToast(ln.getString(ConstString.plzCheckInternet), Colors.black);
    return false;
  } else {
    return true;
  }
}

removeUnderscore(value) {
  return value.replaceAll(RegExp('_'), ' ');
}

getDateOnly(date) {
  if (date == null) return ' ';
  return DateFormat('dd/MM/yyyy').format(date);
}

hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.focusedChild?.unfocus();
  }
}

runAtHomeScreen(BuildContext context) {
  Provider.of<CartService>(context, listen: false).fetchCartProductNumber();

  Provider.of<SliderService>(context, listen: false).fetchSlider(context);
  Provider.of<CampaignService>(context, listen: false)
      .fetchCampaignList(context);
  Provider.of<FeaturedProductService>(context, listen: false)
      .fetchFeaturedProducts(context);

  Provider.of<RecentProductService>(context, listen: false)
      .fetchRecentProducts(context);
  //
  Provider.of<CategoryService>(context, listen: false)
      .fetchCategoryForHome(context);

  Provider.of<ProfileService>(context, listen: false)
      .getProfileDetails(context);
  firstAppOpenSet();
}

runAtStart(BuildContext context) {
  Provider.of<TranslateStringService>(context, listen: false)
      .fetchTranslatedStrings(context);
  Provider.of<RtlService>(context, listen: false)
      .fetchCurrencyAndDirection(context);

  startStripe();
}

gotoProductDetails(BuildContext context, productId) {
  Provider.of<ProductDetailsService>(context, listen: false)
      .fetchProductDetails(context, productId: productId);

  Future.delayed(const Duration(milliseconds: 200), () {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ProductDetailsPage(
          productId: productId,
        ),
      ),
    );
  });
}

startStripe() async {
  //start stripe
  //============>
  var publishableKey = await StripeService().getStripeKey();
  Stripe.publishableKey = publishableKey;
  Stripe.instance.applySettings();
}

firstAppOpenSet() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('firstRun', false);
}

showWithCurrency(BuildContext context, data) {
  bool currencyAtLeft =
      Provider.of<RtlService>(context, listen: false).currencyAtLeft;
  String currency = Provider.of<RtlService>(context, listen: false).currency;

  if (currencyAtLeft) {
    return "$currency$data";
  } else {
    return "$data$currency";
  }
}
