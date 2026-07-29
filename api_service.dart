import 'dart:convert';
import '../models/user_model.dart';
import '../models/live_model.dart';

class ApiService {
  // Replace with your actual backend URL later
  static const String baseUrl = 'https://api.rklive.com/v1';

  /// Mock login method
  static Future<UserModel> loginUser(String phone, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return UserModel(
      userId: '1001',
      nickname: 'RK User',
      avatarUrl: 'https://via.placeholder.com/150',
      coins: 500,
      wealthLevel: 2,
      honorLevel: 1,
    );
  }

  /// Get active live streams list
  static Future<List<LiveModel>> getActiveLiveStreams() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      LiveModel(
        roomId: 'room_01',
        hostId: 'host_1',
        hostName: 'Sarah Live',
        hostAvatar: 'https://via.placeholder.com/150',
        roomTitle: 'Welcome to my stream! 🌟',
        viewerCount: 120,
      ),
      LiveModel(
        roomId: 'room_02',
        hostId: 'host_2',
        hostName: 'Alex Music',
        hostAvatar: 'https://via.placeholder.com/150',
        roomTitle: 'Late Night Songs 🎸',
        viewerCount: 450,
      ),
    ];
  }
}
