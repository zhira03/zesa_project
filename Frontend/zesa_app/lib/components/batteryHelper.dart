import 'dart:ui';
import 'package:flutter/material.dart';

class BatteryInfoScreen extends StatelessWidget {
  const BatteryInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: BatteryInfoCard(
            batteryType: 'Lithium-Ion',
            capacityKwh: 13.5,
            chargePercent: 78,
            unitCount: 2,
            funFact:
                'At full charge, your batteries can power an average home for over 24 hours without any solar input!',
          ),
        ),
      ),
    );
  }
}

class BatteryInfoCard extends StatelessWidget {
  final String batteryType;
  final double capacityKwh;
  final int chargePercent;
  final int unitCount;
  final String funFact;

  const BatteryInfoCard({
    super.key,
    required this.batteryType,
    required this.capacityKwh,
    required this.chargePercent,
    required this.unitCount,
    required this.funFact,
  });

  Color get _chargeColor {
    if (chargePercent >= 60) return const Color(0xFF10B981);
    if (chargePercent >= 30) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
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
                  Icons.battery_charging_full_rounded,
                  color: Color(0xFFF59E0B),
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Installed Battery Info',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    'Your storage at a glance',
                    style: TextStyle(
                      color: Color(0xFF8A9BAE),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Top stats row
          Row(
            children: [
              _StatTile(
                icon: Icons.category_rounded,
                label: 'Type',
                value: batteryType,
                flex: 3,
              ),
              const SizedBox(width: 10),
              _StatTile(
                icon: Icons.battery_full_rounded,
                label: 'Capacity',
                value: '${capacityKwh}kWh',
                flex: 2,
              ),
              const SizedBox(width: 10),
              _StatTile(
                icon: Icons.storage_rounded,
                label: 'Units',
                value: unitCount.toString(),
                flex: 2,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Fun Fact Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFF59E0B).withOpacity(0.18),
                  const Color(0xFF10B981).withOpacity(0.12),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFF59E0B).withOpacity(0.25),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fun Fact',
                        style: TextStyle(
                          color: Color(0xFFF59E0B),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        funFact,
                        style: const TextStyle(
                          color: Color(0xFFD1E0F0),
                          fontSize: 13,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                fontSize: 15,
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
            ),
          ],
        ),
      ),
    );
  }
}
