import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/material.dart';
import 'package:no_name_ecommerce/view/utils/constant_colors.dart';

class ReviewTab extends StatelessWidget {
  const ReviewTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // create a instance of colorlizer
    ColorLizer colorlizer = ColorLizer();

    const rating = 5;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //profile image, rating, feedback
      for (int i = 0; i < 5; i++)
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        color: colorlizer.getRandomColors(),
                        height: 60,
                        width: 60,
                        alignment: Alignment.center,
                        child: const Text(
                          'S',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Saleheen',
                          style: TextStyle(
                              color: greyFour,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        // if one star rating then show one star else loop and show
                        rating == 0
                            ? const Icon(
                                Icons.star,
                                color: primaryColor,
                                size: 16,
                              )
                            : Row(
                                children: [
                                  for (int j = 0; j < 5; j++)
                                    const Icon(
                                      Icons.star,
                                      color: primaryColor,
                                      size: 16,
                                    )
                                ],
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        //feedback
                        const Text(
                          'Very good',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: greyParagraph,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    ]);
  }
}
