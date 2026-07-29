class UserModel {
  final String userId;
  final String nickname;
  final String avatarUrl;
  final int coins;
  final int points;
  final int wealthLevel;
  final int honorLevel;

  UserModel({
    required this.userId,
    required this.nickname,
    required this.avatarUrl,
    this.coins = 0,
    this.points = 0,
    this.wealthLevel = 1,
    this.honorLevel = 1,
  });

  // Convert UserModel to JSON Map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nickname': nickname,
      'avatarUrl': avatarUrl,
      'coins': coins,
      'points': points,
      'wealthLevel': wealthLevel,
      'honorLevel': honorLevel,
    };
  }

  // Create UserModel from JSON Map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '',
      nickname: json['nickname'] ?? 'User',
      avatarUrl: json['avatarUrl'] ?? '',
      coins: json['coins'] ?? 0,
      points: json['points'] ?? 0,
      wealthLevel: json['wealthLevel'] ?? 1,
      honorLevel: json['honorLevel'] ?? 1,
    );
  }
}
