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

  var nameController = TextEditingController();
  var mobileNumberController = TextEditingController();
  var buildingNumberController = TextEditingController();
  var floorNumberController = TextEditingController();
  var apartmentNumberController = TextEditingController();
  var maintenanceTypeController = TextEditingController();
  var addressDetailsController = TextEditingController();
  var maintenanceDetailsController = TextEditingController();
  var permissionDetailsController = TextEditingController();

  String? name,
      mobileNumber,
      maintenanceType,
      buildingNumber,
      floorNumber,
      permission,
      apartmentNumber;
  bool showPermissionField = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubmitMaintenanceFormCubit(),
      child:
          BlocConsumer<SubmitMaintenanceFormCubit, SubmitMaintenanceFormStates>(
        listener: (context, state) {
          if (state is SubmitFormSuccessState) {
            showSnackBar(
                context: context, message: 'Form submitted successfully');
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
                      CustomTextFormField(
                        keyboardType: TextInputType.name,
                        textEditingController: nameController,
                        hintText: 'Enter your full name',
                        prefixIcon: const Icon(
                          Icons.person_2_outlined,
                        ),
                        onSaved: (value) {
                          name = value!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // mobile
                      CustomTextFormField(
                        textEditingController: mobileNumberController,
                        hintText: 'Enter your phone number',
                        prefixIcon: const Icon(Icons.phone_iphone_outlined),
                        keyboardType: TextInputType.phone,
                        onSaved: (value) {
                          mobileNumber = value!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      //building
                      CustomTextFormField(
                        textEditingController: buildingNumberController,
                        hintText: 'Enter your building number',
                        prefixIcon: const Icon(Icons.house_outlined),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          buildingNumber = value!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // floor
                      CustomTextFormField(
                        textEditingController: floorNumberController,
                        hintText: 'Enter your floor number',
                        prefixIcon: const Icon(Icons.house_outlined),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          floorNumber = value!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // apartment
                      CustomTextFormField(
                        textEditingController: apartmentNumberController,
                        hintText: 'Enter your apartment number',
                        prefixIcon: const Icon(Icons.apartment_outlined),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          apartmentNumber = value!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

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
                      const SizedBox(
                        height: 10,
                      ),

                      // address details
                      CustomTextFormField(
                        textEditingController: addressDetailsController,
                        hintText: 'Add more details about address (optional)',
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          maintenanceType = value!;
                        }, maxLines: 3,
                      ),
                      const SizedBox(
                        height: 10,
                      ),

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
                      const SizedBox(
                        height: 10,
                      ),

                      // permission check box
                      ListTile(
                        title: const Text(
                          'If you want permission click here',
                          style: TextStyle(
                            color: kSecondaryColor,
                            fontSize: 20,
                          ),
                        ),
                        trailing: Checkbox(
                          value: showPermissionField,
                          onChanged: (value) {
                            setState(() {
                              showPermissionField = value!;
                            });
                          },
                          activeColor: kSecondaryColor,
                          // Change the color when checkbox is checked
                          checkColor: Colors.black,
                          // Change the color of the checkmark
                          side: const BorderSide(
                            color: Colors.black,
                            strokeAlign: 2,
                          ),

                          fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              // Change the color of the checkbox itself based on its state
                              if (states.contains(MaterialState.selected)) {
                                return kSecondaryColor; // Color when checkbox is checked
                              }
                              return kPrimaryColor; // Color when checkbox is unchecked
                            },
                          ),
                        ),
                      ),
                      if (showPermissionField)
                        const SizedBox(
                          height: 10,
                        ),

                      // Permissions
                      if (showPermissionField)
                        CustomTextFormField(
                          textEditingController: permissionDetailsController,
                          hintText: 'What kind of permission needed?',
                          prefixIcon: const Icon(Icons.sensor_door_outlined),
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            permission = value!;
                          },
                          maxLines: 3,
                        ),
                      const SizedBox(
                        height: 20,
                      ),

                      // Submission button
                      CustomMaterialButton(
                        onPressed: () {
                          if (addressDetailsController.text.isEmpty) {
                            addressDetailsController.text = 'No details';
                          }
                          if (maintenanceDetailsController.text.isEmpty) {
                            maintenanceDetailsController.text = 'No details';
                          }
                          if (permissionDetailsController.text.isEmpty) {
                            permissionDetailsController.text =
                                'No Permissions needed';
                          }

                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            var formModel = MaintenanceFormModel(
                              formId: '',
                              name: nameController.text,
                              phone: mobileNumberController.text,
                              maintenanceType: maintenanceTypeController.text,
                              buildingNo: buildingNumberController.text,
                              floorNo: floorNumberController.text,
                              apartmentNo: apartmentNumberController.text,
                              addressDetails: addressDetailsController.text,
                              maintenanceDetails:
                                  maintenanceDetailsController.text,
                              permission: permissionDetailsController.text,
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
