import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppInputField extends StatefulWidget {
  final String hintText;
  final TextEditingController editingController;
  final bool isEmail;
  final bool isStock;
  final bool isPrice;
  final bool isDescription;

//constructor
  const AppInputField(
      {super.key,
      required this.hintText,
      required this.editingController,
      this.isStock = false,
      this.isPrice = false,
      this.isEmail = false,
      this.isDescription = false});

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isStock || widget.isPrice
          ? 260.w
          : 1.sw < 360
              ? 2.sw
              : 500.w,
      child: Column(
        children: [
          Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: TextFormField(
              validator: (value) {
                if (value != null && value.isEmpty) {
                  if (widget.isEmail && value.contains("@")) {
                    return "Enter a valid email";
                  }
                  return "This field is required";
                }
                return null;
              },
              controller: widget.editingController,
              maxLines: widget.isDescription ? 4 : 1,
              decoration: InputDecoration(
                prefix: widget.isPrice ? const Text('\u20A6  ') : null,
                suffix: widget.isPrice
                    ? const Text('00.00')
                    : widget.isStock
                        ? const Text('00')
                        : null,
                contentPadding: EdgeInsets.all(20.w),
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                hintText: widget.hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                // focusedBorder:
              ),
            ),
          )
        ],
      ),
    );
  }
}
