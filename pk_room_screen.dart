import 'package:flutter/material.dart';

class PkRoomScreen extends StatefulWidget {
  final String host1Name;
  final String host2Name;

  const PkRoomScreen({
    super.key,
    required this.host1Name,
    required this.host2Name,
  });

  @override
  State<PkRoomScreen> createState() => _PkRoomScreenState();
}

class _PkRoomScreenState extends State<PkRoomScreen> {
  int _host1Score = 1200;
  int _host2Score = 950;

  @override
  Widget build(BuildContext context) {
    double host1Ratio = _host1Score / (_host1Score + _host2Score);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Bar / Close Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🔥 PK BATTLE',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // PK Score Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 16,
                      child: Row(
                        children: [
                          Expanded(
                            flex: (_host1Score),
                            child: Container(color: Colors.blueAccent),
                          ),
                          Expanded(
                            flex: (_host2Score),
                            child: Container(color: Colors.pinkAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('💙 ${_host1Score}', style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                      Text('💗 ${_host2Score}', style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            // Split Screen Video Area (Host 1 vs Host 2)
            Expanded(
              child: Row(
                children: [
                  // Host 1 Video View
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blueAccent, width: 2),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(radius: 30, backgroundColor: Colors.blueAccent, child: Icon(Icons.person, color: Colors.white)),
                            const SizedBox(height: 8),
                            Text(widget.host1Name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Host 2 Video View
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.pinkAccent, width: 2),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(radius: 30, backgroundColor: Colors.pinkAccent, child: Icon(Icons.person, color: Colors.white)),
                            const SizedBox(height: 8),
                            Text(widget.host2Name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Gift Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[900],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                    onPressed: () {
                      setState(() {
                        _host1Score += 100;
                      });
                    },
                    icon: const Icon(Icons.card_giftcard, color: Colors.white),
                    label: const Text('Gift Host 1', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                    onPressed: () {
                      setState(() {
                        _host2Score += 100;
                      });
                    },
                    icon: const Icon(Icons.card_giftcard, color: Colors.white),
                    label: const Text('Gift Host 2', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
