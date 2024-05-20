import 'dart:html';
import 'dart:typed_data';

import 'package:automated_texbook_system/model/book.dart';
import 'package:automated_texbook_system/provider/auth_provider.dart';
import 'package:automated_texbook_system/provider/upload_provider.dart';
import 'package:automated_texbook_system/utill/colors.dart';
import 'package:automated_texbook_system/utill/constant.dart';
import 'package:automated_texbook_system/views/widgets/app_input.dart';
import 'package:automated_texbook_system/views/widgets/department_dialog.dart';
import 'package:automated_texbook_system/views/widgets/flash_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class AddBook extends ConsumerStatefulWidget {
  const AddBook({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddBookState();
}

class _AddBookState extends ConsumerState<AddBook> {
  final authorController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final stockNoController = TextEditingController();
  final priceController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  bool isLoading = false;

  Future<void> _pickImage() async {
    // For web, this opens a file picker dialog
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  void uploadBook(WidgetRef ref) async {
    if (titleController.text.trim() == '' ||
        authorController.text.trim() == '' ||
        descriptionController.text.trim() == '' ||
        stockNoController.text.trim() == '' ||
        priceController.text.trim() == '') {
      FlashTopBar.flashBar(context, 'Please fill in all fields');
      return;
    }
    TextBook textBook = TextBook(
        id: ref.read(authProvider).librarian?.id ?? '',
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        author: authorController.text.trim(),
        imageUrl: '',
        stockNumber: int.parse(stockNoController.text.trim()),
        price: double.parse(priceController.text.trim()),
        departments: ref.read(uploadProvider).department);

    final fl = _imageFile!.readAsBytes();

    Uint8List file = await fl;

    setState(() {
      isLoading = true;
    });
    try {
      if (_imageFile == null) {
        return;
      }

      await ref.read(uploadProvider).addBook(textBook: textBook, file: file);
      ref.read(uploadProvider).department.clear();
      await ref.read(uploadProvider).getBooks();
    } catch (e) {
      FlashTopBar.flashBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.5.sw,
      height: 1.sh,
      child: Padding(
        padding: EdgeInsets.all(100.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add Book",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.textColor,
                      foregroundColor: AppColor.backgroundColor,
                    ),
                    onPressed: () => uploadBook(ref),
                    child: const Text('Upload'),
                  )
                ],
              ),
              Gap(50.h),
              AppInputField(
                hintText: 'Book Title',
                editingController: titleController,
              ),
              Gap(18.h),
              AppInputField(
                hintText: 'Author',
                editingController: authorController,
              ),
              Gap(18.h),
              AppInputField(
                isDescription: true,
                hintText: 'Description',
                editingController: descriptionController,
              ),
              Gap(18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppInputField(
                    isPrice: true,
                    hintText: 'Book Price',
                    editingController: priceController,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const DepartmentDialog(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        minimumSize: Size(0.16.sw, 100.h),
                        elevation: 6
                        // backgroundColor: AppColor.textColor,
                        // foregroundColor: AppColor.backgroundColor.,
                        ),
                    child: const Text("Select Department(s)"),
                  ),
                ],
              ),
              Gap(18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        minimumSize: Size(0.16.sw, 100.h),
                        elevation: 6),
                    child: Row(
                      children: [
                        if (_imageFile != null) const Icon(Icons.check),
                        Text(_imageFile == null
                            ? "Upload Image"
                            : "Change Image"),
                      ],
                    ),
                  ),
                  AppInputField(
                    isStock: true,
                    hintText: 'Stock Number',
                    editingController: stockNoController,
                  ),
                ],
              ),
              Gap(18.h),
              if (ref.watch(uploadProvider).department.isNotEmpty)
                Text(
                    'Selected Department(s):\n ${ref.watch(uploadProvider).department.join('\n')}'),
            ],
          ),
        ),
      ),
    );
  }
}
