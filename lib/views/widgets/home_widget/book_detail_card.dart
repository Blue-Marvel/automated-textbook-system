import 'package:automated_texbook_system/model/book.dart';
import 'package:automated_texbook_system/utill/colors.dart';
import 'package:automated_texbook_system/views/screens/try.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TextBookDetailCard extends StatelessWidget {
  final TextBook textBook;
  final bool isStudent;
  const TextBookDetailCard({
    super.key,
    required this.textBook,
    this.isStudent = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.5.sw,
      height: 1.sh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(8.sp),
                  width: constraints.maxWidth * 0.8,
                  height: constraints.maxHeight * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    image: DecorationImage(
                      image: ExtendedNetworkImageProvider(
                        textBook.imageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Gap(12.h),
                SizedBox(
                  width: constraints.maxWidth * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            textBook.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            textBook.price.toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      Gap(8.h),
                      Text(
                        textBook.description,
                        softWrap: true,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(8.h),
                      Text(
                        'Author: ${textBook.author}',
                        style: const TextStyle(
                          color: AppColor.textColor,
                        ),
                      ),
                      Gap(24.h),
                      //list of department using the book
                      Text(
                        'Available Departments',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: textBook.departments
                                .map(
                                  (department) => Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      department,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),

                      ///[if user is a student] else return edit btn
                      ///[Cart] carts btn in a row [add]  and [remove] from cart
                      ///and a box displaying the amount of books added to cart.
                      if (isStudent)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Add'),
                            ),
                            Gap(8.h),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Remove'),
                            ),
                          ],
                        ),
                      if (!isStudent)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.textColor,
                              foregroundColor: AppColor.backgroundColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 5.h),
                              elevation: 3,
                            ),
                            onPressed: () {},
                            child: const Text('Edit'),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
