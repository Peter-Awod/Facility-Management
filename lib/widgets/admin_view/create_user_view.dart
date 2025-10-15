import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/custom_widgets/custom_material_button.dart';
import '../../shared/custom_widgets/custom_text_form_field.dart';
import '../../shared/custom_widgets/snack_bar.dart';
import '../../shared/constants.dart';
import 'cubit/admin_users_cubit.dart';

class CreateUserView extends StatefulWidget {
  const CreateUserView({super.key});

  @override
  State<CreateUserView> createState() => _CreateUserViewState();
}

class _CreateUserViewState extends State<CreateUserView> {
  final formKey = GlobalKey<FormState>();
  String selectedRole = 'Bank';

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final bankNameController = TextEditingController();
  final branchNameController = TextEditingController();
  final managerNameController = TextEditingController();
  final managerPhoneController = TextEditingController();
  final branchAddressController = TextEditingController();
  final jobTitleController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    bankNameController.dispose();
    branchNameController.dispose();
    managerNameController.dispose();
    managerPhoneController.dispose();
    branchAddressController.dispose();
    jobTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminCubit = context.read<AdminUsersCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New User"),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedRole,
                decoration: const InputDecoration(labelText: "Select Role"),
                items: const [
                  DropdownMenuItem(value: 'Bank', child: Text('Bank')),
                  DropdownMenuItem(value: 'Technician', child: Text('Technician')),
                ],
                onChanged: (value) => setState(() => selectedRole = value!),
              ),
              const SizedBox(height: 12),

              CustomTextFormField(
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email),
                textEditingController: emailController,
                hintText: 'Email',

              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: const Icon(Icons.lock),
                textEditingController: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 12),

              if (selectedRole == 'Bank') ...[
                CustomTextFormField(
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(Icons.account_balance),
                  textEditingController: bankNameController,
                  hintText: 'Bank Name',
                ),
                CustomTextFormField(
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(Icons.location_city),
                  textEditingController: branchNameController,
                  hintText: 'Branch Name',
                ),
                CustomTextFormField(
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(Icons.person),
                  textEditingController: managerNameController,
                  hintText: 'Manager Name',
                ),
                CustomTextFormField(
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone),
                  textEditingController: managerPhoneController,
                  hintText: 'Manager Phone',
                ),
                CustomTextFormField(
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(Icons.location_on),
                  textEditingController: branchAddressController,
                  hintText: 'Branch Address',
                ),
              ] else ...[
                CustomTextFormField(
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(Icons.person),
                  textEditingController: nameController,
                  hintText: 'Name',
                ),
                CustomTextFormField(
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(Icons.work),
                  textEditingController: jobTitleController,
                  hintText: 'Job Title',
                ),
                CustomTextFormField(
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone),
                  textEditingController: phoneController,
                  hintText: 'Phone Number',
                ),
              ],

              const SizedBox(height: 20),
              CustomMaterialButton(
                buttonName: "Create User",
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  try {
                    await adminCubit.createUser(
                      context: context,
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      role: selectedRole,
                      name: nameController.text.trim(),
                      phone: phoneController.text.trim(),
                      bankName: bankNameController.text.trim(),
                      branchName: branchNameController.text.trim(),
                      managerName: managerNameController.text.trim(),
                      managerPhone: managerPhoneController.text.trim(),
                      branchAddress: branchAddressController.text.trim(),
                      jobTitle: jobTitleController.text.trim(),
                    );

                    showSnackBar(context: context, message: "✅ User created successfully");
                    Navigator.pop(context);
                  } catch (e) {
                    showSnackBar(context: context, message: "Error: ${e.toString()}");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
