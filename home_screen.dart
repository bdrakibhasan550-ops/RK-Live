import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/live_model.dart';
import '../live/live_stream_screen.dart';
import '../live/party_room_screen.dart';
import '../pk_room_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Mock User
  final UserModel _currentUser = UserModel(
    userId: '100234',
    nickname: 'Pro Streamer',
    avatarUrl: 'https://via.placeholder.com/150',
    coins: 500,
    wealthLevel: 5,
  );

  // Mock Live Streams
  final List<LiveModel> _liveStreams = [
    LiveModel(
      roomId: 'room_1',
      hostName: 'Sophia',
      hostAvatar: 'https://via.placeholder.com/150',
      title: 'Singing & Chatting 🎵',
      viewerCount: 1240,
    ),
    LiveModel(
      roomId: 'room_2',
      hostName: 'Alex',
      hostAvatar: 'https://via.placeholder.com/150',
      title: 'Night Vibe Live 🌙',
      viewerCount: 850,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'RK LIVE',
          style: TextStyle(
            color: Colors.pinkAccent,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: _currentUser),
                ),
              ).then((_) => setState(() {}));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(_currentUser.avatarUrl),
              ),
            ),
          ),
        ],
      ),
      body: _buildSelectedTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.grey[900],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Party'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'PK Battle'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.videocam, color: Colors.white),
        onPressed: () {
          // Host Starts Live
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LiveStreamScreen(
                liveInfo: LiveModel(
                  roomId: 'my_live_${_currentUser.userId}',
                  hostName: _currentUser.nickname,
                  hostAvatar: _currentUser.avatarUrl,
                  title: 'My Live Stream',
                  viewerCount: 1,
                ),
                currentUser: _currentUser,
                isHost: true,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedTab() {
    switch (_currentIndex) {
      case 0:
        return _buildLiveFeed();
      case 1:
        return _buildPartyFeed();
      case 2:
        return _buildPkFeed();
      default:
        return _buildLiveFeed();
    }
  }

  // Live Stream Feed
  Widget _buildLiveFeed() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: _liveStreams.length,
      itemBuilder: (context, index) {
        final live = _liveStreams[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LiveStreamScreen(
                  liveInfo: live,
                  currentUser: _currentUser,
                  isHost: false,
                ),
              ),
            ).then((_) => setState(() {}));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[900],
              image: DecorationImage(
                image: NetworkImage(live.hostAvatar),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    live.hostName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    live.title,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Party Room Feed
  Widget _buildPartyFeed() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.grey[900],
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.pinkAccent,
              child: Icon(Icons.mic, color: Colors.white),
            ),
            title: Text('Voice Party Room #${index + 1}', style: const TextStyle(color: Colors.white)),
            subtitle: const Text('9 Seats Active • Join Chat', style: TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.pinkAccent, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PartyRoomScreen(
                    roomId: 'party_$index',
                    roomName: 'Voice Party #${index + 1}',
                    currentUser: _currentUser,
                  ),
                ),
              ).then((_) => setState(() {}));
            },
          ),
        );
      },
    );
  }

  // PK Battle Feed
  Widget _buildPkFeed() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.sports_esports, size: 64, color: Colors.pinkAccent),
          const SizedBox(height: 12),
          const Text('Live PK Battle Arena', style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PkRoomScreen(
                    host1Name: 'Sophia (Host 1)',
                    host2Name: 'Alex (Host 2)',
                  ),
                ),
              );
            },
            child: const Text('Join Active PK Battle', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
