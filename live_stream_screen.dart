import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import '../../models/user_model.dart';
import '../../models/live_model.dart';
import '../../models/chat_gift_model.dart';
import '../../services/zego_service.dart';

class LiveStreamScreen extends StatefulWidget {
  final LiveModel liveInfo;
  final UserModel currentUser;
  final bool isHost;

  const LiveStreamScreen({
    super.key,
    required this.liveInfo,
    required this.currentUser,
    this.isHost = false,
  });

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  Widget? _videoView;
  int? _canvasViewID;

  final TextEditingController _messageController = TextEditingController();
  final List<LiveChatMessage> _chatMessages = [];
  
  // Available Gifts List
  final List<GiftModel> _gifts = [
    GiftModel(id: '1', name: 'Rose 🌹', icon: '🌹', coinPrice: 10),
    GiftModel(id: '2', name: 'Diamond 💎', icon: '💎', coinPrice: 50),
    GiftModel(id: '3', name: 'Crown 👑', icon: '👑', coinPrice: 100),
    GiftModel(id: '4', name: 'Sports Car 🏎️', icon: '🏎️', coinPrice: 500),
  ];

  @override
  void initState() {
    super.initState();
    _startLiveSession();
    // Welcome message
    _chatMessages.add(LiveChatMessage(
      senderName: 'System',
      senderAvatar: '',
      message: 'Welcome to ${widget.liveInfo.hostName}\'s live stream!',
    ));
  }

  Future<void> _startLiveSession() async {
    await ZegoService.initZegoEngine();

    await ZegoExpressEngine.instance.createCanvasView((viewID) {
      _canvasViewID = viewID;
      ZegoCanvas canvas = ZegoCanvas(viewID);

      if (widget.isHost) {
        ZegoExpressEngine.instance.startPreview(canvas: canvas);
        ZegoService.startPublishingStream(widget.liveInfo.roomId);
      } else {
        ZegoExpressEngine.instance.startPlayingStream(
          widget.liveInfo.roomId,
          canvas: canvas,
        );
      }
    }).then((widget) {
      setState(() {
        _videoView = widget;
      });
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _chatMessages.add(LiveChatMessage(
        senderName: widget.currentUser.nickname,
        senderAvatar: widget.currentUser.avatarUrl,
        message: _messageController.text.trim(),
      ));
      _messageController.clear();
    });
  }

  void _sendGift(GiftModel gift) {
    if (widget.currentUser.coins < gift.coinPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough coins! Please recharge.')),
      );
      return;
    }

    setState(() {
      widget.currentUser.coins -= gift.coinPrice;
      _chatMessages.add(LiveChatMessage(
        senderName: widget.currentUser.nickname,
        senderAvatar: widget.currentUser.avatarUrl,
        message: 'sent a ${gift.name} ${gift.icon}',
        isGift: true,
        giftName: gift.name,
        giftIcon: gift.icon,
      ));
    });

    Navigator.pop(context); // Close bottom sheet
    
    // Popup Notification for Gift
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.pinkAccent,
        content: Text('🎁 Sent ${gift.name} to Host!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showGiftBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withOpacity(0.9),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Send Gift 🎁',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.currentUser.coins}',
                        style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(color: Colors.grey),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: _gifts.length,
                  itemBuilder: (context, index) {
                    final gift = _gifts[index];
                    return GestureDetector(
                      onTap: () => _sendGift(gift),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.pinkAccent.withOpacity(0.3)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(gift.icon, style: const TextStyle(fontSize: 28)),
                            const SizedBox(height: 4),
                            Text(
                              gift.name,
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                              maxLines: 1,
                            ),
                            Text(
                              '${gift.coinPrice} 🪙',
                              style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    if (widget.isHost) {
      ZegoService.stopPublishingStream();
      ZegoExpressEngine.instance.stopPreview();
    } else {
      ZegoService.stopPlayingStream(widget.liveInfo.roomId);
    }
    if (_canvasViewID != null) {
      ZegoExpressEngine.instance.destroyCanvasView(_canvasViewID!);
    }
    ZegoExpressEngine.destroyEngine();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Video Stream
          Center(
            child: _videoView ??
                const CircularProgressIndicator(color: Colors.pinkAccent),
          ),

          // Header Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(widget.liveInfo.hostAvatar),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.liveInfo.hostName,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(
                              '${widget.liveInfo.viewerCount} Viewers',
                              style: const TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),

          // Live Chat Messages Area
          Positioned(
            left: 12,
            bottom: 70,
            width: MediaQuery.of(context).size.width * 0.7,
            height: 220,
            child: ListView.builder(
              reverse: true,
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                final chat = _chatMessages[_chatMessages.length - 1 - index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: chat.isGift
                        ? Colors.pinkAccent.withOpacity(0.3)
                        : Colors.black45,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${chat.senderName}: ',
                          style: const TextStyle(
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: chat.message,
                          style: TextStyle(
                            color: chat.isGift ? Colors.white : Colors.white70,
                            fontWeight: chat.isGift ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Controls (Chat Input + Gift Button)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.black45,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Say something...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[900],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.pinkAccent),
                    onPressed: _sendMessage,
                  ),
                  IconButton(
                    icon: const Icon(Icons.card_giftcard, color: Colors.amber, size: 28),
                    onPressed: _showGiftBottomSheet,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
