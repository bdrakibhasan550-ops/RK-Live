class LiveModel {
  final String roomId;
  final String hostId;
  final String hostName;
  final String hostAvatar;
  final String roomTitle;
  final int viewerCount;
  final bool isLive;

  LiveModel({
    required this.roomId,
    required this.hostId,
    required this.hostName,
    required this.hostAvatar,
    required this.roomTitle,
    this.viewerCount = 0,
    this.isLive = true,
  });

  // Convert LiveModel to JSON Map
  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'hostId': hostId,
      'hostName': hostName,
      'hostAvatar': hostAvatar,
      'roomTitle': roomTitle,
      'viewerCount': viewerCount,
      'isLive': isLive,
    };
  }

  // Create LiveModel from JSON Map
  factory LiveModel.fromJson(Map<String, dynamic> json) {
    return LiveModel(
      roomId: json['roomId'] ?? '',
      hostId: json['hostId'] ?? '',
      hostName: json['hostName'] ?? 'Host',
      hostAvatar: json['hostAvatar'] ?? '',
      roomTitle: json['roomTitle'] ?? 'Live Stream',
      viewerCount: json['viewerCount'] ?? 0,
      isLive: json['isLive'] ?? true,
    );
  }
}
