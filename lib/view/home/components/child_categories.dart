import 'package:flutter/material.dart';
import 'package:no_name_ecommerce/services/category_service.dart';
import 'package:no_name_ecommerce/services/rtl_service.dart';
import 'package:no_name_ecommerce/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class ChildCategories extends StatefulWidget {
  const ChildCategories({
    Key? key,
    required this.marginRight,
  }) : super(key: key);

  final double marginRight;

  @override
  State<ChildCategories> createState() => _ChildCategoriesState();
}

class _ChildCategoriesState extends State<ChildCategories> {
  int selectedCategory = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryService>(
        builder: (context, provider, child) =>
            //  provider.hasError != true
            //     ? provider.categoryList.isNotEmpty
            //         ?
            Consumer<RtlService>(
              builder: (context, rtlP, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 41,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      clipBehavior: Clip.none,
                      children: [
                        for (int i = 0; i < 5; i++)
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              selectedCategory = i;
                              setState(() {});
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              margin: EdgeInsets.only(
                                right: rtlP.direction == 'ltr'
                                    ? widget.marginRight
                                    : 0,
                                left: rtlP.direction == 'ltr'
                                    ? 0
                                    : widget.marginRight,
                              ),
                              decoration: BoxDecoration(
                                  color: selectedCategory == i
                                      ? primaryColor
                                      : Colors.white,
                                  border: Border.all(
                                      color: selectedCategory == i
                                          ? Colors.transparent
                                          : borderColor),
                                  borderRadius: BorderRadius.circular(100)),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                ),
                                child: Row(
                                  children: [
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(50),
                                    //   child: CachedNetworkImage(
                                    //     height: 37,
                                    //     width: 37,
                                    //     imageUrl:
                                    //         provider.categoryList[i].image,
                                    //     errorWidget: (context, url, error) =>
                                    //         const Icon(Icons.error),
                                    //     fit: BoxFit.cover,
                                    //   ),
                                    // ),

                                    // const SizedBox(
                                    //   width: 10,
                                    // ),
                                    //Title
                                    Text(
                                      'Casual Shirt',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: selectedCategory == i
                                            ? Colors.white
                                            : greyParagraph,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            )
        //     : Container()
        // : const Text('no category found'),
        );
  }
}
