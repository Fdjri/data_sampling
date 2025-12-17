import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:data_sampling/features/sampling/presentation/pages/contoh_uji_page.dart';
import 'package:data_sampling/features/sampling/presentation/pages/detail_sampling_page.dart';
import '../widgets/parameter_insitu_card_widget.dart';

class SamplingEditPage extends StatefulWidget {
  const SamplingEditPage({super.key});

  @override
  State<SamplingEditPage> createState() => _SamplingEditPageState();
}

class _SamplingEditPageState extends State<SamplingEditPage> {
  final Map<String, Map<String, String>> _dataParameter = {
    'ph': {
      'title': 'pH',
      'method': 'SNI 6989.11:2019',
      'unit': '',
      'simplo': '5.59',
      'duplo': '5.58',
      'hasil': '5.58',
    },
    'suhu': {
      'title': 'Suhu',
      'method': 'SNI 06-6989.23-2025',
      'unit': '°C',
      'simplo': '26',
      'duplo': '26',
      'hasil': '26',
    },
    'do': {
      'title': 'Oksigen Terlarut (DO)',
      'method': 'SM APHA, 24th Ed, 5210B, 2023',
      'unit': 'mg/L',
      'simplo': '5.00',
      'duplo': '4.96',
      'hasil': '4.98',
    },
    'kekeruhan': {
      'title': 'Kekeruhan',
      'method': 'SNI 06-6989.25-2005',
      'unit': 'NTU',
      'simplo': '0.96',
      'duplo': '0.96',
      'hasil': '0.96',
    },
    'dhl': {
      'title': 'Daya Hantar Listrik',
      'method': 'SNI 6989.1 : 2019',
      'unit': 'µS/cm',
      'simplo': '701.4',
      'duplo': '701.6',
      'hasil': '701.5',
    },
  };

  final _kondisiController = TextEditingController(text: "Jernih");
  final _detailKondisiController = TextEditingController();
  final _cuacaController = TextEditingController(text: "Cerah");

  @override
  void dispose() {
    _kondisiController.dispose();
    _detailKondisiController.dispose();
    _cuacaController.dispose();
    super.dispose();
  }

  void _updateData(String key, String simplo, String duplo, String hasil) {
    setState(() {
      _dataParameter[key]!['simplo'] = simplo;
      _dataParameter[key]!['duplo'] = duplo;
      _dataParameter[key]!['hasil'] = hasil;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        surfaceTintColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            Text(
              'EDIT DATA SAMPLING',
              style: theme.textTheme.h4.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Teks putih
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Ref: 010006/LAB.3LC/XII/2025",
              style: theme.textTheme.muted.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // --- Header Section ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Parameter Insitu",
                        style: theme.textTheme.h3.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ShadButton.outline(
                        size: ShadButtonSize.sm,
                        foregroundColor: Colors.blue,
                        decoration: ShadDecoration(
                          border: ShadBorder.all(color: Colors.blue, width: 1),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ContohUjiPage(),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.flaskConical, size: 14),
                            SizedBox(width: 8),
                            Text("Contoh Uji"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- List of Cards ---
                  ..._dataParameter.entries.map((entry) {
                    final key = entry.key;
                    final data = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ParameterItemCard(
                        title: data['title']!,
                        method: data['method']!,
                        unit: data['unit']!,
                        simploValue: data['simplo']!,
                        duploValue: data['duplo']!,
                        resultValue: data['hasil']!,
                        onSave: (s, d, h) => _updateData(key, s, d, h),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  // --- Informasi Tambahan Section ---
                  Text(
                    "Informasi Tambahan",
                    style: theme.textTheme.h3.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ShadCard(
                    padding: const EdgeInsets.all(20),
                    radius: BorderRadius.circular(16),
                    border: ShadBorder.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
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
                        _buildInfoField(
                          "Kondisi",
                          _kondisiController,
                          icon: LucideIcons.droplet,
                          placeholder: "Contoh: Jernih, Keruh...",
                        ),
                        const SizedBox(height: 20),
                        _buildInfoField(
                          "Detail Kondisi Contoh",
                          _detailKondisiController,
                          icon: LucideIcons.fileText,
                          placeholder: "Deskripsi detail...",
                          maxLines: 3,
                        ),
                        const SizedBox(height: 20),
                        _buildInfoField(
                          "Kondisi Cuaca",
                          _cuacaController,
                          icon: LucideIcons.cloudSun,
                          placeholder: "Contoh: Cerah, Hujan...",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Foto Titik Sampling",
                    style: theme.textTheme.small.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.camera,
                            size: 24,
                            color: Colors.blue.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Upload Foto Lapangan",
                          style: theme.textTheme.small.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Maksimal 2MB (JPG/PNG)",
                          style: theme.textTheme.muted.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            // --- Sticky Bottom Button ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ShadButton(
                  size: ShadButtonSize.lg,
                  backgroundColor: const Color(0xFF16A34A),
                  hoverBackgroundColor: const Color(0xFF15803D),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailSamplingPage(),
                      ),
                    );
                  },
                  shadows: [
                    BoxShadow(
                      color: const Color(0xFF16A34A).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.save, size: 18, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Simpan Semua Data",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    String? placeholder,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const Text(" *", style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 10),
        ShadInput(
          controller: controller,
          placeholder: placeholder != null ? Text(placeholder) : null,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          maxLines: maxLines,
          minLines: maxLines > 1 ? 2 : 1,
        ),
      ],
    );
  }
}
