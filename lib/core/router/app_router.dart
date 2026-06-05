import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import './main_shell_scaffold.dart';
import '../../features/hostel/presentation/room_detail_screen.dart';
import '../../features/inspection/presentation/inspection_form_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/hostel/presentation/hostel_list_screen.dart';
import '../../features/hostel/presentation/room_list_screen.dart';
import '../../features/inspection/presentation/inspection_history_screen.dart';
import '../../features/hostel/presentation/add_room_screen.dart';
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  //Add redirect logic here for Firebase Auth checking
  
  routes: [
    // --- AUTH ROUTE ---
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // --- MAIN APP SHELL (BOTTOM NAV) ---
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellScaffold(navigationShell: navigationShell);
      },
      branches: [
        // BRANCH 1: Hostels & Rooms
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/hostels',
              builder: (context, state) => const HostelListScreen(),
              routes: [
                GoRoute(
                  path: ':hostelId/rooms',
                  builder: (context, state) {
                    final hostelId = state.pathParameters['hostelId'];
                    return RoomListScreen(hostelId: state.pathParameters['hostelId']!);
                  },
                  routes: [
                    GoRoute(
                      path: 'add',
                      parentNavigatorKey: _rootNavigatorKey, // Make it full screen
                      builder: (context, state) {
                        final hostelId = state.pathParameters['hostelId']!;
                        return AddRoomScreen(hostelId: hostelId);
                      },
                    ),
                    GoRoute(
                      path: ':roomId',
                      builder: (context, state) {
                        final roomId = state.pathParameters['roomId']!;
                        return RoomDetailScreen(roomId: roomId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // BRANCH 2: Inspections
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inspections',
              builder: (context, state) => const InspectionHistoryScreen(),
              routes: [
                GoRoute(
                  path: 'new/:roomId',
                  parentNavigatorKey: _rootNavigatorKey, 
                  builder: (context, state) {
                    final roomId = state.pathParameters['roomId']!;
                    return InspectionFormScreen(roomId: roomId);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
