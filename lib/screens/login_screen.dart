import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdw/screens/onboarding_screen.dart';
import 'package:mdw/services/app_function_services.dart';
import 'package:mdw/services/app_keys.dart';
import 'package:mdw/services/storage_services.dart';
import 'package:mdw/styles.dart';
import 'package:mdw/utils/snack_bar_utils.dart';

import 'code_verification_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _usernameTextController, _passwordTextController;
  bool obscure = true, loading = false;

  @override
  void initState() {
    _usernameTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Login to your account",
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  "Good to see you again, enter your details\nbelow to continue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              Column(
                children: [
                  CustomTextField(
                    textEditingController: _usernameTextController,
                    head: "Username",
                    hint: "Enter Username",
                    keyboard: TextInputType.emailAddress,
                    // validator: (value) => EmailValidator.validate(value!)
                    //     ? null
                    //     : "Please enter a valid email",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    textEditingController: _passwordTextController,
                    head: "Password",
                    hint: "Enter password",
                    keyboard: TextInputType.visiblePassword,
                    obscure: obscure,
                    suffix: GestureDetector(
                      onTap: (() {
                        setState(() {
                          obscure = !obscure;
                        });
                      }),
                      child: Icon(
                        obscure
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: AppColors.black.withOpacity(0.4),
                      ),
                    ),
                    validator: ((value) =>
                        AppFunctions.passwordValidator(value)),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              if (!loading)
                CustomBtn(
                  onTap: (() async {
                    setState(() {
                      loading = true;
                    });
                    if (_usernameTextController.text.isNotEmpty &&
                        _passwordTextController.text.isNotEmpty) {
                      if (AppFunctions.passwordValidator(
                              _passwordTextController.text.trim()) !=
                          null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          AppSnackBar().customizedAppSnackBar(
                              message: AppFunctions.passwordValidator(
                                      _passwordTextController.text.trim()) ??
                                  "",
                              context: context),
                        );
                      } else {
                        final http.Response res = await http.post(
                            Uri.parse(AppKeys.apiUrlKey + AppKeys.loginKey),
                            headers: {
                              "content-type": "application/json",
                            },
                            body: jsonEncode({
                              'riderId': _usernameTextController.text.trim(),
                              'riderPassword':
                                  _passwordTextController.text.trim(),
                            }));
                        final Map<String, dynamic> resJson =
                            jsonDecode(res.body);
                        // log(resJson.toString());

                        if (resJson["success"] == 1) {
                          await StorageServices.setLoginUserDetails(resJson)
                              .whenComplete(() async {
                            await StorageServices.setSignInStatus(true)
                                .whenComplete(() async {
                              bool attendanceStatus =
                                  await AppFunctions.getAttendanceStatus();
                              if (attendanceStatus) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((ctx) => MainScreen()),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((ctx) =>
                                        const CodeVerificationScreen(
                                          head: "Attendance",
                                          upperText:
                                              "Ask your admin to enter his code to confirm your attendance.",
                                          type: 0,
                                          btnText: "Confirm Attendance",
                                        )),
                                  ),
                                );
                              }
                            });
                          });
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please fill the Username and Password",
                          context: context,
                        ),
                      );
                    }
                    // if (!EmailValidator.validate(
                    //     _emailTextController.text.trim())) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     AppSnackBar().customizedAppSnackBar(
                    //         message: "Please enter a valid email.",
                    //         context: context),
                    //   );
                    // } else if (AppFunctions.passwordValidator(
                    //         _passwordTextController.text.trim()) !=
                    //     null) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     AppSnackBar().customizedAppSnackBar(
                    //         message: AppFunctions.passwordValidator(
                    //                 _passwordTextController.text.trim()) ??
                    //             "",
                    //         context: context),
                    //   );
                    // } else {
                    //   await StorageServices.setSignInStatus(true)
                    //       .whenComplete(() async {
                    //     bool attendanceStatus =
                    //         await AppFunctions.getAttendanceStatus();
                    //     if (attendanceStatus) {
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: ((ctx) => MainScreen()),
                    //         ),
                    //       );
                    //     } else {
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: ((ctx) => const CodeVerificationScreen(
                    //                 head: "Attendance",
                    //                 upperText:
                    //                     "Ask your admin to enter his code to confirm your attendance.",
                    //                 type: 0,
                    //                 btnText: "Confirm Attendance",
                    //               )),
                    //         ),
                    //       );
                    //     }
                    //   });
                    // }
                    setState(() {
                      loading = false;
                    });
                  }),
                  text: "Login to my account",
                ),
              if (loading) CustomLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.green,
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.head,
    required this.hint,
    required this.keyboard,
    this.validator,
    required this.textEditingController,
    this.obscure,
    this.suffix,
  });

  final String head, hint;
  final TextInputType keyboard;
  final String? Function(String?)? validator;
  final TextEditingController textEditingController;
  final bool? obscure;
  final Widget? suffix;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final GlobalKey<FormFieldState> formFieldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text(
            widget.head,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 13,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          obscureText: widget.obscure ?? false,
          key: formFieldKey,
          onChanged: ((value) {
            formFieldKey.currentState!.validate();
          }),
          controller: widget.textEditingController,
          style: TextStyle(color: AppColors.black, fontSize: 15),
          validator: widget.validator,
          keyboardType: widget.keyboard,
          cursorColor: AppColors.green,
          decoration: InputDecoration(
            suffixIcon: widget.suffix,
            contentPadding: EdgeInsets.all(15),
            hintText: widget.hint,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.black.withOpacity(0.1),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.black.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.green.withOpacity(0.7),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.red,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}
