import 'package:flutter/material.dart';
import '../../services/payment_service.dart';
import '../../models/user_model.dart';

class PaymentScreen extends StatefulWidget {
  final UserModel currentUser;
  final int coinsToBuy;
  final double amountInBDT;

  const PaymentScreen({
    super.key,
    required this.currentUser,
    required this.coinsToBuy,
    required this.amountInBDT,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'bKash'; // 'bKash' or 'Rocket'
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _trxController = TextEditingController();
  bool _isLoading = false;

  void _handlePayment() async {
    if (_phoneController.text.trim().isEmpty || _trxController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Mobile Number and Transaction ID')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool success = false;
    if (_selectedMethod == 'bKash') {
      success = await PaymentService.processBkashPayment(
        phoneNumber: _phoneController.text.trim(),
        amount: widget.amountInBDT,
        trxId: _trxController.text.trim(),
      );
    } else {
      success = await PaymentService.processRocketPayment(
        accountNumber: _phoneController.text.trim(),
        amount: widget.amountInBDT,
        trxId: _trxController.text.trim(),
      );
    }

    setState(() {
      _isLoading = false;
    });

    if (success) {
      widget.currentUser.coins += widget.coinsToBuy;
      if (!mounted) return;
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('🎉 Payment Successful!', style: TextStyle(color: Colors.green)),
          content: Text(
            'Added ${widget.coinsToBuy} coins to your wallet using $_selectedMethod.',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Back to wallet
              },
              child: const Text('OK', style: TextStyle(color: Colors.pinkAccent)),
            ),
          ],
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Payment Failed! Please check your credentials.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Checkout Payment', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Buying Coins', style: TextStyle(color: Colors.grey)),
                      Text(
                        '🪙 ${widget.coinsToBuy} Coins',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    '৳${widget.amountInBDT.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.pinkAccent, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Select Payment Method',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // bKash & Rocket Selection Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedMethod = 'bKash'),
                    child: Container(
                      padding: const EdgeInsets.vertical(14),
                      decoration: BoxDecoration(
                        color: _selectedMethod == 'bKash' ? Colors.pink : Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedMethod == 'bKash' ? Colors.pinkAccent : Colors.white12,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'bKash (বিকাশ)',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedMethod = 'Rocket'),
                    child: Container(
                      padding: const EdgeInsets.vertical(14),
                      decoration: BoxDecoration(
                        color: _selectedMethod == 'Rocket' ? Colors.purple : Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedMethod == 'Rocket' ? Colors.purpleAccent : Colors.white12,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Rocket (রকেট)',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Form Inputs
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: '$_selectedMethod Account Number',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _trxController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'TrxID / Transaction ID',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedMethod == 'bKash' ? Colors.pink : Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : _handlePayment,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Pay ৳${widget.amountInBDT.toStringAsFixed(0)} with $_selectedMethod',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
