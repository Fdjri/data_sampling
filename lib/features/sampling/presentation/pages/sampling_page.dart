import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../widgets/sampling_card_widget.dart';

class SamplingPage extends StatelessWidget {
  const SamplingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        surfaceTintColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Text(
          'SAMPLING',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header (Search & Filter Cards)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              children: [
                // Search Bar
                const ShadInput(
                  leading: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      LucideIcons.search,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                  placeholder: Text('Cari No. Contoh atau Nama Perusahaan...'),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                const SizedBox(height: 16),

                // Summary Cards (Today & All)
                Row(
                  children: [
                    _buildSummaryCard(
                      label: 'Today',
                      value: '10',
                      color: const Color(0xFF3B4876),
                    ),
                    const SizedBox(width: 16),
                    _buildSummaryCard(
                      label: 'All',
                      value: '120',
                      color: const Color(0xFFE94E9F),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // List Data
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SamplingCardWidget(
                    id: '010006/LAB.3LC-LMP2+LD/XII/2025',
                    companyName:
                        'Laboratorium Lingkungan Hidup Daerah Provinsi DKI Jakarta',
                    date: '2025-12-01',
                    type: 'Air Limbah',
                    onEdit: () {
                      context.goNamed('sampling_edit');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Card Summary Stat ---
  Widget _buildSummaryCard({
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2.5),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
