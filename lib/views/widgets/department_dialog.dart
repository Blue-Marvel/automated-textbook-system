import 'package:automated_texbook_system/provider/upload_provider.dart';
import 'package:automated_texbook_system/utill/colors.dart';
import 'package:automated_texbook_system/utill/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class DepartmentDialog extends ConsumerStatefulWidget {
  const DepartmentDialog({super.key});

  @override
  ConsumerState<DepartmentDialog> createState() => _DepartmentDialogState();
}

class _DepartmentDialogState extends ConsumerState<DepartmentDialog> {
  final searchController = TextEditingController();
  List<String> filteredDepartments = departmentList;
  // List<String> selectedDepartments = [];

  @override
  void initState() {
    List<bool> checkedDepartment = List.filled(departmentList.length, false);
    ref.read(uploadProvider).checkedDepartment.addAll(checkedDepartment);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: SearchBar(
                hintText: "Search...",
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    filteredDepartments = departmentList
                        .where((department) => department
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
            const Gap(10),
            ElevatedButton(
              onPressed: () {
                context.pop();
                // print(ref.watch(uploadProvider).department);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.textColor,
                  minimumSize: const Size(200, 60),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  )),
              child: const Text(
                'Done',
                style: TextStyle(color: AppColor.backgroundColor),
              ),
            )
          ],
        ),
        actions: [
          //display a wrap list of departments with checkboxes and a search bar
          SizedBox(
            width: 820,
            height: 400,
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  ...List.generate(
                      filteredDepartments.length,
                      (index) => CheckboxListTile(
                            title: Text(filteredDepartments[index]),
                            value: ref
                                .read(uploadProvider)
                                .checkedDepartment[index],
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  ref
                                      .read(uploadProvider)
                                      .checkedDepartment[index] = value;
                                  ref.read(uploadProvider).setDepartment(
                                      filteredDepartments[index]);
                                } else {
                                  ref
                                      .read(uploadProvider)
                                      .checkedDepartment[index] = value;
                                  ref.read(uploadProvider).removeDepartment(
                                      filteredDepartments[index]);
                                }
                              });
                            },
                          )),
                ],
              ),
            ),
          )
        ]);
  }
}
