import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

class ContohUjiPage extends StatelessWidget {
  const ContohUjiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        surfaceTintColor: const Color(0xFF1E293B),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () => context.pop(),
          tooltip: "Kembali",
        ),
        title: Column(
          children: [
            Text(
              'PARAMETER ANALISA CONTOH UJI',
              style: theme.textTheme.h4.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "No. Ref: #SMP-2024-X12",
              style: theme.textTheme.muted.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // --- Header List ---
                Text(
                  "Daftar Parameter (9)",
                  style: theme.textTheme.h3.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // --- 1. pH ---
                _buildParameterCard(
                  context,
                  theme,
                  parameter: 'pH',
                  satuan: '',
                  metode: 'SNI 06-6989.11-2004',
                  hasil: '7.2',
                ),
                const SizedBox(height: 16),

                // --- 2. Zat Padat Tersuspensi ---
                _buildParameterCard(
                  context,
                  theme,
                  parameter: 'Zat Padat Tersuspensi',
                  satuan: 'mg/L',
                  metode: 'SNI 06-6989.3-2004',
                  hasil: '45',
                ),
                const SizedBox(height: 16),

                // --- 3. Sianida ---
                _buildParameterCard(
                  context,
                  theme,
                  parameter: 'Sianida (CN)',
                  satuan: 'mg/L',
                  metode: 'SNI 6989.77:2011',
                  hasil: '< 0.02',
                ),
                const SizedBox(height: 16),

                // --- 4. Krom (Cr-T) ---
                _buildParameterCard(
                  context,
                  theme,
                  parameter: 'Krom Total (Cr-T)',
                  satuan: 'mg/L',
                  metode: 'SNI 6989.17:2009',
                  hasil: '0.15',
                ),
                const SizedBox(height: 16),

                // --- 5. Krom Heksavalen (Cr-VI) ---
                _buildParameterCard(
                  context,
                  theme,
                  parameter: 'Krom Heksavalen (Cr-VI)',
                  satuan: 'mg/L',
                  metode: 'SNI 6989.71:2009',
                  hasil: '< 0.05',
                ),
                const SizedBox(height: 16),

                // --- 6. Tembaga Total ---
                _buildParameterCard(
                  context,
                  theme,
                  parameter: 'Tembaga Total (Cu)',
                  satuan: 'mg/L',
                  metode: 'SNI 06-6989.6-2004',
                  hasil: '0.08',
                ),
                const SizedBox(height: 16),

                // --- 7. Organik ---
                _buildParameterCard(
                  context,
                  theme,
                  parameter: 'Organik (KMnO4)',
                  satuan: 'mg/L',
                  metode: 'SNI 06-6989.22-2004',
                  hasil: '12.5',
                ),
                const SizedBox(height: 16),

                // --- 8. COD ---
                _buildParameterCard(
                  context,
                  theme,
                  parameter: 'Chemical Oxygen Demand (COD)',
                  satuan: 'mg/L',
                  metode: 'SNI 6989.2:2009',
                  hasil: '34.2',
                ),
                const SizedBox(height: 16),

                // --- 9. BOD5 ---
                _buildParameterCard(
                  context,
                  theme,
                  parameter: 'Biochemical Oxygen Demand (BOD5)',
                  satuan: 'mg/L',
                  metode: 'SNI 6989.72:2009',
                  hasil: '18.1',
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParameterCard(
    BuildContext context,
    ShadThemeData theme, {
    required String parameter,
    required String satuan,
    required String metode,
    required String hasil,
  }) {
    return ShadCard(
      padding: const EdgeInsets.all(16),
      radius: BorderRadius.circular(16),
      border: ShadBorder.all(color: Colors.grey.shade200, width: 1),
      shadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Parameter Name & Satuan Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parameter,
                      style: theme.textTheme.h4.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Metode: $metode",
                      style: theme.textTheme.muted.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (satuan.isNotEmpty && satuan != '-')
                ShadBadge.secondary(
                  child: Text(
                    satuan,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 12),

          // Footer: Label Hasil & Nilai
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hasil Uji",
                style: theme.textTheme.muted.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                hasil,
                style: theme.textTheme.large.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD946EF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
