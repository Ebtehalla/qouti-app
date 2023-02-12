import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:no_name_ecommerce/services/search_product_service.dart';
import 'package:no_name_ecommerce/view/home/components/categories.dart';
import 'package:no_name_ecommerce/view/home/components/child_categories.dart';
import 'package:no_name_ecommerce/view/home/components/sub_categories.dart';
import 'package:no_name_ecommerce/view/utils/common_helper.dart';
import 'package:no_name_ecommerce/view/utils/constant_colors.dart';
import 'package:no_name_ecommerce/view/utils/constant_styles.dart';
import 'package:no_name_ecommerce/view/utils/custom_input.dart';
import 'package:no_name_ecommerce/view/utils/responsive.dart';
import 'package:provider/provider.dart';

class ProductFilter extends StatefulWidget {
  const ProductFilter({Key? key}) : super(key: key);

  @override
  State<ProductFilter> createState() => _ProductFilterState();
}

class _ProductFilterState extends State<ProductFilter> {
  int selectedCategory = 0;
  int selectedColor = 0;
  double rating = 4;
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProductService>(
      builder: (context, provider, child) => Container(
        height: screenHeight / 2 + 210,
        color: Colors.white,
        padding:
            EdgeInsets.symmetric(horizontal: screenPadHorizontal, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleCommon('Filter by:'),
              sizedboxCustom(20),

              //Category =====>
              paragraphCommon('Category:'),
              sizedboxCustom(12),
              const Categories(),

              //Sub Category =====>
              sizedboxCustom(20),
              paragraphCommon('Sub Category:'),
              sizedboxCustom(12),
              const SubCategories(),

              //Child Category =====>
              sizedboxCustom(20),
              paragraphCommon('Child Category:'),
              sizedboxCustom(12),
              const ChildCategories(),

              //=========>
              // const ColorAndSize(),

              //Price range =========>
              sizedboxCustom(18),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        paragraphCommon('Min Price:'),
                        sizedboxCustom(10),
                        CustomInput(
                          hintText: 'Enter min price',
                          borderRadius: 5,
                          paddingHorizontal: 15,
                          isNumberField: true,
                          onChanged: (v) {
                            provider.setMinPrice(v);
                          },
                        ),
                      ],
                    ),
                  ),
                  sizedboxW(20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        paragraphCommon('Min Price:'),
                        sizedboxCustom(10),
                        CustomInput(
                          hintText: 'Enter max price',
                          borderRadius: 5,
                          paddingHorizontal: 15,
                          isNumberField: true,
                          onChanged: (v) {
                            provider.setMaxPrice(v);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),

              paragraphCommon('Ratings:'),
              sizedboxCustom(10),
              RatingBar.builder(
                initialRating: provider.rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
                itemSize: 30,
                unratedColor: greyFive,
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  rating = value;
                  provider.setRating(value);
                },
              ),

              // Reset filter and apply button
              // sizedboxCustom(20),
              // Row(
              //   children: [
              //     Expanded(
              //         child: InkWell(
              //       onTap: () {
              //         Navigator.pop(context);
              //       },
              //       child: Container(
              //           width: double.infinity,
              //           alignment: Alignment.center,
              //           padding: const EdgeInsets.symmetric(vertical: 18),
              //           decoration: BoxDecoration(
              //               color: const Color(0xffEAECF0),
              //               borderRadius: BorderRadius.circular(100)),
              //           child: const Text(
              //             'Cancel',
              //             style: TextStyle(
              //               color: Color(0xff667085),
              //               fontSize: 14,
              //             ),
              //           )),
              //     )),
              //     const SizedBox(
              //       width: 20,
              //     ),
              //     Expanded(
              //       child: buttonPrimary('Apply filter', () {
              //         // Navigator.push(
              //         //   context,
              //         //   MaterialPageRoute<void>(
              //         //     builder: (BuildContext context) =>
              //         //         const AllproductPage(),
              //         //   ),
              //         // );
              //       }, borderRadius: 100),
              //     )
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
