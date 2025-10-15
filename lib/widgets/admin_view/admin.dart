// import 'package:flutter/material.dart';
//
// import '../../shared/constants.dart';
//
// class Admin extends StatelessWidget {
//   const Admin({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kPrimaryColor,
//       appBar: AppBar(
//         backgroundColor: kPrimaryColor,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back_ios_new_outlined,
//             color: kSecondaryColor,
//           ),
//         ),
//         centerTitle: true,
//         title: const Text(
//           'Admin',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: kSecondaryColor,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: ListView.builder(
//           itemCount: 20,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: EdgeInsetsDirectional.only(bottom: 8),
//               child: Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: kSecondaryColor, width: 4),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Request',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: kSecondaryColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/get_maintenance_requests_cubit/get_maintenance_requests_cubit.dart';
import '../../cubit/get_maintenance_requests_cubit/get_maintenance_requests_states.dart';
import '../../models/maintenance_form_model.dart';
import '../../shared/constants.dart';

class MaintenanceRequestsAdminView extends StatelessWidget {
  const MaintenanceRequestsAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetMaintenanceRequestsCubit()..getRequests(),
      child: BlocBuilder<GetMaintenanceRequestsCubit, GetMaintenanceRequestsStates>(
        builder: (context, state) {
          var cubit = GetMaintenanceRequestsCubit.get(context);
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
              centerTitle: true,
              title: const Text(
                'Maintenance Requests',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kSecondaryColor,
                ),
              ),
            ),
            body: state is GetMaintenanceRequestsLoadingState
                ? const Center(child: CircularProgressIndicator())
                : DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  const TabBar(
                    dividerColor: kPrimaryColor,
                    labelColor: kSecondaryColor,
                    indicatorColor: kSecondaryColor,
                    unselectedLabelColor: kTabsColor,
                    tabs: [
                      Tab(text: 'All requests'),
                      Tab(text: 'Pending'),
                      Tab(text: 'In-Progress'),
                      Tab(text: 'Completed'),
                    ],
                  ),


                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildRequestList(cubit.allRequests),
                        _buildRequestList(cubit.pendingRequests),
                        _buildRequestList(cubit.inProgressRequests),
                        _buildRequestList(cubit.completedRequests),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequestList(List<MaintenanceFormModel> requests) {
    if (requests.isEmpty) {
      return const Center(
        child: Text(
          'No requests found',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final request = requests[index];
        return Card(
          color: kSecondaryColor.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(
              request.maintenanceType,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${request.name} • ${request.phone}\n${request.addressDetails ?? ''}',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        );
      },
    );
  }
}
