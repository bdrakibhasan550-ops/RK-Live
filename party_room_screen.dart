import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class PartyRoomScreen extends StatefulWidget {
  final String roomId;
  final String roomName;
  final UserModel currentUser;

  const PartyRoomScreen({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.currentUser,
  });

  @override
  State<PartyRoomScreen> createState() => _PartyRoomScreenState();
}

class _PartyRoomScreenState extends State<PartyRoomScreen> {
  // 9-seat party room layout representation
  final List<String?> _seats = List.filled(9, null);
  bool _isMicMuted = false;

  @override
  void initState() {
    super.initState();
    _seats[0] = widget.currentUser.nickname; // Seat 1 assigned to Host
  }

  void _toggleSeat(int index) {
    setState(() {
      if (_seats[index] == null) {
        _seats[index] = widget.currentUser.nickname;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Joined Seat ${index + 1}')),
        );
      } else {
        if (index == 0) return; // Cannot leave Host seat easily
        _seats[index] = null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Left Seat ${index + 1}')),
        );
      }
    });
  }

  void _sendPartyGift() {
    if (widget.currentUser.coins < 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough coins! Please top-up.')),
      );
      return;
    }

    setState(() {
      widget.currentUser.coins -= 20;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.pinkAccent,
        content: Text('🎉 Sent Party Gift (20 🪙) to Room!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.roomName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: [
              const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text('${widget.currentUser.coins}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // 9-Seat Party Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final seatUser = _seats[index];
                return GestureDetector(
                  onTap: () => _toggleSeat(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: seatUser != null ? Colors.pinkAccent : Colors.white12,
                        width: seatUser != null ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: seatUser != null ? Colors.pinkAccent : Colors.grey[800],
                          child: Icon(
                            seatUser != null ? Icons.person : Icons.add,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          seatUser ?? 'Seat ${index + 1}',
                          style: TextStyle(
                            color: seatUser != null ? Colors.pinkAccent : Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Control Panel
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: Colors.black26,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(_isMicMuted ? Icons.mic_off : Icons.mic, color: _isMicMuted ? Colors.red : Colors.white),
                  onPressed: () {
                    setState(() {
                      _isMicMuted = !_isMicMuted;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.card_giftcard, color: Colors.amber, size: 28),
                  onPressed: _sendPartyGift,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
