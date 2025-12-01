// lib/controllers/team_mode_controller/team_lobby_controller.dart

import 'dart:async';
import 'dart:developer';
import 'package:game_app/data/repositories/team_repo.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';
import '../../../generated/models/responses/team_mode/team_lobby_response.dart';

import '../../../data/repositories/strategy_repository.dart';
import '../../../data/repositories/storage_repository.dart';
import '../../../services/notification_service.dart';
import '../../../utils/snackbar_helper.dart';
import 'create_team_controller.dart';

class TeamLobbyController extends GetxController {
  var players = <String>[].obs;
  var isLoading = false.obs;
  var isInvitingMember = false.obs;
  var teamData = Rxn<TeamLobbyResponse>();
  var errorMessage = ''.obs;

  var memberScores = <Map<String, dynamic>>[].obs;
  final RxBool isHost = false.obs;

  /// Explicit team id that can be passed via navigation arguments.
  /// This avoids relying only on `CreateTeamController.createdTeamId`,
  /// which might not yet be initialized for members who join via code.
  int? _explicitTeamId;

  final TeamRepository _teamRepository = Get.find<TeamRepository>();
  final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();
  final StorageRepository _storageRepository = Get.find<StorageRepository>();
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();

  Timer? _refreshTimer;
  bool _hasNavigatedToAssignRoles = false;

  @override
  void onInit() {
    super.onInit();
    // Clear initial data to ensure the count starts correctly
    players.clear();
    memberScores.clear();

    // Try to hydrate state from navigation arguments first
    _initializeFromArguments();

    // Always load latest data from API as the source of truth
    _loadLobbyData();
  }

  /// Read initial team data (team id + members) from navigation arguments.
  /// This is especially important for users who join a team via invite code,
  /// so their lobby immediately reflects the correct team info.
  void _initializeFromArguments() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      // Team ID passed from navigation
      final argTeamId = args['teamId'];
      if (argTeamId is int) {
        _explicitTeamId = argTeamId;
      }

      // Full lobby response passed from navigation (when available)
      final argTeamData = args['teamData'];
      if (argTeamData is TeamLobbyResponse) {
        teamData.value = argTeamData;

        final members = argTeamData.members ?? [];
        if (members.isNotEmpty) {
          players.assignAll(
            members.map((m) => m.user?.name ?? 'Unknown').toList(),
          );
        }

        final currentUserId = _storageRepository.getUser()?.id;
        isHost.value = members.any(
              (member) => member.role == 'HOST' && member.user?.id == currentUserId,
        );
      }
    }
  }

  /// Resolve the current team id with the following precedence:
  /// 1) Explicit id passed via navigation arguments
  /// 2) Id already present in `teamData`
  /// 3) Id stored in `CreateTeamController.createdTeamId`
  int? _resolveTeamId() {
    if (_explicitTeamId != null) return _explicitTeamId;
    if (teamData.value?.id != null) return teamData.value!.id;

    if (Get.isRegistered<CreateTeamController>()) {
      final createTeamController = Get.find<CreateTeamController>();
      return createTeamController.createdTeamId.value;
    }
    return null;
  }

  @override
  void onReady() {
    super.onReady();
    // If team data is empty or missing token/members, fetch immediately
    if (teamData.value == null ||
        teamData.value?.token == null ||
        teamData.value?.members == null ||
        teamData.value?.members!.isEmpty == true) {
      _loadLobbyData();
    }
    _startAutoRefresh();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      _refreshLobbySilently();
    });
  }

  void _refreshLobbySilently() {
    fetchTeamDetails(withLoader: false).then((_) async {
      await fetchMemberScores();
      _maybeNavigateMemberToAssignRoles();
    });
  }

  Future<void> _loadLobbyData() async {
    await fetchTeamDetails();
    await fetchMemberScores();
  }

  // ------------------------------------------------
  // 1. GET TEAM DETAILS (API INTEGRATION)
  // ------------------------------------------------
  Future<void> fetchTeamDetails({bool withLoader = true}) async {
    try {
      if (withLoader) {
        isLoading.value = true;
      }
      errorMessage.value = '';

      final teamId = _resolveTeamId();

      if (teamId == null) {
        errorMessage.value = 'No team ID found. Please create a team first.';
        SnackbarHelper.error('No team ID found.');
        return;
      }

      final teamLobbyResponse = await _teamRepository.getTeamDetails(teamId);
      teamData.value = teamLobbyResponse;

      log('📋 Team Details Fetched:');
      log('  - Team ID: ${teamLobbyResponse.id}');
      log('  - Team Title: ${teamLobbyResponse.title}');
      log('  - Team Token: ${teamLobbyResponse.token ?? "NULL"}');
      log('  - Members Count: ${teamLobbyResponse.members?.length ?? 0}');

      if (teamLobbyResponse.members != null && teamLobbyResponse.members!.isNotEmpty) {
        players.assignAll(teamLobbyResponse.members!.map((member) => member.user?.name ?? 'Unknown').toList());
        log('✅ Lobby: Players list populated with ${players.length} members: ${players.join(", ")}');
      } else {
        players.clear();
        log('⚠️ Lobby: Players list cleared (0 members). Members data: ${teamLobbyResponse.members}');
      }

      final currentUserId = _storageRepository.getUser()?.id;
      final memberList = teamLobbyResponse.members ?? [];
      isHost.value = memberList.any(
            (member) => member.role == 'HOST' && member.user?.id == currentUserId,
      );

    } catch (e) {
      errorMessage.value = 'Failed to load team details: ${e.toString()}';
      SnackbarHelper.error('Failed to load team details.');
      print('Error fetching team details: $e');
    } finally {
      if (withLoader) {
        isLoading.value = false;
      }
    }
  }

  // ------------------------------------------------
  // 2. FETCH MEMBER SCORES (API INTEGRATION)
  // ------------------------------------------------
  Future<void> fetchMemberScores() async {
    final teamId = _resolveTeamId();

    if (teamId == null || teamData.value?.members == null) {
      log('Scores: Skipping fetch. Team data or members not available.');
      return;
    }

    try {
      final List<Map<String, dynamic>> scores = [];

      for (final member in teamData.value!.members!) {
        try {
          final userScoreData = await _strategyRepository.getUserFinalScoreInTeam(teamId, member.userId!);

          scores.add({
            'userId': member.userId,
            'name': member.user?.name ?? 'Unknown',
            'role': member.role ?? 'Player',
            'level': (userScoreData['level'] as num? ?? 1).toInt(),
            'points': (userScoreData['points'] as num? ?? 0).toInt(),
            'score': (userScoreData['score'] as num? ?? 0).toInt(),
            'badge': userScoreData['badge']?.toString() ?? '',
            'trophy': userScoreData['trophy']?.toString() ?? '',
            'title': userScoreData['title']?.toString() ?? '',
          });
        } catch (e) {
          scores.add({
            'userId': member.userId,
            'name': member.user?.name ?? 'Unknown',
            'role': member.role ?? 'Player',
            'level': 1,
            'points': 0,
            'score': 0,
            'badge': '',
            'trophy': '',
            'title': '',
          });
        }
      }

      memberScores.assignAll(scores);

    } catch (e) {
      print('Error fetching member scores: $e');
    }
  }

  Future<void> beginMission() async {
    if (!isHost.value) {
      SnackbarHelper.warning('Only the host can start the mission.');
      return;
    }
    if (players.length < 2) {
      SnackbarHelper.warning('Need at least 2 members to start.');
      return;
    }

    // Ensure we have the latest team data (including newly joined members)
    await fetchTeamDetails(withLoader: false);

    await _sendTeamGameStartedNotification();

    Get.toNamed(AppRoutes.assignRoleScreen);
  }

  /// Notify all team members (including newly joined ones) that the game started.
  /// Uses the resolved team id and refreshes members list if needed.
  Future<void> _sendTeamGameStartedNotification() async {
    final teamId = _resolveTeamId();

    if (teamId == null) {
      log('⚠️ Cannot send game started notification: teamId is null');
      return;
    }

    // If members list is missing or empty, try to refresh once more
    if (teamData.value?.members == null || teamData.value!.members!.isEmpty) {
      await fetchTeamDetails(withLoader: false);
    }

    final members = teamData.value?.members ?? [];
    if (members.isEmpty) {
      log('⚠️ Cannot send game started notification: members list is empty');
      return;
    }

    final teamMemberUserIds = members
        .map((member) => member.userId)
        .whereType<String>()
        .toList();

    if (teamMemberUserIds.isEmpty) {
      log('⚠️ Cannot send game started notification: no valid member userIds');
      return;
    }

    await _notificationService.sendTeamGameStarted(
      teamId: teamId,
      teamMemberUserIds: teamMemberUserIds,
    );
  }

  /// Fallback (non-FCM) mechanism:
  /// For non-host players, if we detect that any non-host roles have been
  /// assigned while they are in the lobby, automatically navigate them to
  /// the Assign Roles screen so they stay in sync with the host.
  void _maybeNavigateMemberToAssignRoles() {
    // Only applies to non-host players
    if (isHost.value) return;

    // Only trigger from lobby, and only once
    if (_hasNavigatedToAssignRoles) return;
    if (Get.currentRoute != AppRoutes.teamLobby) return;

    final members = teamData.value?.members ?? [];
    if (members.isEmpty) return;

    // Consider game "in roles phase" when any member has a specific role set
    final hasAssignedRoles = members.any(
          (m) => m.role != null && m.role!.isNotEmpty && m.role != 'HOST',
    );

    if (hasAssignedRoles) {
      _hasNavigatedToAssignRoles = true;
      Get.toNamed(AppRoutes.assignRoleScreen);
    }
  }

  Future<String?> inviteMembers() async {
    final teamToken = teamData.value?.token;

    if (teamToken == null) {
      SnackbarHelper.error("Error: Team Code missing.");
      return null;
    }

    try {
      isInvitingMember.value = true;

      try {
        await _teamRepository.sendWsInvite(teamToken);
        print('WebSocket invite sent successfully');
        _sendTeamInvitationNotification(teamToken);

      } catch (wsError) {
        print('WebSocket invite failed: $wsError');
        SnackbarHelper.warning("Team code generated but invite notification failed. You can still share the code manually.");
      }

      SnackbarHelper.success("Invite sent! Share the team code.");

      return teamToken;

    } catch (e) {
      SnackbarHelper.error("Failed to send invite: ${e.toString()}");
      print('Error sending invite: $e');
      return null;
    } finally {
      isInvitingMember.value = false;
    }
  }

  void _sendTeamInvitationNotification(String teamToken) {
    final createTeamController = Get.find<CreateTeamController>();
    final teamId = createTeamController.createdTeamId.value;
    final hostName = _storageRepository.getUser()?.name ?? 'Team Host';

    if (teamId != null) {
      _notificationService.sendTeamInvitation(
        hostName: hostName,
        recipientUserId: 'recipient_user_id',
        teamId: teamId,
        autoJoin: false,
      );
    }
  }
}
// import 'dart:developer';
// import 'package:game_app/data/repositories/team_repo.dart';
// import 'package:game_app/presentation/routes/app_routes.dart';
// import 'package:get/get.dart';
// import '../../../generated/models/responses/team_mode/team_lobby_response.dart';
//
// import '../../../data/repositories/strategy_repository.dart';
// import '../../../data/repositories/storage_repository.dart';
// import '../../../services/notification_service.dart';
// import '../../../utils/snackbar_helper.dart';
// import 'create_team_controller.dart';
//
// class TeamLobbyController extends GetxController {
//   var players = <String>[].obs;
//   var isLoading = false.obs;
//   var isInvitingMember = false.obs;
//   var teamData = Rxn<TeamLobbyResponse>();
//   var errorMessage = ''.obs;
//
//   var memberScores = <Map<String, dynamic>>[].obs;
//
//   final TeamRepository _teamRepository = Get.find<TeamRepository>();
//   final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();
//   final StorageRepository _storageRepository = Get.find<StorageRepository>();
//   final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Clear initial data to ensure the count starts correctly
//     players.clear();
//     memberScores.clear();
//     _loadLobbyData();
//   }
//
//   Future<void> _loadLobbyData() async {
//     await fetchTeamDetails();
//     fetchMemberScores();
//   }
//
//   // ------------------------------------------------
//   // 1. GET TEAM DETAILS (API INTEGRATION)
//   // ------------------------------------------------
//   Future<void> fetchTeamDetails() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       final createTeamController = Get.find<CreateTeamController>();
//       final teamId = createTeamController.createdTeamId.value;
//
//       if (teamId == null) {
//         errorMessage.value = 'No team ID found. Please create a team first.';
//         SnackbarHelper.error('No team ID found.');
//         return;
//       }
//
//       final teamLobbyResponse = await _teamRepository.getTeamDetails(teamId);
//       teamData.value = teamLobbyResponse;
//
//       if (teamLobbyResponse.members != null) {
//         players.assignAll(teamLobbyResponse.members!.map((member) => member.user?.name ?? 'Unknown').toList());
//         log('Lobby: Players list populated with ${players.length} members.');
//       } else {
//         players.clear();
//         log('Lobby: Players list cleared (0 members).');
//       }
//
//     } catch (e) {
//       errorMessage.value = 'Failed to load team details: ${e.toString()}';
//       SnackbarHelper.error('Failed to load team details.');
//       print('Error fetching team details: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ------------------------------------------------
//   // 2. FETCH MEMBER SCORES (API INTEGRATION)
//   // ------------------------------------------------
//   Future<void> fetchMemberScores() async {
//     final teamId = teamData.value?.id;
//
//     if (teamId == null || teamData.value?.members == null) {
//       log('Scores: Skipping fetch. Team data or members not available.');
//       return;
//     }
//
//     try {
//       final List<Map<String, dynamic>> scores = [];
//
//       for (final member in teamData.value!.members!) {
//         try {
//           final userScoreData = await _strategyRepository.getUserFinalScoreInTeam(teamId, member.userId!);
//
//           scores.add({
//             'userId': member.userId,
//             'name': member.user?.name ?? 'Unknown',
//             'role': member.role ?? 'Player',
//             'level': (userScoreData['level'] as num? ?? 1).toInt(),
//             'points': (userScoreData['points'] as num? ?? 0).toInt(),
//             'score': (userScoreData['score'] as num? ?? 0).toInt(),
//             'badge': userScoreData['badge']?.toString() ?? '',
//             'trophy': userScoreData['trophy']?.toString() ?? '',
//             'title': userScoreData['title']?.toString() ?? '',
//           });
//         } catch (e) {
//           scores.add({
//             'userId': member.userId,
//             'name': member.user?.name ?? 'Unknown',
//             'role': member.role ?? 'Player',
//             'level': 1,
//             'points': 0,
//             'score': 0,
//             'badge': '',
//             'trophy': '',
//             'title': '',
//           });
//         }
//       }
//
//       memberScores.assignAll(scores);
//
//     } catch (e) {
//       print('Error fetching member scores: $e');
//     }
//   }
//
//   void beginMission() {
//     _sendTeamGameStartedNotification();
//
//     Get.toNamed(AppRoutes.assignRoleScreen);
//   }
//
//   void _sendTeamGameStartedNotification() {
//     final createTeamController = Get.find<CreateTeamController>();
//     final teamId = createTeamController.createdTeamId.value;
//
//     if (teamId != null && teamData.value?.members != null) {
//       final teamMemberUserIds = teamData.value!.members!
//           .map((member) => member.userId!)
//           .toList();
//
//       _notificationService.sendTeamGameStarted(
//         teamId: teamId,
//         teamMemberUserIds: teamMemberUserIds,
//       );
//     }
//   }
//
//   Future<String?> inviteMembers() async {
//     final teamToken = teamData.value?.token;
//
//     if (teamToken == null) {
//       SnackbarHelper.error("Error: Team Code missing.");
//       return null;
//     }
//
//     try {
//       isInvitingMember.value = true;
//
//       try {
//         await _teamRepository.sendWsInvite(teamToken);
//         print('WebSocket invite sent successfully');
//         _sendTeamInvitationNotification(teamToken);
//
//       } catch (wsError) {
//         print('WebSocket invite failed: $wsError');
//         SnackbarHelper.warning("Team code generated but invite notification failed. You can still share the code manually.");
//       }
//
//       SnackbarHelper.success("Invite sent! Share the team code.");
//
//       return teamToken;
//
//     } catch (e) {
//       SnackbarHelper.error("Failed to send invite: ${e.toString()}");
//       print('Error sending invite: $e');
//       return null;
//     } finally {
//       isInvitingMember.value = false;
//     }
//   }
//
//   void _sendTeamInvitationNotification(String teamToken) {
//     final createTeamController = Get.find<CreateTeamController>();
//     final teamId = createTeamController.createdTeamId.value;
//     final hostName = _storageRepository.getUser()?.name ?? 'Team Host';
//
//     if (teamId != null) {
//       _notificationService.sendTeamInvitation(
//         hostName: hostName,
//         recipientUserId: 'recipient_user_id',
//         teamId: teamId,
//         autoJoin: false,
//       );
//     }
//   }
// }