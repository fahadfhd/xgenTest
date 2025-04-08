import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xgen_test/features/auth/data/sigin_provider.dart';
import 'package:xgen_test/features/auth/presentation/sign_screen.dart';
import 'package:xgen_test/features/common_widget/common_text_field.dart';
import 'package:xgen_test/features/home/presentation/home_screen.dart';

class LoginScreen extends HookConsumerWidget {
  static const String route = '/login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passController = useTextEditingController();
    final _formKey = useState(GlobalKey<FormState>());

    return Scaffold(
      appBar: AppBar(title: const Text('LogIn')),
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
                          .signIn(email, pass)
                          .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login successful!'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Navigator.pushReplacementNamed(
                              context,
                              HomeScreen.route,
                            );
                          })
                          .catchError((error) {
                            String errorMessage =
                                'Login failed. Please try again.';
                            if (error is FirebaseAuthException) {
                              errorMessage = error.message ?? errorMessage;
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });

                      debugPrint('Email: $email, Password: $pass');
                    }
                  },
                  child: const Text("Login In"),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: InkWell(
        child: Text("Create a new account ?"),
        onTap: () {
          Navigator.pushNamed(context, SignScreen.route);
        },
      ),
    );
  }
}
