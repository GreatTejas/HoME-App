import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/hostel/presentation/room_detail_screen.dart';
import '../../features/hostel/presentation/room_list_screen.dart';
import '../../features/inspection/presentation/inspection_form_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(
      path: '/hostels/:hostelId/rooms',
      builder: (_, state) => RoomListScreen(hostelId: state.pathParameters['hostelId']!),
      routes: [
        GoRoute(path: ':roomId', builder: (_, state) => RoomDetailScreen(roomId: state.pathParameters['roomId']!)),
      ],
    ),
    GoRoute(path: '/inspections/new/:roomId', builder: (_, state) => InspectionFormScreen(roomId: state.pathParameters['roomId']!)),
  ],
);
