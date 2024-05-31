// ignore_for_file: use_build_context_synchronously

import 'package:automated_texbook_system/model/librarian.dart';
import 'package:automated_texbook_system/provider/auth_provider.dart';
import 'package:automated_texbook_system/utill/colors.dart';
import 'package:automated_texbook_system/views/screens/librarian_dashboard_screen.dart';
import 'package:automated_texbook_system/views/widgets/app_btn.dart';
import 'package:automated_texbook_system/views/widgets/app_input.dart';
import 'package:automated_texbook_system/views/widgets/flash_bar.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LibrarianRegister extends ConsumerStatefulWidget {
  const LibrarianRegister({super.key});
  static const String routeName = '/librarian-register';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<LibrarianRegister> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController staffIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isRegister = true;
  bool isLoading = false;

  List<Widget> registerForm() => [
        AppInputField(
          hintText: 'Full Name',
          editingController: fullNameController,
        ),
        const Gap(10),
        AppInputField(
          hintText: 'School Email',
          editingController: emailController,
        ),
        const Gap(10),
        AppInputField(
          hintText: 'Staff Id',
          editingController: staffIdController,
        ),
        const Gap(10),
        AppInputField(
          hintText: 'Password',
          editingController: passwordController,
        ),
        const Gap(10),
        AppInputField(
          hintText: 'Confirm Password',
          editingController: confirmPasswordController,
        ),
      ];
  List<Widget> loginForm() => [
        AppInputField(
          hintText: 'School Email',
          editingController: emailController,
        ),
        const Gap(10),
        AppInputField(
          hintText: 'Password',
          editingController: passwordController,
        ),
      ];

  void register() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final staffId = staffIdController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        staffId.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      FlashTopBar.flashBar(context, 'Please fill in all fields');
      return;
    }

    if (password != confirmPassword) {
      FlashTopBar.flashBar(context, 'Passwords do not match');
      return;
    }

    Librarian librarian = Librarian(
      staffName: fullName,
      email: email,
      staffId: staffId,
    );

    setState(() => isLoading = true);

    try {
      await ref
          .read(authProvider)
          .librarianRegister(librarian: librarian, password: password);
      FlashTopBar.flashBar(context, "Registeration Successful");
      context.push(LibrarianDashboardScreen.routeName);
    } catch (e) {
      FlashTopBar.flashBar(context, "An Error occured: ${e.toString()}");
    }
    setState(() => isLoading = false);
  }

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      FlashTopBar.flashBar(context, 'Please fill in all fields');
      return;
    }
    setState(() => isLoading = true);
    try {
      await ref
          .read(authProvider)
          .librarianLogin(email: email, password: password);
      context.push(LibrarianDashboardScreen.routeName);
    } catch (e) {
      FlashTopBar.flashBar(context, "An Error occured: ${e.toString()}");
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: AppColor.textColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.textColor.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
            // width: 900.w,
            // height: 1.sh,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Gap(50),
                Text(
                  "Textbook Purchasing System",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 30,
                      ),
                ),
                const Gap(20),
                CustomSlidingSegmentedControl(
                  children: {
                    0: Text(
                      'Librarian Register',
                      style: TextStyle(
                        color: isRegister ? Colors.black : Colors.white,
                      ),
                    ),
                    1: Text(
                      'Librarian Login',
                      style: TextStyle(
                        color: isRegister ? Colors.white : Colors.black,
                      ),
                    ),
                  },
                  decoration: BoxDecoration(
                    color: AppColor.textColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  thumbDecoration: BoxDecoration(
                    color: AppColor.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onValueChanged: (value) {
                    setState(() => isRegister = !isRegister);
                  },
                ),
                const Gap(20),
                ...isRegister ? registerForm() : loginForm(),
                const Gap(20),
                isRegister
                    ? AppButton(
                        placeholder: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              )
                            : const Text('Register'),
                        onPressed: register,
                      )
                    : AppButton(
                        placeholder: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              )
                            : const Text('Login'),
                        onPressed: login,
                      ),
                const Gap(10),
                Text.rich(
                  TextSpan(children: [
                    const TextSpan(
                      text: 'Register as a Student ',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: ' Click Here',
                      style: const TextStyle(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.push('/'),
                    )
                  ]),
                ),
                const Gap(15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
