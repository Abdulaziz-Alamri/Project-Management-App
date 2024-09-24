import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/networking/api_networking.dart';
import 'package:project_management_app/screens/Admin/cubit/admin_page_cubit.dart';
import 'package:project_management_app/screens/Admin/custom_info_cards.dart';
import 'package:sizer/sizer.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController userIdController = TextEditingController();
    String role = '';
    return BlocProvider(
      create: (context) =>
          AdminPageCubit(apiNetworking: ApiNetworking())..fetchProjects(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Admin Page",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: const Color(0xff4129B7),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.sp),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Image.asset(
                      scale: 3,
                      'assets/Group 10 (1).png',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BlocBuilder<AdminPageCubit, AdminPageState>(
                        builder: (context, state) {
                          if (state is AdminPageLoading) {
                            return const CircularProgressIndicator();
                          } else if (state is AdminPageLoaded) {
                            return CustomInfoCards(
                              numberOfProjects: state.projects.length,
                            );
                          } else if (state is AdminPageError) {
                            return Text('Error: ${state.message}');
                          } else {
                            return const Text('No projects found.');
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        child: Column(
                          children: [
                            ListTile(
                              minLeadingWidth: 80,
                              leading: const Text(
                                'User Id: ',
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xff4129B7)),
                              ),
                              title: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(0.25),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextField(
                                  controller: userIdController,
                                  cursorColor: Colors.black,
                                  maxLines: 1,
                                  style: const TextStyle(fontSize: 16),
                                  textAlignVertical: TextAlignVertical.top,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Assign Role: ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff4129B7),
                                      fontWeight: FontWeight.bold),
                                ),
                                DropdownMenu(
                                  onSelected: (value) {
                                    role = value!;
                                  },
                                  dropdownMenuEntries: const [
                                    DropdownMenuEntry(
                                        value: 'supervisor',
                                        label: 'Supervisor'),
                                    DropdownMenuEntry(
                                        value: 'user', label: 'User'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          height: 30,
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              ApiNetworking().changeRole(
                                  userId: userIdController.text, role: role);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff4129B7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Change User Role",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
