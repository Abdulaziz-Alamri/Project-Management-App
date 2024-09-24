import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:project_management_app/data_layer/data_layer.dart';
import 'package:project_management_app/models/member_model.dart';
import 'package:project_management_app/models/profile_model.dart';
import 'package:project_management_app/models/project_model.dart';
import 'package:project_management_app/networking/api_networking.dart';
import 'package:project_management_app/screens/Edit_Project/edit_project.dart';
import 'package:project_management_app/screens/Project/custom_logo.dart';
import 'package:project_management_app/screens/Project/custom_project_info.dart';
import 'package:project_management_app/screens/Project/custom_project_member.dart';
import 'package:project_management_app/services/launch_url.dart';
import 'package:project_management_app/services/setup.dart';
import 'package:project_management_app/theme/appcolors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final ProjectModel project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  String? selectedLink;
  List<String> links = [
    'GitHub',
    'Figma',
    'Video',
    'Pinterest Link',
    'PlayStore Link',
    'AppleStore Link',
    'Web Link',
    'Apk'
  ];

  List<MemberModel> members = [];
  Profile? profile;
  bool isEditAuthrized = false;

  @override
  void initState() {
    _checkEditAuthorization();
    super.initState();
    // logger.i(_checkEditAuthorization());
  }

  final logger = Logger();

  Future<Profile> getProfile() async {
    return await ApiNetworking()
        .getProfile(locator.get<DataLayer>().auth!.token);
  }

  Future<void> _checkEditAuthorization() async {
    profile = await getProfile();
    if (!mounted) return; // تأكد من أن الويدجت ما زالت موجودة

    // logger.i('User Role: ${profile!.role}'); // طباعة الـ role

    setState(() {
      isEditAuthrized = profile!.role.toLowerCase() == 'admin' ||
          profile!.role.toLowerCase() == 'supervisor';
      // logger.i('isEditAuthrized: $isEditAuthrized');

      log('${widget.project.toJson()}');

      for (var member in widget.project.membersProject!) {
        if (member.userId == profile!.id) {
          isEditAuthrized = true;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.blueDark,
        actions: [
          if (isEditAuthrized)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProjectScreen(
                      project: widget.project,
                      userId: profile!.id,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
        ],
      ),
      body: ListView(
        padding:
            const EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 30),
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' Project Details ..',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: Color(0xff57E3D8),
                ),
              ),
              if (widget.project.logoUrl != null &&
                  widget.project.logoUrl != 'null')
                CustomLogo(logoUrl: widget.project.logoUrl!, isLogo: true)
              else
                CustomLogo(logoUrl: widget.project.logoUrl!),
              Image.asset('assets/Group 10 (1).png')
            ],
          ),
          const SizedBox(height: 20),

          // project name
          CustomProjectInfo(
            label: 'Project name :',
            content: widget.project.projectName.toString(),
          ),
          const SizedBox(height: 20),

          // Bootcamp name
          CustomProjectInfo(
            label: 'BootCamp  :',
            content: widget.project.bootcampName.toString(),
          ),
          const SizedBox(height: 20),

          // Description
          CustomProjectInfo(
            label: 'Description :',
            content: widget.project.projectDescription.toString(),
          ),
          const SizedBox(height: 20),

          // Start Date
          CustomProjectInfo(
            label: 'Start Date  :',
            content: widget.project.startDate.toString(),
          ),
          const SizedBox(height: 20),

          // End Date
          CustomProjectInfo(
            label: 'End Date  :',
            content: widget.project.endDate.toString(),
          ),
          const SizedBox(height: 20),

          // Editing End Date
          CustomProjectInfo(
            label: 'Editing End Date :',
            content: widget.project.timeEndEdit.toString(),
          ),
          const SizedBox(height: 20),

          // Presentation Date
          CustomProjectInfo(
            label: 'Presentaion Date :',
            content: widget.project.presentationDate.toString(),
          ),
          const SizedBox(height: 20),

          // Presentation Url
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Presentaion Url :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xff4129B7),
                ),
              ),
              IconButton(
                onPressed: () {
                  launchLink(widget.project.presentationUrl.toString());
                },
                icon: const Icon(Icons.link),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 170,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xff4129B7),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: DropdownButton<String>(
                  value: selectedLink,
                  isExpanded: true,
                  hint: const Text(
                    "Links",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  iconSize: 24,
                  underline: Container(),
                  dropdownColor: const Color(0xff4129B7),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLink = newValue;
                    });
                  },
                  items: links.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 10),
              QrImageView(
                data: widget.project.projectId!,
                version: QrVersions.auto,
                size: 100,
                gapless: false,
              ),
            ],
          ),
          if (selectedLink != null)
            if (widget.project.linksProject!.isNotEmpty)
              InkWell(
                onTap: () {
                  launchLink(widget
                      .project
                      .linksProject![links.indexOf(selectedLink!)]
                      .url as String);
                },
                child: Text(
                  widget.project.linksProject![links.indexOf(selectedLink!)].url
                      as String,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue),
                ),
              )
            else
              const Text('No Link Added'),
          const SizedBox(height: 30),

          // Grid to display images
          if (widget.project.imagesProject!.isNotEmpty)
            const Text(
              ' Project Images ..',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xff57E3D8)),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: widget.project.imagesProject!.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.project.imagesProject![index].url,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),

          // Display Members
          if (widget.project.membersProject!.isNotEmpty)
            const Text(
              ' Project Members ..',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xff57E3D8)),
            ),

          Padding(
            padding: const EdgeInsets.only(top: 70, bottom: 16),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: widget.project.membersProject!.length,
              itemBuilder: (context, index) {
                MemberModel member = MemberModel.fromJson(
                    widget.project.membersProject![index].toJson());
                return CustomProjectMember(member: member);
              },
            ),
          ),
        ],
      ),
    );
  }
}
