import 'package:flutter/material.dart';
import 'package:no_name_ecommerce/services/shipping_services/add_remove_shipping_address_service.dart';
import 'package:no_name_ecommerce/view/utils/common_helper.dart';
import 'package:no_name_ecommerce/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyDeliveryAddressHelper {
  deletePopup(addressId, BuildContext context) {
    return Alert(
        context: context,
        style: AlertStyle(
            alertElevation: 0,
            overlayColor: Colors.black.withOpacity(.6),
            alertPadding: const EdgeInsets.all(25),
            isButtonVisible: false,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            titleStyle: const TextStyle(),
            animationType: AnimationType.grow,
            animationDuration: const Duration(milliseconds: 500)),
        content: Container(
          margin: const EdgeInsets.only(top: 22),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  spreadRadius: -2,
                  blurRadius: 13,
                  offset: const Offset(0, 13)),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Are you sure?',
                style: TextStyle(color: greyPrimary, fontSize: 17),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Expanded(
                      child: borderButtonPrimary('Cancel', () {
                    Navigator.pop(context);
                  })),
                  const SizedBox(
                    width: 16,
                  ),
                  Consumer<AddRemoveShippingAddressService>(
                    builder: (context, provider, child) => Expanded(
                        child: buttonPrimary('Delete', () {
                      if (provider.isloading == false) {
                        provider.removeAddress(addressId, context);
                      }
                    }, isloading: provider.isloading == false ? false : true)),
                  ),
                ],
              )
            ],
          ),
        )).show();
  }
}