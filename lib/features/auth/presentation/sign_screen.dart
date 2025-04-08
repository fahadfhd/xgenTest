import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xgen_test/features/auth/data/sigin_provider.dart';
import 'package:xgen_test/features/auth/presentation/login_screen.dart';
import 'package:xgen_test/features/common_widget/common_text_field.dart';

class SignScreen extends HookConsumerWidget {
  static const String route = '/sign';
  const SignScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passController = useTextEditingController();
    final _formKey = useState(GlobalKey<FormState>());

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Form(
            key: _formKey.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonTextField(
                  controller: emailController,

                  label: "Email",
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    ).hasMatch(email)) {
                      return "Invalid email format";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                CommonTextField(
                  controller: passController,
                  label: "Password",
                  isPassword: true,
                  prefixIcon: Icons.lock,
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Password is required";
                    }
                    if (p0.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30.h),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.value.currentState!.validate()) {
                      final email = emailController.text.trim();
                      final pass = passController.text.trim();
                      AuthController authController = ref.read(
                        authControllerProvider,
                      );
                      authController
                          .signUp(email, pass)
                          .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Signup successful! Please log in.',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Future.delayed(
                              const Duration(milliseconds: 500),
                              () {
                                Navigator.pop(context);
                              },
                            );
                          })
                          .catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Signup failed: ${error.toString()}',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });

                      debugPrint('Email: $email, Password: $pass');
                    }
                  },
                  child: const Text("Sign In"),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: InkWell(
        child: Text("Already have an account? Log In"),
        onTap: () {
          Navigator.pushNamed(context, LoginScreen.route);
        },
      ),
    );
  }
}
