import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SamplingCardWidget extends StatelessWidget {
  final String id;
  final String companyName;
  final String date;
  final String type;
  final VoidCallback onEdit;

  const SamplingCardWidget({
    super.key,
    required this.id,
    required this.companyName,
    required this.date,
    required this.type,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Header: Badge & Tanggal ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShadBadge(
                backgroundColor: Colors.blue.withOpacity(0.1),
                hoverBackgroundColor: Colors.blue.withOpacity(0.2),
                foregroundColor: Colors.blue[700],
                child: Text(type),
              ),
              Row(
                children: [
                  const Icon(LucideIcons.calendarDays, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: theme.textTheme.muted.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // --- ID Sampling ---
          Text(
            id,
            style: theme.textTheme.h4.copyWith(
              fontSize: 16, 
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // --- Nama Perusahaan ---
          _buildLabelValue(context, "Nama Perusahaan", companyName),
          const SizedBox(height: 8),
          
          // --- Output ---
          _buildLabelValue(context, "Output Hasil Uji", "LMP2+LD - Lampiran 2 + LD"),
          
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.grey),
          const SizedBox(height: 16),

          // --- Tombol Action ---
          Row(
            children: [
              Expanded(
                child: ShadButton.secondary(
                  onPressed: () {}, 
                  child: const Text('Sampling'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ShadButton(
                  backgroundColor: Colors.green,
                  hoverBackgroundColor: Colors.green[700],
                  onPressed: onEdit,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.pencil, size: 16), 
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLabelValue(BuildContext context, String label, String value) {
    final theme = ShadTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.muted.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.p.copyWith(
            fontWeight: FontWeight.w600, 
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}