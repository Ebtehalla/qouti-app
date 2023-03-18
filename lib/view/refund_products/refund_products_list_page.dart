import 'package:flutter/material.dart';
import 'package:no_name_ecommerce/services/refund_products_service.dart';
import 'package:no_name_ecommerce/view/refund_products/refund_support_ticket/refund_tickets_page.dart';
import 'package:no_name_ecommerce/view/utils/common_helper.dart';
import 'package:no_name_ecommerce/view/utils/constant_colors.dart';
import 'package:no_name_ecommerce/view/utils/constant_styles.dart';
import 'package:no_name_ecommerce/view/utils/responsive.dart';
import 'package:no_name_ecommerce/view/utils/static_strings.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefundProductsListPage extends StatefulWidget {
  const RefundProductsListPage({Key? key}) : super(key: key);

  @override
  _RefundProductsListPageState createState() => _RefundProductsListPageState();
}

class _RefundProductsListPageState extends State<RefundProductsListPage> {
  @override
  void initState() {
    super.initState();
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarCommon(StaticStrings.refundProducts, context, () {
        Navigator.pop(context);
      }),
      backgroundColor: bgColor,
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: context.watch<RefundProductsService>().currentPage > 1
            ? false
            : true,
        onRefresh: () async {
          final result =
              await Provider.of<RefundProductsService>(context, listen: false)
                  .fetchRefundProductList(context);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<RefundProductsService>(context, listen: false)
                  .fetchRefundProductList(context);
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
            child: Consumer<RefundProductsService>(
          builder: (context, rp, child) => rp.productList.isNotEmpty
              ? Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenPadHorizontal, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < rp.productList.length; i++)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(9)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      titleCommon(
                                          rp.productList[i].product?.name ?? '',
                                          fontsize: 15),
                                      gapH(8),
                                      paragraphCommon(
                                          '${StaticStrings.orderId}:#${rp.productList[i].product?.id}'),
                                      gapH(6),
                                      paragraphCommon(
                                          '${StaticStrings.status}: ${rp.productList[i].status == 0 ? 'Pending' : 'Completed'}',
                                          color: successColor)
                                    ]),
                              ),
                              // const Icon(
                              //   Icons.arrow_forward_ios,
                              //   size: 16,
                              //   color: greyFour,
                              // )
                            ],
                          ),
                        ),
                    ],
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  height: screenHeight - 180,
                  child: paragraphCommon('No product found'),
                ),
        )),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const RefundTicketsPage(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          width: 195,
          decoration: BoxDecoration(
            color: successColor,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 5,
                blurRadius: 11,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(
              Icons.message_outlined,
              color: Colors.white,
            ),
            const SizedBox(
              width: 8,
            ),
            paragraphCommon('Refund tickets',
                color: Colors.white, lineHeight: 1)
          ]),
        ),
      ),
    );
  }
}
