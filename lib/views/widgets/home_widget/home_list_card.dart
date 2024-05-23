import 'package:automated_texbook_system/model/book.dart';
import 'package:automated_texbook_system/utill/colors.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
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
        height: 158,
        width: 600,
        child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
          return Row(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                width: constraints.maxWidth * 0.3,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
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
              const Gap(12),
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
                      maxLines: 3,
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
                    const Gap(20),
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
