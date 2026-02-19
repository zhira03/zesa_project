import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      body: SafeArea(
        child: Center(
          child: WalletCard(
            balance: 4823.50,
            escrowedFunds: 1200.00,
            totalEarned: 21340.75,
            pendingPayouts: 650.00,
            currency: 'USD',
            onCashout: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cashout triggered!')),
              );
            },
          ),
        ),
      ),
    );
  }
}

class WalletCard extends StatefulWidget {
  final double balance;
  final double escrowedFunds;
  final double totalEarned;
  final double pendingPayouts;
  final String currency;
  final VoidCallback onCashout;

  const WalletCard({
    super.key,
    required this.balance,
    required this.escrowedFunds,
    required this.totalEarned,
    required this.pendingPayouts,
    required this.currency,
    required this.onCashout,
  });

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  bool _balanceVisible = false;

  String _fmt(double amount) {
    if (!_balanceVisible) return '••••••';
    return '${widget.currency} ${amount.toStringAsFixed(2)}';
  }

  void _showEscrowInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF1C2B3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.lock_outline_rounded,
                        color: Color(0xFFF59E0B), size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Escrowed Funds',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Escrowed funds are payments held securely while a transaction or service is being verified. Once confirmed, they are released to your available balance.',
                style: TextStyle(
                  color: Color(0xFFD1E0F0),
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B).withOpacity(0.12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Got it',
                    style: TextStyle(
                      color: Color(0xFFF59E0B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Color(0xFFF59E0B),
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Wallet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    'Your funds at a glance',
                    style: TextStyle(
                      color: Color(0xFF8A9BAE),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Visibility toggle
              GestureDetector(
                onTap: () => setState(() => _balanceVisible = !_balanceVisible),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2B3A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Icon(
                    _balanceVisible
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: const Color(0xFF8A9BAE),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Main balance card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1C2B3A), Color(0xFF162235)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFF59E0B).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available Balance',
                  style: TextStyle(
                    color: Color(0xFF8A9BAE),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _fmt(widget.balance),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Escrowed funds row
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline_rounded,
                          color: Color(0xFF8A9BAE), size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'Escrowed Funds',
                        style: TextStyle(
                          color: Color(0xFF8A9BAE),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _showEscrowInfo(context),
                        child: const Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFFF59E0B),
                          size: 15,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _fmt(widget.escrowedFunds),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Cashout button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: widget.onCashout,
                    icon: const Icon(Icons.north_rounded, size: 18),
                    label: const Text(
                      'Cash Out',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      foregroundColor: const Color(0xFF0F1923),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Stats row
          Row(
            children: [
              _StatTile(
                icon: Icons.trending_up_rounded,
                label: 'Total Earned',
                value: _fmt(widget.totalEarned),
                flex: 1,
              ),
              const SizedBox(width: 10),
              _StatTile(
                icon: Icons.schedule_rounded,
                label: 'Pending Payouts',
                value: _fmt(widget.pendingPayouts),
                flex: 1,
              ),
              const SizedBox(width: 10),
              _StatTile(
                icon: Icons.currency_exchange_rounded,
                label: 'Currency',
                value: widget.currency,
                flex: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final int flex;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.flex,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1C2B3A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFF59E0B), size: 18),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF8A9BAE),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
