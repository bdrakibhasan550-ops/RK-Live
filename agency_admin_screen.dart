import 'package:flutter/material.dart';

class AgencyAdminScreen extends StatefulWidget {
  final String agencyName;
  final String agencyId;

  const AgencyAdminScreen({
    super.key,
    this.agencyName = 'RK Elite Agency',
    this.agencyId = 'AG-99082',
  });

  @override
  State<AgencyAdminScreen> createState() => _AgencyAdminScreenState();
}

class _AgencyAdminScreenState extends State<AgencyAdminScreen> {
  // Mock Host Data List
  final List<Map<String, dynamic>> _hosts = [
    {'name': 'Sophia Live', 'id': 'H-101', 'gems': 45000, 'hours': 32.5, 'status': 'Active'},
    {'name': 'Alex Vibe', 'id': 'H-102', 'gems': 28000, 'hours': 20.0, 'status': 'Active'},
    {'name': 'Nila Queen', 'id': 'H-103', 'gems': 12000, 'hours': 12.0, 'status': 'Offline'},
  ];

  final TextEditingController _hostIdController = TextEditingController();

  void _addHostDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Add Host to Agency', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _hostIdController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter User ID (e.g. 100234)',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.black45,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
              onPressed: () {
                if (_hostIdController.text.trim().isNotEmpty) {
                  setState(() {
                    _hosts.add({
                      'name': 'New Host (${_hostIdController.text.trim()})',
                      'id': 'H-${_hostIdController.text.trim()}',
                      'gems': 0,
                      'hours': 0.0,
                      'status': 'Offline',
                    });
                  });
                  _hostIdController.clear();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Host Added Successfully!')),
                  );
                }
              },
              child: const Text('Add Host', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Agency Dashboard', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Agency Overview Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.pinkAccent],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.agencyName,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('ID: ${widget.agencyId}', style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Hosts', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          Text(
                            '${_hosts.length}',
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Agency Commission', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const Text(
                            '\$1,250.00',
                            style: TextStyle(color: Colors.amberAccent, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Management Section Title & Action Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Host Management List',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  label: const Text('Add Host', style: TextStyle(color: Colors.white)),
                  onPressed: _addHostDialog,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Host Cards List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _hosts.length,
              itemBuilder: (context, index) {
                final host = _hosts[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.pinkAccent.withOpacity(0.2),
                            child: const Icon(Icons.person, color: Colors.pinkAccent),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                host['name'],
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'ID: ${host['id']} • ${host['hours']} hrs live',
                                style: const TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '💎 ${host['gems']}',
                            style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            host['status'],
                            style: TextStyle(
                              color: host['status'] == 'Active' ? Colors.green : Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
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
