import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outlined_text/outlined_text.dart';
import 'package:project_management_app/data_layer/data_layer.dart';
import 'package:project_management_app/models/profile_model.dart';
import 'package:project_management_app/networking/api_networking.dart';
import 'package:project_management_app/screens/Auth/first_screen.dart';
import 'package:project_management_app/screens/Edit_Profile/edit_profile_screen.dart';
import 'package:project_management_app/screens/Home/projects_contaner.dart';
import 'package:project_management_app/screens/Profile/custom_profile_links.dart';
import 'package:project_management_app/screens/Profile/custom_project_tile.dart';
import 'package:project_management_app/screens/Supervisor/add_project_screen.dart';
import 'package:project_management_app/services/setup.dart';
import 'package:project_management_app/screens/Profile/bloc/profole_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String token = locator.get<DataLayer>().auth!.token;

    return BlocProvider(
      create: (context) => ProfileBloc(api: ApiNetworking(), token: token)
        ..add(FetchProfileEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: const Color(0xff4129B7),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                await locator.get<DataLayer>().logOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FirstScreen()),
                    (route) => false);
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileErrorState) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state is ProfileLoadedState) {
              Profile profile = state.profile;
              List<String> labels = [
                'Github',
                'BlindLink',
                'LinkedIn',
                'Resume'
              ];
              List<String> urls = [
                profile.link.github,
                profile.link.bindlink,
                profile.link.linkedin,
                profile.link.resume,
              ];

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProfileBloc>().add(FetchProfileEvent());
                },
                child: SingleChildScrollView(
                  physics:
                      const AlwaysScrollableScrollPhysics(), // تأكد من التمرير الدائم
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Column(
                      children: [
                        Container(
                          height: 82,
                          width: 319,
                          decoration: BoxDecoration(
                            color: const Color(0xff4129B7),
                            borderRadius: BorderRadius.circular(37),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 68,
                                width: 68,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: Colors.white, width: 4)),
                                child: ClipOval(
                                    child: profile.imageUrl == 'null'
                                        ? Image.asset(
                                            'assets/pfp.png',
                                            width: 68,
                                            height: 68,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            profile.imageUrl,
                                            width: 68,
                                            height: 68,
                                            fit: BoxFit.cover,
                                          )),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedText(
                                    text: const Text(
                                      'Welcome Back!',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    strokes: [
                                      OutlinedTextStroke(
                                          color: const Color(0xff828181),
                                          width: 2),
                                    ],
                                  ),
                                  OutlinedText(
                                    text: Text(
                                      '${profile.firstName} ${profile.lastName}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    strokes: [
                                      OutlinedTextStroke(
                                          color: const Color(0xff828181),
                                          width: 2),
                                    ],
                                  ),
                                  OutlinedText(
                                    text: Text(
                                      profile.role,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    strokes: [
                                      OutlinedTextStroke(
                                          color: const Color(0xff828181),
                                          width: 2),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfileScreen(
                                                profile: profile,
                                              )));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 5),
                              height: 41,
                              width: 144,
                              decoration: BoxDecoration(
                                color: const Color(0xff4129B7),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Accounts:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Image.asset('assets/Group 58.png'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ...List.generate(labels.length, (index) {
                          return CustomProfileLinks(
                            label: labels[index],
                            url: urls[index],
                          );
                        }),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 5),
                                margin: const EdgeInsets.only(left: 5),
                                height: 41,
                                width: 144,
                                decoration: BoxDecoration(
                                  color: const Color(0xff4129B7),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'My projects:',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              if (profile.role == 'supervisor')
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AddProjectScreen(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xff4129B7),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.add, size: 20),
                                      SizedBox(width: 5),
                                      Text('Add Project'),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...List.generate(profile.projects.length, (index) {
                          return CustomProjectTile(
                              project: profile.projects[index],
                              profile: profile,
                              token: token,
                              index: index);
                          // return ListTile(
                          //     trailing: profile.role == 'supervisor'
                          //         ? IconButton(
                          //             onPressed: () {
                          //               showDialog(
                          //                   context: context,
                          //                   builder: (context) {
                          //                     return AlertDialog(
                          //                       content: const Text(
                          //                           'Are you sure you want to delete this project?'),
                          //                       actions: [
                          //                         TextButton(
                          //                             onPressed: () async {
                          //                               await ApiNetworking()
                          //                                   .deleteProject(
                          //                                       token: token,
                          //                                       projectId: profile
                          //                                           .projects[
                          //                                               index]
                          //                                           .projectId!);
                          //                               ScaffoldMessenger.of(
                          //                                       context)
                          //                                   .showSnackBar(
                          //                                       const SnackBar(
                          //                                           content: Text(
                          //                                               'Project Deleted Successfully')));
                          //                               Navigator.pop(context);
                          //                             },
                          //                             child: const Text('YES')),
                          //                         TextButton(
                          //                             onPressed: () {
                          //                               Navigator.pop(context);
                          //                             },
                          //                             child: const Text('No'))
                          //                       ],
                          //                     );
                          //                   });
                          //             },
                          //             icon: const Icon(
                          //               Icons.delete,
                          //               color: Colors.red,
                          //             ),
                          //           )
                          //         : null,
                          //     title:
                          //         Projects(project: profile.projects[index]));
                        }),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const Center(child: Text('Something went wrong'));
          },
        ),
      ),
    );
  }
}
