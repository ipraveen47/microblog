import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:microblog/core/common/widgets/loader.dart';
import 'package:microblog/core/utils/show_snackbar.dart';
import 'package:microblog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:microblog/features/auth/presentation/pages/signup_page.dart';
import 'package:microblog/features/auth/presentation/widgets/auth_field.dart';
import 'package:microblog/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:microblog/features/blog/presentation/pages/blog_page.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
          if (state is AuthFailure) {
            showSnackbar(context, state.message);
          } else if (state is AuthSuccess) {
            Navigator.pushAndRemoveUntil(
                context, BlogPage.route(), (route) => false);
          }
        }, builder: (context, state) {
          if (state is AuthLoading) {
            return const Loader();
          }

          return Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login Page',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                AuthField(
                  hintText: 'Email',
                  controller: emailController,
                ),
                const SizedBox(height: 15),
                AuthField(
                  hintText: 'Password',
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                AuthGradientButton(
                  onPresed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(AuthLogin(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim()));
                    }
                  },
                  buttonText: 'login',
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, SignupPage.route());
                  },
                  child: RichText(
                      text: TextSpan(
                    text: "Don't have an account?",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    children: [
                      TextSpan(
                        text: ' Sign Up',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  )),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
