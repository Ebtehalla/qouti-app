import 'package:flutter/material.dart';
import 'package:no_name_ecommerce/services/cart_services/delivery_address_service.dart';
import 'package:no_name_ecommerce/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

import '../../utils/constant_styles.dart';

class FreeShipOption extends StatelessWidget {
  const FreeShipOption({
    Key? key,
    required this.selectedShipping,
  }) : super(key: key);

  final int selectedShipping;

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryAddressService>(
      builder: (context, dProvider, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectedShipping == -1
              ? const Icon(
                  Icons.check_box,
                  color: primaryColor,
                )
              : const Icon(Icons.check_box_outline_blank_outlined),
          const SizedBox(
            width: 13,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${dProvider.shippingCostDetails?.defaultShippingOptions.name} (\$${dProvider.shippingCostDetails?.defaultShippingOptions.options?.cost})',
                style: const TextStyle(
                  color: greyFour,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              gapH(27)
            ],
          )
        ],
      ),
    );
  }
}
