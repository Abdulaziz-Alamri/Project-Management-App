import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';
import 'package:project_management_app/data_layer/data_layer.dart';
import 'package:project_management_app/models/member_model.dart';
import 'package:project_management_app/models/project_model.dart';
import 'package:project_management_app/networking/api_networking.dart';
import 'package:project_management_app/screens/Edit_Project/custom_edit_textfiled.dart';
import 'package:project_management_app/screens/Edit_Project/edit_project_bloc/edit_project_bloc.dart';
import 'package:project_management_app/screens/Edit_Project/upload_section.dart';
import 'package:project_management_app/services/setup.dart';

class EditProjectScreen extends StatefulWidget {
  final ProjectModel project;
  final String userId;
  const EditProjectScreen(
      {super.key, required this.project, required this.userId});

  @override
  _EditProjectScreenState createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final ApiNetworking api = ApiNetworking();

  // Edit End Time Controller
  final TextEditingController editEndTimeController = TextEditingController();

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

  // Link Controllers
  final TextEditingController githubController = TextEditingController();
  final TextEditingController figmaController = TextEditingController();
  final TextEditingController videoController = TextEditingController();
  final TextEditingController pinterestController = TextEditingController();
  final TextEditingController playStoreController = TextEditingController();
  final TextEditingController appleStoreController = TextEditingController();
  final TextEditingController apkController = TextEditingController();
  final TextEditingController webLinkController = TextEditingController();

  // Members Controllers
  List<MemberModel> members = [];
  List<TextEditingController> positionControllers = [];
  List<TextEditingController> userIdControllers = [];

  bool? isEditable;
  bool? isPublic;

  File? logoFile;
  File? presentationFile;
  List<File> imageFiles = [];

  late String token;
  late String? projectId;

  @override
  void initState() {
    super.initState();
    token = locator.get<DataLayer>().auth!.token;
    projectId = widget.project.projectId;

    projectNameController.text = widget.project.projectName!.toString();
    bootcampNameController.text = widget.project.bootcampName!.toString();
    projectTypeController.text = widget.project.type!.toString();
    startDateController.text = widget.project.startDate == null
        ? DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(widget.project.startDate!))
        : '';
    endDateController.text = widget.project.endDate == null
        ? DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(widget.project.endDate!))
        : '';
    presentationDateController.text = widget.project.presentationDate == null
        ? DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(widget.project.presentationDate!))
        : '';
    projectDescriptionController.text =
        widget.project.projectDescription!.toString();

    editEndTimeController.text = DateFormat('dd/MM/yyyy')
        .format(DateTime.parse(widget.project.timeEndEdit!));
    isEditable = widget.project.allowEdit!;
    isPublic = widget.project.isPublic!;
    _addMemberField(isFirstTime: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProjectBloc(
          api: api,
          token: locator.get<DataLayer>().auth!.token,
          projectId: widget.project.projectId!),
      child: Builder(builder: (context) {
        return BlocListener<EditProjectBloc, EditProjectState>(
          listener: (context, state) {
            if (state is ProjectStatusUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Status updated successfully!')));
            }
            if (state is LogoUploaded) {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logo uploaded successfully!')));
            }
            if (state is BasicInfoSaved) {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Info updated successfully!')));
            }
            if (state is LinksSaved) {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Links updated successfully!')));
            }
            if (state is PresentationUploaded) {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Presentation uploaded successfully!')));
            }
            if (state is ImagesUploaded) {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Images uploaded successfully!')));
            }
            if (state is MembersSaved) {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Members updated successfully!')));
            }
            if (state is EditProjectFailure) {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed')));
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: const BackButton(color: Colors.white),
              title: const Text("Edit Project",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color(0xff4129B7),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.userId == widget.project.adminId)
                      Column(
                        children: [
                          CustomEditTextfiled(
                              label: "Edit End Time",
                              controller: editEndTimeController),
                          const Text('Editable: '),
                          Switch(
                            value: isEditable!,
                            onChanged: (value) {
                              isEditable = value;
                              setState(() {});
                            },
                          ),
                          const Text('is Public: '),
                          Switch(
                            value: isPublic!,
                            onChanged: (value) {
                              isPublic = value;
                              setState(() {});
                            },
                          ),
                          Center(
                            child: SizedBox(
                              height: 30,
                              width: 170,
                              child: ElevatedButton(
                                onPressed: () async {
                                  context.read<EditProjectBloc>().add(
                                      UpdateProjectStatus(
                                          isEditable: isEditable!,
                                          isPublic: isPublic!,
                                          endTime: editEndTimeController.text));
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
                          const Divider(),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    // Upload Logo Section
                    UploadSection(
                      title: "Upload Logo",
                      onButtonPressed: () => _pickLogo(),
                      onSavePressed: () {
                        context
                            .read<EditProjectBloc>()
                            .add(UploadLogo(logoFile!));
                      },
                      file: logoFile,
                    ),

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),

                    // Text Fields Section
                    CustomEditTextfiled(
                        label: "Project Name",
                        controller: projectNameController),
                    CustomEditTextfiled(
                        label: "Bootcamp Name",
                        controller: bootcampNameController),
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
                          onPressed: () {
                            context.read<EditProjectBloc>().add(SaveBasicInfo(
                                  projectName: projectNameController.text,
                                  bootcampName: bootcampNameController.text,
                                  projectType: projectTypeController.text,
                                  startDate: startDateController.text,
                                  endDate: endDateController.text,
                                  presentationDate:
                                      presentationDateController.text,
                                  projectDescription:
                                      projectDescriptionController.text,
                                ));
                          },
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
                      onSavePressed: () {
                        context
                            .read<EditProjectBloc>()
                            .add(UploadPresentation(presentationFile!));
                      },
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
                                    padding: const EdgeInsets.only(
                                        bottom: 8, right: 8),
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
                              onPressed: () {
                                context
                                    .read<EditProjectBloc>()
                                    .add(UploadImages(imageFiles));
                              },
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
                    CustomEditTextfiled(
                        label: "Figma", controller: figmaController),
                    CustomEditTextfiled(
                        label: "Video", controller: videoController),
                    CustomEditTextfiled(
                        label: "Pinterest", controller: pinterestController),
                    CustomEditTextfiled(
                        label: "Play Store", controller: playStoreController),
                    CustomEditTextfiled(
                        label: "App Store", controller: appleStoreController),
                    CustomEditTextfiled(
                        label: "APK", controller: apkController),
                    CustomEditTextfiled(
                        label: "Web Link", controller: webLinkController),

                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        height: 30,
                        width: 170,
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<EditProjectBloc>()
                                .add(SaveProjectLinks(
                                  githubLink: githubController.text,
                                  figmaLink: figmaController.text,
                                  videoLink: videoController.text,
                                  pinterestLink: pinterestController.text,
                                  playStoreLink: playStoreController.text,
                                  appleStoreLink: appleStoreController.text,
                                  apkLink: apkController.text,
                                  webLink: webLinkController.text,
                                ));
                          },
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
                          onPressed: () {
                            context
                                .read<EditProjectBloc>()
                                .add(SaveMembers(members));
                          },
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
          ),
        );
      }),
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

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
      imageFiles = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  void _addMemberField({bool isFirstTime = false}) {
    setState(() {
      if (isFirstTime) {
        if (widget.project.membersProject!.isNotEmpty) {
          for (var teamMember in widget.project.membersProject!) {
            members.add(MemberModel(
                position: teamMember.position, userId: teamMember.userId));
            positionControllers
                .add(TextEditingController(text: teamMember.position));
            userIdControllers
                .add(TextEditingController(text: teamMember.userId));
          }
        }
      } else {
        members.add(MemberModel(position: '', userId: ''));
        positionControllers.add(TextEditingController());
        userIdControllers.add(TextEditingController());
      }
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

}
