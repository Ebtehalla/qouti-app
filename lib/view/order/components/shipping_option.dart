// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:no_name_ecommerce/services/common_service.dart';
import 'package:no_name_ecommerce/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

import '../../../services/cart_services/delivery_address_service.dart';
import '../../utils/constant_styles.dart';

class ShippingOption extends StatelessWidget {
  const ShippingOption({
    Key? key,
    required this.selectedShipping,
    required this.i,
  }) : super(key: key);

  final int selectedShipping;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryAddressService>(
      builder: (context, dProvider, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectedShipping == i
              ? const Icon(
                  Icons.check_box,
                  color: primaryColor,
                )
              : const Icon(Icons.check_box_outline_blank_outlined),
          const SizedBox(
            width: 13,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dProvider.shippingCostDetails?.shippingOptions[i].name +
                      " " +
                      showWithCurrency(
                          context,
                          dProvider.shippingCostDetails?.shippingOptions[i]
                                  .options?.cost ??
                              0),
                  style: const TextStyle(
                    color: greyFour,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                gapH(20),
              ],
            ),
          )
        ],
      ),
    );
  }
}
