import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:project_management_app/models/member_model.dart';
import 'package:project_management_app/models/project_link.dart';
import 'package:project_management_app/networking/api_networking.dart';
import 'package:project_management_app/screens/Edit_Project/custom_edit_textfiled.dart';
import 'package:project_management_app/screens/Edit_Project/upload_section.dart';

class EditProjectScreen extends StatefulWidget {
  const EditProjectScreen({super.key});

  @override
  _EditProjectScreenState createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final ApiNetworking api = ApiNetworking(); // Instance of ApiNetworking

  // Controllers for the form fields
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController bootcampNameController = TextEditingController();
  final TextEditingController projectTypeController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController presentationDateController =
      TextEditingController();
  final TextEditingController projectDescriptionController =
      TextEditingController();
  final TextEditingController githubController = TextEditingController();
  final TextEditingController figmaController = TextEditingController();
  final TextEditingController videoController = TextEditingController();
  final TextEditingController pinterestController = TextEditingController();
  final TextEditingController playStoreController = TextEditingController();
  final TextEditingController appleStoreController = TextEditingController();
  final TextEditingController apkController = TextEditingController();
  final TextEditingController webLinkController = TextEditingController();

  List<MemberModel> members = [];
  List<TextEditingController> positionControllers = [];
  List<TextEditingController> userIdControllers = [];

  File? logoFile;
  File? presentationFile;
  List<File> imageFiles = [];

  String token =
      "YWU1YzhkZmU4MWI3NWE1Y2Y3MzQ0ZjQwNTg2NmQwOWI4MWUwZTExZjQyNDNlNTI1YzRiNDAzMDBiZDE0YWQ0MTIxMTBmNGNhYjgyZjIwZDU4NmYyMjllNmY0MmY2ZTE1ZDEzODAwNTQ3ODc0MzQ0YjU4MTNmNDljZGU1NmYyMjE1NDk3NjdhNzYyN2UxZWMzYjQ0NGZhZDZhMzA0OTY4M2QwMDYyYmEzZjAzMzU5OWIyMDNjODVjZDQyYTRiYjk4YjU2NzYxZDFlYmVkNzExZGU4ZjAyNGE1NjAxMTg2ZjE0Yjc1MjIwNGM0MDdkYmNmZTc2NWJlYzY4MDU0ZjAzYmNmZGY3NWM1ZDgxZGYwZWE1ZDllOTc1MDIxMTVhNWI4YjU5ODAyMTM0MTc2NmRjYjA3ZjE4ZDZlMmRlM2M0ZThjODc3OTFjNGMyOTUwYjE5MmVjMzJlMTZkN2JiNDRhNWI3NzU0MDIyYTdmODk3MzE3NWQ1MzM5NTUzODNhYmExZGY1MzE5OTY0YWYwYjc0MmMxZThmNTI4YmZiODNlMTE1OTE3ZTZjYjMyMWQ2NmJlNDA5YTA2Y2RmYTFkZWRhNzE5ZTU2MTFlMGIyN2NjMDE1MjI5ZmM1ZGVkYTgxMjViZDNjZmVmM2M4MDg5NjA4OWJlMGE0M2NjY2E2MDc0ZmYyZTQ5MDVhM2RmMDI2ZDU4NDhiNDhmYzBkYjY1MGFlMGY3NzFiZTlkOWU4OGQ0ZDk5YzNkODkxNWNjMGRhNzdlOGZiNWY1NzNlMGFkNWU1N2U0MWZjODQ0MzhjYWJmZThlZGVkYWI1ODQ2OTIzNzE4MDFhZWZmZGRkZTkzMmVlN2FmMTgzMjA0ZmMxZDMxMmMzYWU5YzRkNGZhOGMwMzg4NmI4NDU3ODg5YjlhMGM1Zjk4YWU0N2EwNjVhYTcwMmU1OGI4NmRiNTk1ODRjNzM5MjBkODY2MGRiYzRkNjk4MjA3OGMwYWIxNjA0NzgzOTk4NTE3NmFkYjE2ZGRiZjdlNTMwOGVhYmM3ODc3YmI2YWIxMTQzMjczMzBjMjljZmU1OTc5ZDMzYzViN2IzZmI0YzMxZjQ1ZjhiMDZmZDVjMTczZjQzN2RlZjM1MGE0NmY1OTc0NjFjNTY3MmZjOWI1ZmQ0OTRhNjUyMmQyZWY0YmE0NDM5YzA2NDRmMzA0YWEzODk1ZDQyYWUzOWRiMTVlNjBjYWZmODkzNjRjZjI3MTMzMzI4ZTIwNWU1OTc4YmNkODJkMGVlMzVlODc4OTg4OTg5OWI5ZmVjZjRiNzZiZGE3NmMzNTBlOWM2ZDJiODgwNThkNWYwYjZiMmQzY2YxMTJkYjY2YzQwMTE0YWU5YmM1NmU4ODZiN2UzNTc1NjE4ZWZlMjQ0YmY2ZTFmMTc4ZmY2ODI5MTljNjk5YzNmOGM2ZTI4NDM4NzkzNmRlNTk2YzUxMDk3ODE4MGIzYTY2OTk5OWE0Y2JjZGZjODg1ZTU5ZTU0NTU4YjllNzhhZmM5OTNlZjA5NWQ5MTA5OTUwZGNlMzk5ZjgwZGVmYzRjNDlkMDE4YWQ1ODM3YTc0N2QyOWJiMTZiNDEyN2M5ZDY1NGYzMDRmMWU1OWI2YzhlYzUyNTYyZTA1MjkxMmJiM2RjZjM3NmI1MzYwNDcxZDc0NDMzNDJlMDUyNDVmYWIzMjIzNDZjZmQ2NmJmNjFlY2E0YzVkM2I0NThjYTU0ZjdkZWIxODc2MjkxMDY5MGU1YTQwMGY3NmVmYzAzNzY4NmZhYjc1MDY2NTNiMmJhNzQ1NGE0OGU3ZTFiZDg5NWE3ZDVkOTk2ZTQxNmExMjY0ZjNlMTA0N2Y5ZGM2ZDA1NmI5ZDM3YzU4YjkwYTA0Zjc0ZmI3MTU5ZTM4Nzk1ZDBkOTRlZDRlMGM4YTc4ZjI2MjA4YTQ1YjY1MTE4YWRjNWY0YWM2NDhmNWQ4YjI2YzI0OTFiNmJkZTE3N2U3ZWJlMzc0ZDBkMTMxODEzZGJkY2QwMWZjYzc1NzQ2ODlhNWI1ZGYyZTE1NWZkNDc4N2MxODRjYzA1Mjg4ZWU0OTdhMTFkMmU4MjEwMjhjZDBlZjBiZGI0MDUxNThmYjdmODc3Yjk0OTBlZTVkNjViZjUyMzhjYWY4YjZiMjk4YzIyY2M2ZDEzYTRmNzYzNzRhYmExYjVkZTJiZTIwYTNjODI3M2I4MzZiZjc0ODJmMTkxZDU2NWQ3ODJiZWZlYTQ5OGU5MTY1ZDZkZTY1"; // Replace with actual token
  String projectId = "p-JGqY6xjCAK"; // Replace with actual project ID

  @override
  void initState() {
    super.initState();
    _addMemberField();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title:
            const Text("Edit Project", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff4129B7),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload Logo Section
              UploadSection(
                title: "Upload Logo",
                onButtonPressed: () => _pickLogo(),
                onSavePressed: () => _saveLogo(),
                file: logoFile,
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),

              // Text Fields Section
              CustomEditTextfiled(
                  label: "Project Name", controller: projectNameController),
              CustomEditTextfiled(
                  label: "Bootcamp Name", controller: bootcampNameController),
              CustomEditTextfiled(
                  label: "Type", controller: projectTypeController),
              CustomEditTextfiled(
                  label: "Start Date",
                  controller: startDateController,
                  isDate: true),
              CustomEditTextfiled(
                  label: "End Date",
                  controller: endDateController,
                  isDate: true),
              CustomEditTextfiled(
                  label: "Presentation Date",
                  controller: presentationDateController,
                  isDate: true),
              CustomEditTextfiled(
                  label: "Project Description",
                  controller: projectDescriptionController,
                  isMultiline: true),

              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  height: 30,
                  width: 170,
                  child: ElevatedButton(
                    onPressed: _saveBasicInfo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4129B7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Save Basic Info",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),

              // Upload Presentation Section
              UploadSection(
                title: "Upload Presentation",
                onButtonPressed: () => _pickPresentation(),
                onSavePressed: () => _savePresentation(),
                file: presentationFile,
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),

              // Upload Images Section
              Column(
                children: [
                  const Text("Upload Images",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xff4129B7))),
                  const SizedBox(height: 10),
                  DottedBorder(
                    color: const Color(0xffD9D9D9),
                    strokeWidth: 1,
                    child: Container(
                        height: 100,
                        width: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3)),
                        child: imageFiles.isEmpty
                            ? IconButton(
                                onPressed: _pickImages,
                                icon: const Icon(Icons.file_present,
                                    color: Colors.black))
                            : const Icon(Icons.check_box)),
                  ),
                  const SizedBox(height: 10),
                  if (imageFiles.isNotEmpty)
                    Wrap(
                      children: [
                        ...[
                          for (var imageFile in imageFiles)
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8, right: 8),
                              child: Image.file(
                                imageFile,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ],
                    ),
                  const SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      height: 30,
                      width: 170,
                      child: ElevatedButton(
                        onPressed: _saveImages,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff4129B7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Save Images",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),

              // Links Section
              const Text("Links:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4129B7),
                      fontSize: 18)),
              CustomEditTextfiled(
                  label: "GitHub", controller: githubController),
              CustomEditTextfiled(label: "Figma", controller: figmaController),
              CustomEditTextfiled(label: "Video", controller: videoController),
              CustomEditTextfiled(
                  label: "Pinterest", controller: pinterestController),
              CustomEditTextfiled(
                  label: "Play Store", controller: playStoreController),
              CustomEditTextfiled(
                  label: "App Store", controller: appleStoreController),
              CustomEditTextfiled(label: "APK", controller: apkController),
              CustomEditTextfiled(
                  label: "Web Link", controller: webLinkController),

              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  height: 30,
                  width: 170,
                  child: ElevatedButton(
                    onPressed: _saveLinks,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4129B7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Save Links",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),

              // Members Section
              const Text("Members",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xff4129B7))),
              _buildMemberFields(),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  height: 30,
                  width: 170,
                  child: ElevatedButton(
                    onPressed: _saveMembers,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4129B7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Save Members",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods
  Future<void> _pickLogo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        logoFile = File(image.path);
      });
    }
  }

  Future<void> _saveLogo() async {
    if (logoFile != null) {
      try {
        Uint8List data = await logoFile!.readAsBytes();
        await api.editProjectLogo(
            projectId: projectId, logo: data.toList(), token: token);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logo updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update logo.')),
        );
      }
    }
  }

  Future<void> _pickPresentation() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        presentationFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _savePresentation() async {
    if (presentationFile != null) {
      try {
        Uint8List data = await presentationFile!.readAsBytes();
        await api.editPresentation(
            projectId: projectId,
            presentationFile: data.toList(),
            token: token);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Presentation updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update presentation.')),
        );
      }
    }
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        imageFiles = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _saveImages() async {
    if (imageFiles.isNotEmpty) {
      try {
        List<List<int>> imagesData = await Future.wait(
          imageFiles.map((file) async => (await file.readAsBytes()).toList()),
        );
        await api.editProjectImages(
            projectId: projectId, images: imagesData, token: token);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Images updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update images.')),
        );
      }
    }
  }

  void _saveBasicInfo() async {
    try {
      await api.editProjectInfo(
        projectId,
        projectName: projectNameController.text,
        bootcampName: bootcampNameController.text,
        type: projectTypeController.text,
        startDate: startDateController.text,
        endDate: endDateController.text,
        presentationDate: presentationDateController.text,
        projectDescription: projectDescriptionController.text,
        token: token,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Basic information updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update basic information.')),
      );
    }
  }

  void _saveLinks() async {
    try {
      List<ProjectLink> links = [
        ProjectLink(type: "github", url: githubController.text),
        ProjectLink(type: "figma", url: figmaController.text),
        ProjectLink(type: "video", url: videoController.text),
        ProjectLink(type: "pinterest", url: pinterestController.text),
        ProjectLink(type: "playstore", url: playStoreController.text),
        ProjectLink(type: "applestore", url: appleStoreController.text),
        ProjectLink(type: "apk", url: apkController.text),
        ProjectLink(type: "weblink", url: webLinkController.text),
      ];
      await api.editProjectLinks(
          projectId: projectId, links: links, token: token);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Links updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update links.')),
      );
    }
  }

  void _addMemberField() {
    setState(() {
      members.add(MemberModel(position: '', userId: ''));
      positionControllers.add(TextEditingController());
      userIdControllers.add(TextEditingController());
    });
  }

  Widget _buildMemberFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < members.length; i++)
          Row(
            children: [
              Expanded(
                child: CustomEditTextfiled(
                    label: "Position", controller: positionControllers[i]),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomEditTextfiled(
                    label: "User ID", controller: userIdControllers[i]),
              ),
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.red),
                onPressed: () {
                  setState(() {
                    if (members.length > 1) {
                      members.removeAt(i);
                      positionControllers.removeAt(i);
                      userIdControllers.removeAt(i);
                    }
                  });
                },
              ),
            ],
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
              onPressed: _addMemberField,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4129B7),
                  shape: const CircleBorder()),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        ),
      ],
    );
  }

  void _saveMembers() async {
    try {
      List<MemberModel> memberList = [];
      for (int i = 0; i < members.length; i++) {
        String position = positionControllers[i].text;
        String userId = userIdControllers[i].text;

        // Validate inputs
        if (position.isEmpty || userId.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill all fields.')),
          );
          return;
        }

        memberList.add(MemberModel(
          position: position,
          userId: userId,
        ));
      }

      await api.editProjectMembers(
        projectId: projectId,
        members: memberList,
        token: token,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Members updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update members.')),
      );
    }
  }
}
