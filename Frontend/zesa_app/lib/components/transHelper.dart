import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      body: SafeArea(
        child: Center(
          child: RecentTransactionsCard(
            transactions: [
              TransactionItem(
                customer: 'Sarah Johnson',
                date: '18 Feb 2026',
                status: 'Completed',
                amount: '\$1,240.00',
              ),
              TransactionItem(
                customer: 'Mark Thompson',
                date: '17 Feb 2026',
                status: 'Pending',
                amount: '\$875.50',
              ),
              TransactionItem(
                customer: 'Aisha Patel',
                date: '15 Feb 2026',
                status: 'Completed',
                amount: '\$3,100.00',
              ),
              TransactionItem(
                customer: 'Carlos Rivera',
                date: '14 Feb 2026',
                status: 'Failed',
                amount: '\$420.00',
              ),
              TransactionItem(
                customer: 'Emily Chen',
                date: '12 Feb 2026',
                status: 'Completed',
                amount: '\$2,050.75',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionItem {
  final String customer;
  final String date;
  final String status;
  final String amount;

  const TransactionItem({
    required this.customer,
    required this.date,
    required this.status,
    required this.amount,
  });
}

class RecentTransactionsCard extends StatelessWidget {
  final List<TransactionItem> transactions;

  const RecentTransactionsCard({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final recent = transactions.take(5).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: Color(0xFFF59E0B),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Last 5 transactions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              // View all button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2B3A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
                child: const Text(
                  'View all',
                  style: TextStyle(
                    color: Color(0xFFF59E0B),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Transaction list
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1C2B3A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
                width: 1,
              ),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recent.length,
              separatorBuilder: (_, __) => Divider(
                color: Colors.white.withOpacity(0.05),
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                return _TransactionRow(item: recent[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final TransactionItem item;

  const _TransactionRow({required this.item});

  Color get _statusColor {
    switch (item.status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'failed':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF8A9BAE);
    }
  }

  IconData get _statusIcon {
    switch (item.status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle_rounded;
      case 'pending':
        return Icons.schedule_rounded;
      case 'failed':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String get _initials {
    final parts = item.customer.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              _initials,
              style: const TextStyle(
                color: Color(0xFFF59E0B),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Customer + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.customer,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.date,
                  style: const TextStyle(
                    color: Color(0xFF8A9BAE),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_statusIcon, color: _statusColor, size: 11),
                const SizedBox(width: 4),
                Text(
                  item.status,
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Amount
          Text(
            item.amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
