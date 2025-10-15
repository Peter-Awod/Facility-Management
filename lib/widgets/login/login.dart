// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../shared/constants.dart';
import '../../shared/custom_widgets/custom_material_button.dart';
import '../../shared/custom_widgets/custom_text_form_field.dart';
import 'login_cubit/login_cubit.dart';
import 'login_cubit/login_states.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginLoadingState) {
            setState(() => isLoading = true);
          } else {
            setState(() => isLoading = false);
          }
        },
        builder: (context, state) {
          final cubit = LoginCubit.get(context);

          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              backgroundColor: kPrimaryColor,
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Form(
                    key: formKey,
                    autovalidateMode: autoValidateMode,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'LOGIN',
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Email
                          CustomTextFormField(
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email_outlined),
                            textEditingController: emailController,
                            hintText: 'Enter your email',
                            onChanged: (_) {},
                          ),
                          const SizedBox(height: 10),

                          // Password
                          CustomTextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            prefixIcon: const Icon(Icons.lock_outline),
                            textEditingController: passwordController,
                            hintText: 'Enter your password',
                            obscureText: cubit.isPassword,
                            suffixIcon: cubit.suffix,
                            suffixIconPressed: cubit.changeIcon,
                          ),
                          const SizedBox(height: 20),

                          // Login button
                          CustomMaterialButton(
                            buttonName: 'LOGIN',
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                await cubit.userLogin(
                                  context: context,
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                              } else {
                                setState(() => autoValidateMode =
                                    AutovalidateMode.always);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
