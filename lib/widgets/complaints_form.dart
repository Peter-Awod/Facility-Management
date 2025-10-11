// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/complaints_form_cubit/complaints_form_cubit.dart';
import '../cubit/complaints_form_cubit/complaints_form_states.dart';
import '../cubit/user_info_cubit/user_info_cubit.dart';
import '../models/complaints_form_model.dart';
import '../shared/constants.dart';
import '../shared/custom_widgets/custom_material_button.dart';
import '../shared/custom_widgets/custom_text_form_field.dart';
import '../shared/custom_widgets/snack_bar.dart';

class ComplaintsForm extends StatefulWidget {
  const ComplaintsForm({super.key});

  @override
  State<ComplaintsForm> createState() => _ComplaintsFormState();
}

class _ComplaintsFormState extends State<ComplaintsForm> {
  var formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  var buildingNumberController = TextEditingController();
  var unitNumberController = TextEditingController();
  var unitTypeController = TextEditingController();
  var complaintsTypeController = TextEditingController();
  var complaintDetailsController = TextEditingController();

  String?
      complaintsType,
      buildingNumber,
      unitNumber,
      unitType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubmitComplaintFormCubit(),
      child:
          BlocConsumer<SubmitComplaintFormCubit, ComplaintsFormStates>(
        listener: (context, state) {
          if (state is SubmitFormSuccessState) {
            showSnackBar(
                context: context, message: 'Form submitted successfully');
            BlocProvider.of<UserInfoCubit>(context).getUserInfo();
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          SubmitComplaintFormCubit formCubit = BlocProvider.of(context);
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
                'Complaint Form',
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
                      // // name
                      // CustomTextFormField(
                      //   keyboardType: TextInputType.name,
                      //   textEditingController: nameController,
                      //   hintText: 'Enter your full name',
                      //   prefixIcon: const Icon(
                      //     Icons.person_2_outlined,
                      //   ),
                      //   onSaved: (value) {
                      //     name = value!;
                      //   },
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      //
                      // // mobile
                      // CustomTextFormField(
                      //   textEditingController: phoneController,
                      //   hintText: 'Enter your phone number',
                      //   prefixIcon: const Icon(Icons.phone_iphone_outlined),
                      //   keyboardType: TextInputType.phone,
                      //   onSaved: (value) {
                      //     phone = value!;
                      //   },
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),

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

                      // unit type
                      CustomTextFormField(
                        textEditingController: unitTypeController,
                        hintText: 'Enter your unit type (apartment, house)',
                        prefixIcon: const Icon(Icons.apartment_outlined),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          unitType = value!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // unit number
                      CustomTextFormField(
                        textEditingController: unitNumberController,
                        hintText: 'Enter your unit number',
                        prefixIcon: const Icon(Icons.house_outlined),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          unitNumber = value!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // complaint
                      CustomTextFormField(
                        textEditingController: complaintsTypeController,
                        hintText: 'Enter complaint type',
                        prefixIcon: const Icon(Icons.report_problem_outlined),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          complaintsType = value!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),



                      // complaint details
                      CustomTextFormField(
                        textEditingController: complaintDetailsController,
                        hintText:
                            'Add more details about your complaint ',
                        prefixIcon: const Icon(Icons.report_problem_outlined),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          complaintsType = value!;
                        },
                        maxLines: 3,
                      ),
                      const SizedBox(
                        height: 10,
                      ),





                      // Submission button
                      CustomMaterialButton(
                        onPressed: () {


                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            var complaintsFormModel = ComplaintsFormModel(
                              formId: '',
                              userId:BlocProvider.of<UserInfoCubit>(context).userModel!.userId ,
                              complaintNumber: DateTime.now().millisecondsSinceEpoch.toString(),
                              name: BlocProvider.of<UserInfoCubit>(context).userModel!.name,
                              phone: BlocProvider.of<UserInfoCubit>(context).userModel!.phone,
                              buildingNumber: buildingNumberController.text,
                              unitType: unitTypeController.text,
                              unitNumber: unitNumberController.text,
                              complaintsType: complaintsTypeController.text,
                              complaintDetails:
                                  complaintDetailsController.text,
                              complainIsActive: true,

                            );
                            formCubit.submitForm(complaintsFormModel);
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
