// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:no_name_ecommerce/services/cart_services/cart_service.dart';
import 'package:no_name_ecommerce/services/product_db_service.dart';
import 'package:no_name_ecommerce/services/product_details_service.dart';
import 'package:no_name_ecommerce/services/translate_string_service.dart';
import 'package:no_name_ecommerce/view/checkout/cart_page.dart';
import 'package:no_name_ecommerce/view/product/components/write_review_page.dart';
import 'package:no_name_ecommerce/view/utils/common_helper.dart';
import 'package:no_name_ecommerce/view/utils/config.dart';
import 'package:no_name_ecommerce/view/utils/const_strings.dart';
import 'package:no_name_ecommerce/view/utils/constant_colors.dart';
import 'package:no_name_ecommerce/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class ProductDetailsBottom extends StatefulWidget {
  const ProductDetailsBottom({
    Key? key,
    required this.tabIndex,
  }) : super(key: key);

  final tabIndex;

  @override
  State<ProductDetailsBottom> createState() => _ProductDetailsBottomState();
}

class _ProductDetailsBottomState extends State<ProductDetailsBottom> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslateStringService>(
      builder: (context, ln, child) => Container(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 17),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Consumer<ProductDetailsService>(
          builder: (context, provider, child) => Column(
            children: [
              widget.tabIndex == 1
                  ? Column(
                      children: [
                        buttonPrimary(ConstString.writeReview, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  WriteReviewPage(
                                productId: provider.productDetails?.product?.id,
                              ),
                            ),
                          );
                        }, bgColor: successColor, borderRadius: 100),
                        const SizedBox(
                          height: 13,
                        ),
                      ],
                    )
                  : Container(),
              Consumer<CartService>(
                builder: (context, cProvider, child) => Row(
                  children: [
                    Expanded(
                        child: buttonPrimary(ConstString.buyNow, (() async {
                      if (provider.allAtrributes.isNotEmpty &&
                          provider.selectedInventorySet.isEmpty) {
                        showToast(
                            ln.getString(ConstString.youMustSelectAllAttr),
                            Colors.black);
                        return;
                      }

                      bool addedAlready = await ProductDbService()
                          .checkIfAddedtoCart(
                              provider.productDetails?.product?.name ?? '',
                              provider.productDetails?.product?.id ?? 1);

                      if (!addedAlready) {
                        addToCart(context);
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const Cartpage(),
                        ),
                      );
                    }),
                            borderRadius: 100,
                            bgColor: Colors.grey[200],
                            fontColor: Colors.grey[800])),
                    const SizedBox(
                      width: 15,
                    ),
                    //======>
                    Expanded(
                      child: buttonPrimary(ConstString.addToCart, () {
                        print(provider.productSalePrice);

                        if (provider.allAtrributes.isNotEmpty &&
                            provider.selectedInventorySet.isEmpty) {
                          showToast(
                              ln.getString(ConstString.youMustSelectAllAttr),
                              Colors.black);
                          return;
                        }

                        addToCart(context);
                      }, borderRadius: 100),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addToCart(BuildContext context) {
    var cProvider = Provider.of<CartService>(context, listen: false);
    var provider = Provider.of<ProductDetailsService>(context, listen: false);

    final usedCategories = {
      "category": provider.productDetails?.product?.category?.id,
      "subcategory": provider.productDetails?.product?.subCategory?.id,
      "childcategory": provider.productDetails?.product?.childCategory
          .map((e) => e.id)
          .toList(),
    };

    final attributes = provider.selectedInventorySet;
    if (attributes.containsKey('color_code')) {
      attributes.putIfAbsent(
          'Color',
          () => provider.productDetails?.productColors
              .firstWhere(
                  (element) => element.colorCode == attributes['color_code'])
              .name);
    }
    print(attributes);

    final variantId = provider.variantId;
    print(variantId);

    cProvider.addToCartOrUpdateQty(context,
        title: provider.productDetails?.product?.name ?? '',
        thumbnail: provider.productDetails?.product?.image ?? placeHolderUrl,
        discountPrice:
            provider.productDetails?.product?.salePrice.toString() ?? '0',
        oldPrice: provider.productDetails?.product?.price.toString() ?? '0',
        priceWithAttr: provider.productSalePrice,
        qty: provider.qty,
        color: provider.selectedInventorySet['color_code'],
        size: provider.selectedInventorySet['Size'],
        productId: provider.productDetails?.product?.id.toString() ?? '1',
        category: usedCategories['category'],
        subcategory: usedCategories['subcategory'],
        childCategory: usedCategories['childcategory'],
        attributes: attributes,
        variantId: variantId);
  }
}
