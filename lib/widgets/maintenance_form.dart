// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/submit_maintenance_form_cubit/submit_maintenance_form_cubit.dart';
import '../cubit/submit_maintenance_form_cubit/submit_maintenance_form_states.dart';
import '../cubit/user_info_cubit/user_info_cubit.dart';
import '../models/maintenance_form_model.dart';
import '../shared/constants.dart';
import '../shared/custom_widgets/custom_material_button.dart';
import '../shared/custom_widgets/custom_text_form_field.dart';
import '../shared/custom_widgets/snack_bar.dart';

class MaintenanceForm extends StatefulWidget {
  const MaintenanceForm({super.key});

  @override
  State<MaintenanceForm> createState() => _MaintenanceFormState();
}

class _MaintenanceFormState extends State<MaintenanceForm> {
  var formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  var bankNameController = TextEditingController();
  var branchNameController = TextEditingController();
  var maintenanceTypeController = TextEditingController();
  var addressDetailsController = TextEditingController();
  var maintenanceDetailsController = TextEditingController();

  String? bankName, branchName, maintenanceType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubmitMaintenanceFormCubit(),
      child: BlocConsumer<SubmitMaintenanceFormCubit, SubmitMaintenanceFormStates>(
        listener: (context, state) {
          if (state is SubmitFormSuccessState) {
            showSnackBar(
              context: context,
              message: 'Form submitted successfully',
            );
            BlocProvider.of<UserInfoCubit>(context).getUserInfo();
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          SubmitMaintenanceFormCubit formCubit = BlocProvider.of(context);
          return Scaffold(
            backgroundColor: kPrimaryColor,
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
              title: const Text(
                'Maintenance Form',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kSecondaryColor,
                ),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                autovalidateMode: autoValidateMode,
                key: formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // name
                      Text(
                        BlocProvider.of<UserInfoCubit>(context).userModel!.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kSecondaryColor,
                        ),
                      ),

                      // bank name
                      CustomTextFormField(
                        keyboardType: TextInputType.name,
                        textEditingController: bankNameController,
                        hintText: 'Enter bank name',
                        prefixIcon: const Icon(Icons.account_balance_outlined),
                        onSaved: (value) {
                          bankName = value!;
                        },
                      ),
                      const SizedBox(height: 10),

                      // branch name
                      CustomTextFormField(
                        keyboardType: TextInputType.name,
                        textEditingController: branchNameController,
                        hintText: 'Enter branch name',
                        prefixIcon: const Icon(Icons.account_balance_outlined),
                        onSaved: (value) {
                          branchName = value!;
                        },
                      ),
                      const SizedBox(height: 10),

                      // address details
                      CustomTextFormField(
                        textEditingController: addressDetailsController,
                        hintText: 'Add more details about address (optional)',
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          maintenanceType = value!;
                        },
                        maxLines: 3,
                      ),
                      const SizedBox(height: 10),

                      // maintenance
                      CustomTextFormField(
                        textEditingController: maintenanceTypeController,
                        hintText: 'Enter maintenance type',
                        prefixIcon: const Icon(Icons.engineering_outlined),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          maintenanceType = value!;
                        },
                      ),
                      const SizedBox(height: 10),

                      // maintenance details
                      CustomTextFormField(
                        textEditingController: maintenanceDetailsController,
                        hintText:
                            'Add more details about your maintenance request (optional)',
                        prefixIcon: const Icon(Icons.engineering_outlined),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          maintenanceType = value!;
                        },
                        maxLines: 3,
                      ),
                      const SizedBox(height: 10),

                      const SizedBox(height: 20),

                      // Submission button
                      CustomMaterialButton(
                        onPressed: () {
                          if (addressDetailsController.text.isEmpty) {
                            addressDetailsController.text = 'No details';
                          }
                          if (maintenanceDetailsController.text.isEmpty) {
                            maintenanceDetailsController.text = 'No details';
                          }

                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            var formModel = MaintenanceFormModel(
                              formId: '',
                              bankName: bankNameController.text,
                              branchName: branchNameController.text,
                              name: BlocProvider.of<UserInfoCubit>(
                                context,
                              ).userModel!.name,
                              phone: BlocProvider.of<UserInfoCubit>(
                                context,
                              ).userModel!.phone,
                              maintenanceType: maintenanceTypeController.text,

                              addressDetails: addressDetailsController.text,
                              maintenanceDetails:
                                  maintenanceDetailsController.text,
                            );
                            formCubit.submitForm(formModel);
                          } else {
                            autoValidateMode = AutovalidateMode.always;
                          }
                        },
                        buttonName: 'Submit',
                      ),
                    ],
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
