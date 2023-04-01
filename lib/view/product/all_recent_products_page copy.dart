import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:no_name_ecommerce/services/common_service.dart';
import 'package:no_name_ecommerce/services/recent_product_service.dart';
import 'package:no_name_ecommerce/services/translate_string_service.dart';
import 'package:no_name_ecommerce/view/home/components/product_card.dart';
import 'package:no_name_ecommerce/view/utils/common_helper.dart';
import 'package:no_name_ecommerce/view/utils/config.dart';
import 'package:no_name_ecommerce/view/utils/const_strings.dart';
import 'package:no_name_ecommerce/view/utils/constant_colors.dart';
import 'package:no_name_ecommerce/view/utils/constant_styles.dart';
import 'package:no_name_ecommerce/view/utils/others_helper.dart';
import 'package:no_name_ecommerce/view/utils/responsive.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllRecentProductsPage extends StatefulWidget {
  const AllRecentProductsPage({Key? key}) : super(key: key);

  @override
  State<AllRecentProductsPage> createState() => _AllRecentProductsPageState();
}

class _AllRecentProductsPageState extends State<AllRecentProductsPage> {
  @override
  void initState() {
    super.initState();
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarCommon(ConstString.allRecentProducts, context, () {
        Navigator.pop(context);
      }),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: context.watch<RecentProductService>().currentPage > 1
            ? false
            : true,
        onRefresh: () async {
          final result =
              await Provider.of<RecentProductService>(context, listen: false)
                  .fetchAllRecentProducts(context);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<RecentProductService>(context, listen: false)
                  .fetchAllRecentProducts(context);
          if (result) {
            debugPrint('loadcomplete ran');
            //loadcomplete function loads the data again
            refreshController.loadComplete();
          } else {
            debugPrint('no more data');
            refreshController.loadNoData();

            Future.delayed(const Duration(seconds: 1), () {
              //it will reset footer no data state to idle and will let us load again
              refreshController.resetNoData();
            });
          }
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenPadHorizontal),
            child: Consumer<TranslateStringService>(
              builder: (context, ln, child) => Consumer<RecentProductService>(
                builder: (context, provider, child) => provider
                            .noProductFound ==
                        false
                    ? provider.allRecentProducts.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                gapH(10),
                                GridView.builder(
                                    gridDelegate:
                                        const FlutterzillaFixedGridView(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 25,
                                            crossAxisSpacing: 20,
                                            height: 230),
                                    shrinkWrap: true,
                                    itemCount:
                                        provider.allRecentProducts.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, i) {
                                      return ProductCard(
                                        imageLink: provider
                                                .allRecentProducts[i].image ??
                                            placeHolderUrl,
                                        title:
                                            provider.allRecentProducts[i].name,
                                        width: 200,
                                        oldPrice:
                                            provider.allRecentProducts[i].price,
                                        discountPrice: provider
                                            .allRecentProducts[i].salePrice,
                                        marginRight: 5,
                                        productId:
                                            provider.allRecentProducts[i].id,
                                        ratingAverage: null,
                                        discountPercent: null,
                                        pressed: () {
                                          gotoProductDetails(context,
                                              provider.allRecentProducts[i].id);
                                        },
                                      );
                                    })
                              ])
                        : Container(
                            alignment: Alignment.center,
                            height: screenHeight - 200,
                            child: showLoading(primaryColor),
                          )
                    : Container(
                        alignment: Alignment.center,
                        height: screenHeight - 200,
                        child: Text(ln.getString(ConstString.noProductFound))),
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: goToCartButton(context)
    );
  }
}