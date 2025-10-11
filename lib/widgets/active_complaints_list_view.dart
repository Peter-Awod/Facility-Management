import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/get_complaints_cubit/get_complaints_cubit.dart';
import '../cubit/get_complaints_cubit/get_complaints_states.dart';
import '../models/complaints_form_model.dart';
import '../shared/constants.dart';
import '../shared/custom_widgets/snack_bar.dart';

class ActiveComplaintsListView extends StatelessWidget {
  const ActiveComplaintsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetComplaintsCubit, GetComplaintsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var complaintsCubit = GetComplaintsCubit.get(context);
        List<ComplaintsFormModel> complaintsList =
            complaintsCubit.complaintsFormModelList;
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
              'Active Complaints',
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
            child: ConditionalBuilder(
              condition: complaintsList.isNotEmpty,
              builder: (context) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(
                        bottom: 8,
                      ),
                      child: GestureDetector(
                        onLongPress: () {
                          Clipboard.setData(
                            ClipboardData(
                                text: complaintsList[index].complaintNumber),
                          );
                          showSnackBar(
                              context: context,
                              message: 'Complaint number copied to clipboard');
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: kSecondaryColor,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Complaint number',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: kSecondaryColor,
                                ),
                              ),
                              Text(
                                'Long press to copy \n ${complaintsList[index].complaintNumber}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: kSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: complaintsList.length,
                );
              },
              fallback: (context) => Center(
                child: Text('There is no active complaints '),
              ),
            ),
          ),
        );
      },
    );
  }
}
