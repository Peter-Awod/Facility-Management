// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../shared/constants.dart';
import '../../shared/custom_widgets/custom_material_button.dart';
import '../../shared/custom_widgets/custom_text_form_field.dart';
import '../../shared/custom_widgets/snack_bar.dart';
import 'register_cubit/register_cubit.dart';
import 'register_cubit/register_states.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String id = 'RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailAddressController = TextEditingController();
  var passwordController = TextEditingController();

  String? name, phone, emailAddress, password;

  var formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is CreateUserSuccessState) {
            showSnackBar(
              context: context,
              message: 'The account created successfully.',
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          RegisterCubit registerCubit = RegisterCubit.get(context);
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: kSecondaryColor,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              backgroundColor: kPrimaryColor,
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Form(
                    autovalidateMode: autovalidateMode,
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Text(
                                'REGISTER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // name
                          CustomTextFormField(
                            keyboardType: TextInputType.name,
                            prefixIcon: const Icon(Icons.person_2_outlined),
                            textEditingController: nameController,
                            hintText: 'Enter your name',
                            onChanged: (nameValue) {
                              name = nameValue;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          // email
                          CustomTextFormField(
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email_outlined),
                            textEditingController: emailAddressController,
                            hintText: 'Enter your email',
                            onChanged: (emailAddressValue) {
                              emailAddress = emailAddressValue;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          // phone
                          CustomTextFormField(
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(Icons.phone_iphone_outlined),
                            textEditingController: phoneController,
                            hintText: 'Enter your phone number',
                            onChanged: (phoneValue) {
                              phone = phoneValue;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          // password
                          CustomTextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            prefixIcon: const Icon(Icons.lock_outline),
                            textEditingController: passwordController,
                            hintText: 'Enter your password',
                            obscureText: registerCubit.isPassword,
                            suffixIcon: registerCubit.suffix,
                            onChanged: (passwordValue) {
                              password = passwordValue;
                            },
                            suffixIconPressed: () {
                              registerCubit.changeIcon();
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // register button
                          CustomMaterialButton(
                            buttonName: 'REGISTER',
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();

                                isLoading = true;
                                setState(() {});
                                await registerCubit.userRegister(
                                  context: context,
                                  name: nameController.text,
                                  email: emailAddressController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                );

                                isLoading = false;
                                setState(() {});
                              } else {
                                autovalidateMode = AutovalidateMode.always;
                              }
                            },
                          ),
                          Row(
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Color(0xffC7EDE6),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
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

  Future<void> userRegistration() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddressController.text,
      password: passwordController.text,
    );
  }
}
