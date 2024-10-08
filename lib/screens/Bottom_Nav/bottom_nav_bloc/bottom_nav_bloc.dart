import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_management_app/screens/Admin/admin_home_screen.dart';
import 'package:project_management_app/screens/All_projects/all_projects_screen.dart';
import 'package:project_management_app/screens/Home/home_screen.dart';
import 'package:project_management_app/screens/Profile/profile_screen.dart';
import 'package:project_management_app/screens/QR_scanner/qr_scanner_screen.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  List<Widget> views = [
    const HomeScreen(),
    const AllProjectsScreen(),
    const AdminHomeScreen(),
    const ProfileScreen(),
    const QrScannerScreen()
  ];

  int currentIndex = 0;

  BottomNavBloc() : super(BottomNavInitial()) {
    on<ChangeEvent>(changeMethod);
    on<HideBottomNavEvent>((event, emit) => emit(HideBottomNavState()));
    on<ShowBottomNavEvent>((event, emit) => emit(ShowBottomNavState()));
  }

  FutureOr<void> changeMethod(ChangeEvent event, Emitter<BottomNavState> emit) {
    currentIndex = event.index;
    emit(SuccessChangeViewState(currentIndex));
  }
}
