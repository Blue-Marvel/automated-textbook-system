import 'package:automated_texbook_system/model/book.dart';
import 'package:automated_texbook_system/utill/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HomeListCard extends StatelessWidget {
  final TextBook textBook;

  const HomeListCard({
    super.key,
    required this.textBook,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 0.2.sh,
        width: 0.4.sw,
        child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
          return Row(
            children: [
              Container(
                margin: EdgeInsets.all(8.sp),
                width: constraints.maxWidth * 0.3,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  image: DecorationImage(
                    image: ExtendedNetworkImageProvider(
                      textBook.imageUrl,
                      // cache: true,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                // child: Image.network(textBook.imageUrl),
              ),
              Gap(12.w),
              SizedBox(
                width: constraints.maxWidth * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textBook.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      textBook.description,
                      softWrap: true,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          textBook.author,
                          style: const TextStyle(
                            color: AppColor.textColor,
                          ),
                        ),
                        Text(
                          '${textBook.stockNumber} copies available',
                          style: const TextStyle(
                            color: AppColor.textColor,
                          ),
                        ),
                      ],
                    ),
                    Gap(20.h),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
