class LiveChatMessage {
  final String senderName;
  final String senderAvatar;
  final String message;
  final bool isGift;
  final String? giftName;
  final String? giftIcon;

  LiveChatMessage({
    required this.senderName,
    required this.senderAvatar,
    required this.message,
    this.isGift = false,
    this.giftName,
    this.giftIcon,
  });
}

class GiftModel {
  final String id;
  final String name;
  final String icon;
  final int coinPrice;

  GiftModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.coinPrice,
  });
}
