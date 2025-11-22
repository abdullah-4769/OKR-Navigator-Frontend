
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_constants.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/response/api_response.dart';

class ShowChallengersVsViewModel extends GetxController {
  final StorageRepository _storageRepo = Get.find<StorageRepository>();

  var challengers = ApiResponse<List<dynamic>>.notStarted().obs;
  int? challengeId;
  String? currentUserId;

  Timer? _pollingTimer;
  List<dynamic> _lastPlayers = [];
  int _lastPlayerCount = 0;

  @override
  void onInit() {
    super.onInit();
    _initializeAndFetch();
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  /// Initialize and start fetching challenge players
  Future<void> _initializeAndFetch() async {
    try {
      currentUserId = _storageRepo.getUserId();

      final prefs = await SharedPreferences.getInstance();

      // ✅ CRITICAL: Try all possible keys
      String? challengeIdStr = prefs.getString('challengeId');
      if (challengeIdStr == null || challengeIdStr.isEmpty) {
        challengeIdStr = prefs.getString('joinChallengeId');
      }
      if (challengeIdStr == null || challengeIdStr.isEmpty) {
        challengeIdStr = prefs.getString('acceptInviteChallengeId');
      }

      if (challengeIdStr != null && challengeIdStr.isNotEmpty) {
        challengeId = int.tryParse(challengeIdStr);

        if (kDebugMode) {
          print('\n🎮 ========== VS SCREEN INITIALIZED ==========');
          print('✅ Challenge ID: $challengeId');
          print('✅ Current User ID: $currentUserId');
        }

        if (challengeId != null) {
          // Initial fetch
          await fetchChallengePlayers(challengeId!);
          // Start polling for updates
          _startPolling();
        }
      } else {
        if (kDebugMode) print('❌ No challenge ID found in SharedPreferences');
        challengers.value = ApiResponse.error('No challenge ID found');
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error initializing VS screen: $e');
      challengers.value = ApiResponse.error(e.toString());
    }
  }

  /// Start polling for player updates every 2 seconds
  void _startPolling() {
    _pollingTimer?.cancel();
    if (kDebugMode) print('🔄 Starting polling for players...');

    _pollingTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      if (challengeId != null) {
        await _pollForPlayers(challengeId!);
      }
    });
  }

  /// Poll for player changes
  Future<void> _pollForPlayers(int challengeId) async {
    try {
      final url = '${ApiConstants.baseUrl}/challenges/$challengeId/challengeplayer';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = jsonDecode(response.body);

        // ✅ Check if player count changed
        if (data.length != _lastPlayerCount) {
          if (kDebugMode) {
            print('🔄 PLAYER COUNT CHANGED: $_lastPlayerCount → ${data.length}');
          }
          _lastPlayerCount = data.length;
          await _updatePlayersList(data, challengeId);
        } else if (data.isNotEmpty && _hasPlayersChanged(data)) {
          if (kDebugMode) print('🔄 Player data changed');
          await _updatePlayersList(data, challengeId);
        }
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error polling players: $e');
    }
  }

  /// Check if player data has changed
  bool _hasPlayersChanged(List<dynamic> newData) {
    if (_lastPlayers.length != newData.length) return true;

    for (int i = 0; i < newData.length; i++) {
      final newPlayer = newData[i] as Map<String, dynamic>;
      final oldPlayer = _lastPlayers.length > i
          ? _lastPlayers[i] as Map<String, dynamic>?
          : null;

      if (oldPlayer == null) return true;

      final newName = newPlayer['name']?.toString() ?? '';
      final oldName = oldPlayer['name']?.toString() ?? '';

      if (newName != oldName) return true;

      final newUserId = newPlayer['userId']?.toString() ?? '';
      final oldUserId = oldPlayer['userId']?.toString() ?? '';

      if (newUserId != oldUserId) return true;

      final isOldPlaceholder = oldPlayer['isPlaceholder'] == true;
      final isNewPlaceholder = newPlayer['isPlaceholder'] == true;

      if (isOldPlaceholder != isNewPlaceholder) return true;
    }

    return false;
  }

  /// Update players list with enriched data
  Future<void> _updatePlayersList(List<dynamic> data, int challengeId) async {
    final List<Map<String, dynamic>> structuredPlayers = [];

    for (int i = 0; i < data.length; i++) {
      final playerData = data[i] as Map<String, dynamic>;
      final isHost = i == 0;

      structuredPlayers.add(_enrichPlayerData(
        playerData,
        challengeId,
        isHost: isHost,
      ));

      if (kDebugMode) {
        print('✅ ${isHost ? 'HOST' : 'JOINED PLAYER'}: ${playerData['name']}');
      }
    }

    // ✅ Add placeholder if only 1 player
    if (data.length == 1) {
      structuredPlayers.add({
        'id': 'placeholder_${challengeId}',
        'name': 'Waiting...',
        'displayName': 'Waiting...',
        'avatar': 'assets/images/solo_image.png',
        'rank': 0,
        'totalPoints': 0,
        'isPlaceholder': true,
      });
      if (kDebugMode) print('⏳ Placeholder added for 2nd player');
    }

    _lastPlayers = List.from(structuredPlayers);
    challengers.value = ApiResponse.completed(structuredPlayers);

    if (kDebugMode) {
      print('✅ UI Updated: ${structuredPlayers.length} total items');
      print('   Real players: ${data.length}');
    }
  }

  /// Fetch challenge players
  Future<void> fetchChallengePlayers(int challengeId) async {
    try {
      challengers.value = ApiResponse.loading();

      final url = '${ApiConstants.baseUrl}/challenges/$challengeId/challengeplayer';

      if (kDebugMode) print('📡 Fetching players from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (kDebugMode) {
        print('📥 Response Status: ${response.statusCode}');
        print('📥 Response Body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = jsonDecode(response.body);
        _lastPlayerCount = data.length;
        await _updatePlayersList(data, challengeId);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Error fetching challenge players: $e');
        print('Stack trace: $stackTrace');
      }
      challengers.value = ApiResponse.error(e.toString());
    }
  }

  /// Enrich player data with full URLs and defaults
  Map<String, dynamic> _enrichPlayerData(
      Map<String, dynamic> playerData,
      int challengeId, {
        required bool isHost,
      }) {
    final name = playerData['name']?.toString() ?? 'Player';
    final userId = playerData['userId']?.toString() ?? playerData['id']?.toString() ?? '';
    final avatarPicId = playerData['avatarPicId']?.toString() ?? '';
    final rank = playerData['rank'] ?? 1;
    final totalPoints = playerData['totalPoints'] ?? 0;

    // Build avatar URL
    String avatar;
    if (avatarPicId.startsWith('http')) {
      avatar = avatarPicId;
    } else if (avatarPicId.isNotEmpty) {
      avatar = '${ApiConstants.baseUrl}/uploads/$avatarPicId';
    } else {
      avatar = 'assets/images/solo_image.png';
    }

    return {
      'id': userId,
      'userId': userId,
      'name': name,
      'displayName': name,
      'avatarPicId': avatarPicId,
      'avatar': avatar,
      'rank': rank,
      'totalPoints': totalPoints,
      'level': 'Level $rank',
      'challengeId': challengeId,
      'isHost': isHost,
      'isPlaceholder': false,
    };
  }

  /// Refresh players manually
  Future<void> refreshPlayers() async {
    if (challengeId != null) {
      await fetchChallengePlayers(challengeId!);
    }
  }
}
