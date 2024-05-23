// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:automated_texbook_system/model/book.dart';
import 'package:automated_texbook_system/provider/upload_provider.dart';
import 'package:automated_texbook_system/utill/colors.dart';
import 'package:automated_texbook_system/views/widgets/app_input.dart';
import 'package:automated_texbook_system/views/widgets/department_dialog.dart';
import 'package:automated_texbook_system/views/widgets/flash_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        id: '',
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
      ref.read(uploadProvider).checkedDepartment.clear();
    } catch (e) {
      // ignore: use_build_context_synchronously
      FlashTopBar.flashBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 786,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(50),
            AppInputField(
              hintText: 'Book Title',
              editingController: titleController,
            ),
            Gap(18),
            AppInputField(
              hintText: 'Author',
              editingController: authorController,
            ),
            Gap(18),
            AppInputField(
              isDescription: true,
              hintText: 'Description',
              editingController: descriptionController,
            ),
            Gap(18),
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
                      padding: EdgeInsets.symmetric(vertical: 10),
                      minimumSize: Size(164, 100),
                      elevation: 6
                      // backgroundColor: AppColor.textColor,
                      // foregroundColor: AppColor.backgroundColor.,
                      ),
                  child: const Text("Select Department(s)"),
                ),
              ],
            ),
            Gap(18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      minimumSize: Size(164, 100),
                      elevation: 6),
                  child: Row(
                    children: [
                      if (_imageFile != null) const Icon(Icons.check),
                      Text(
                          _imageFile == null ? "Upload Image" : "Change Image"),
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
            const Gap(18),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.textColor,
                  foregroundColor: AppColor.backgroundColor,
                  elevation: 6,
                  minimumSize: const Size(164, 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => uploadBook(ref),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Upload'),
              ),
            ),
            const Gap(18),
            if (ref.watch(uploadProvider).department.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    'Selected Department(s):\n${ref.watch(uploadProvider).department.join('\n')}'),
              ),
          ],
        ),
      ),
    );
  }
}
