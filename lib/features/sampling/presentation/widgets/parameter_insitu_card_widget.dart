import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ParameterItemCard extends StatelessWidget {
  final String title;
  final String method;
  final String unit;
  final String simploValue;
  final String duploValue;
  final String resultValue;
  final Function(String simplo, String duplo, String hasil) onSave;

  const ParameterItemCard({
    super.key,
    required this.title,
    required this.method,
    required this.unit,
    required this.simploValue,
    required this.duploValue,
    required this.resultValue,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

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
          // --- Header Card ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.h4.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (unit.isNotEmpty)
                ShadBadge.secondary(
                  child: Text(
                    unit,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Metode: $method",
            style: theme.textTheme.muted.copyWith(fontSize: 12),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 16),

          // --- Body Data ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDataColumn(theme, "Simplo", simploValue),
              Container(width: 1, height: 30, color: Colors.grey.shade200),
              _buildDataColumn(theme, "Duplo", duploValue),
              Container(width: 1, height: 30, color: Colors.grey.shade200),
              _buildDataColumn(theme, "Hasil", resultValue, isResult: true),
            ],
          ),

          const SizedBox(height: 20),

          // --- Footer Button ---
          SizedBox(
            width: double.infinity,
            child: ShadButton.outline(
              foregroundColor: Colors.blue,
              decoration: ShadDecoration(
                border: ShadBorder.all(color: Colors.blue, width: 1),
              ),
              onPressed: () => _showEditSheet(context),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [SizedBox(width: 8), Text("Input")],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataColumn(
    ShadThemeData theme,
    String label,
    String value, {
    bool isResult = false,
  }) {
    return Column(
      children: [
        Text(label, style: theme.textTheme.muted.copyWith(fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value.isEmpty ? "-" : value,
          style: theme.textTheme.large.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isResult ? const Color(0xFFD946EF) : Colors.black,
          ),
        ),
      ],
    );
  }

  // --- Logic Bottom Sheet ---
  void _showEditSheet(BuildContext context) {
    final simploController = TextEditingController(text: simploValue);
    final duploController = TextEditingController(text: duploValue);
    final hasilController = TextEditingController(text: resultValue);
    const String nomorContoh = "010006/LAB.3LC/XII/2025";

    showShadSheet(
      side: ShadSheetSide.bottom,
      context: context,
      builder: (context) {
        final theme = ShadTheme.of(context);
        return ShadSheet(
          // Header: Nomor Contoh
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Input Hasil Sampling",
                style: theme.textTheme.h4.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  nomorContoh,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Monospace',
                  ),
                ),
              ),
            ],
          ),
          description: const SizedBox.shrink(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Info Parameter (Parameter, Satuan, Metode)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow("Parameter", title, isBold: true),
                      const SizedBox(height: 8),
                      const Divider(height: 1, thickness: 0.5),
                      const SizedBox(height: 8),
                      _buildInfoRow("Satuan", unit.isEmpty ? "-" : unit),
                      const SizedBox(height: 8),
                      _buildInfoRow("Metode", method),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // 2. Input Fields
                const Text(
                  "Data Pengujian",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        label: "Simplo",
                        controller: simploController,
                        icon: LucideIcons.testTube,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputField(
                        label: "Duplo",
                        controller: duploController,
                        icon: LucideIcons.copy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: "Hasil Uji",
                  controller: hasilController,
                  icon: LucideIcons.flaskConical,
                  isResult: true,
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ShadButton.outline(
                    foregroundColor: Colors.red,
                    decoration: ShadDecoration(
                      border: ShadBorder.all(color: Colors.red, width: 1),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ShadButton(
                    backgroundColor: const Color(0xFF16A34A),
                    hoverBackgroundColor: const Color(0xFF15803D),
                    onPressed: () {
                      onSave(
                        simploController.text,
                        duploController.text,
                        hasilController.text,
                      );
                      Navigator.of(context).pop();
                      ShadToaster.of(context).show(
                        ShadToast(
                          title: const Text('Data Disimpan'),
                          description: Text(
                            'Hasil uji untuk $title telah diperbarui.',
                          ),
                          alignment: Alignment.bottomCenter,
                        ),
                      );
                    },
                    child: const Text('Simpan Perubahan'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isResult = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isResult ? const Color(0xFFD946EF) : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ShadInput(
          controller: controller,
          placeholder: const Text("0.0"),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              size: 16,
              color: isResult ? const Color(0xFFD946EF) : Colors.grey,
            ),
          ),
          decoration: isResult
              ? ShadDecoration(
                  border: ShadBorder.all(
                    color: const Color(0xFFD946EF).withOpacity(0.5),
                  ),
                )
              : null,
        ),
      ],
    );
  }
}
