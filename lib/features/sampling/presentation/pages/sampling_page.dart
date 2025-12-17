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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'SAMPLING',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Bagian Header (Search & Filter)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
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
                const SizedBox(height: 12),

                // Filter & Sort Buttons
                Row(
                  children: [
                    Expanded(
                      child: ShadButton.outline(
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('10 Entries'),
                            Icon(LucideIcons.chevronDown, size: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShadButton.outline(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LucideIcons.arrowDownWideNarrow, size: 16),
                            const SizedBox(width: 8),
                            const Text('Sort'),
                          ],
                        ),
                      ),
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
}
