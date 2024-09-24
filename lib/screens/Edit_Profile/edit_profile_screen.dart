import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outlined_text/outlined_text.dart';
import 'package:project_management_app/data_layer/data_layer.dart';
import 'package:project_management_app/models/profile_model.dart';
import 'package:project_management_app/screens/Edit_Profile/cubit/edit_profile_cubit.dart';
import 'package:project_management_app/screens/Edit_Profile/cubit/edit_profile_state.dart';
import 'package:project_management_app/screens/Edit_Profile/custom_edit_links.dart';
import 'package:project_management_app/services/setup.dart';

class EditProfileScreen extends StatelessWidget {
  final Profile profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    // Define text controllers
    final TextEditingController firstNameController =
        TextEditingController(text: profile.firstName);

    final TextEditingController lastNameController =
        TextEditingController(text: profile.lastName);
    final TextEditingController githubController =
        TextEditingController(text: profile.link.github);
    final TextEditingController bindlinkController =
        TextEditingController(text: profile.link.bindlink);
    final TextEditingController linkedinController =
        TextEditingController(text: profile.link.linkedin);

    return BlocProvider(
      create: (context) => EditProfileCubit(),
      child: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Updated successfully!')),
            );
          } else if (state is EditProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: const BackButton(color: Colors.white),
              title: const Text("Edit Profile",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color(0xff4129B7),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 50),
                child: Column(
                  children: [
                    Container(
                      height: 82,
                      width: 319,
                      decoration: BoxDecoration(
                          color: const Color(0xff4129B7),
                          borderRadius: BorderRadius.circular(37)),
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
                                  child: Image.asset(
                                'assets/pfp.png',
                                width: 68,
                                height: 68,
                                fit: BoxFit.cover,
                              ))),
                          const SizedBox(width: 20),
                          Center(
                            child: OutlinedText(
                                text: const Text(
                                  'Welcome Back !',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                strokes: [
                                  OutlinedTextStroke(
                                      color: const Color(0xff828181), width: 2),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'My Info:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff57E3D8)),
                        )),
                    CustomEditLinks(
                        controller: firstNameController, label: 'First Name'),
                    CustomEditLinks(
                        controller: lastNameController, label: 'Last Name'),
                    const SizedBox(height: 20),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Social Accounts:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff57E3D8)),
                        )),
                    CustomEditLinks(
                        controller: githubController, label: 'GitHub'),
                    CustomEditLinks(
                        controller: bindlinkController, label: 'BlindLink'),
                    CustomEditLinks(
                        controller: linkedinController, label: 'LinkedIn'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Profile Image: ',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff4129B7),
                                fontWeight: FontWeight.bold)),
                        DottedBorder(
                          color: const Color(0xffD9D9D9),
                          strokeWidth: 1,
                          child: Container(
                              height: 76,
                              width: 211,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3)),
                              child: IconButton(
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? image = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (image != null) {
                                    context
                                        .read<EditProfileCubit>()
                                        .pickProfileImage(File(image.path));
                                  }
                                },
                                icon: const Icon(Icons.file_present,
                                    color: Colors.black),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Upload resume: ',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff4129B7),
                                fontWeight: FontWeight.bold)),
                        DottedBorder(
                          color: const Color(0xffD9D9D9),
                          strokeWidth: 1,
                          child: Container(
                              height: 76,
                              width: 211,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3)),
                              child: IconButton(
                                onPressed: () async {
                                  final FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf'],
                                  );
                                  if (result != null) {
                                    context.read<EditProfileCubit>().pickResume(
                                        File(result.files.single.path!));
                                  }
                                },
                                icon: const Icon(Icons.file_present,
                                    color: Colors.black),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        height: 30,
                        width: 170,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<EditProfileCubit>().saveProfile(
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  github: githubController.text,
                                  bindlink: bindlinkController.text,
                                  linkedin: linkedinController.text,
                                 resumeFile: context.read<EditProfileCubit>().resumeFile, 
                                  token: locator.get<DataLayer>().auth!.token,
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff4129B7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Save",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
