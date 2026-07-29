import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../wallet/recharge_screen.dart';
import '../agency/agency_admin_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('My Profile', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                widget.user.avatarUrl.isNotEmpty
                    ? widget.user.avatarUrl
                    : 'https://via.placeholder.com/150',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.user.nickname,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'ID: ${widget.user.userId}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            
            // Coins & Wealth Level Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.amber, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.user.coins}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Coins', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  Container(height: 30, width: 1, color: Colors.grey[800]),
                  Column(
                    children: [
                      const Icon(Icons.military_tech, color: Colors.pinkAccent, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        'Lv. ${widget.user.wealthLevel}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Wealth Level', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // Recharge Button
            ListTile(
              tileColor: Colors.grey[900],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: const Icon(Icons.account_balance_wallet, color: Colors.pinkAccent),
              title: const Text('Top-up Coins (bKash/Rocket)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RechargeScreen(currentUser: widget.user),
                  ),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
            const SizedBox(height: 12),

            // Agency Dashboard Button
            ListTile(
              tileColor: Colors.grey[900],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: const Icon(Icons.admin_panel_settings, color: Colors.purpleAccent),
              title: const Text('Agency Admin Panel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: const Text('Host & Income Management', style: TextStyle(color: Colors.grey, fontSize: 11)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AgencyAdminScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
