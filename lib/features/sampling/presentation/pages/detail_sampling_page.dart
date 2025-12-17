import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DetailSamplingPage extends StatefulWidget {
  const DetailSamplingPage({super.key});

  @override
  State<DetailSamplingPage> createState() => _DetailSamplingPageState();
}

class _DetailSamplingPageState extends State<DetailSamplingPage> {
  // Sampling Details Controllers
  final _namaContohUjiController = TextEditingController();
  final _petugasController = TextEditingController(text: "Rian Ivanda Nanta");
  final _metodeSamplingController = TextEditingController();
  final _volumeContohController = TextEditingController();
  final _wadahController = TextEditingController();
  final _pengawetanController = TextEditingController();

  // Location Data Controllers
  final _tipeLokasiController = TextEditingController();
  final _badanAirController = TextEditingController();
  final _namaSungaiController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();

  // Date & Time State
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _namaContohUjiController.dispose();
    _petugasController.dispose();
    _metodeSamplingController.dispose();
    _pengawetanController.dispose();
    _tipeLokasiController.dispose();
    _badanAirController.dispose();
    _namaSungaiController.dispose();
    _latController.dispose();
    _longController.dispose();
    super.dispose();
  }

  void _showTodoToast(String title) {
    ShadToaster.of(context).show(
      ShadToast(
        title: Text('$title Belum Tersedia'),
        description: const Text('Fitur ini masih dalam tahap pengembangan.'),
        alignment: Alignment.bottomCenter,
      ),
    );
  }

  void _handleFinalSubmit() {
    bool isSamplingValid =
        _namaContohUjiController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null &&
        _metodeSamplingController.text.isNotEmpty;

    bool isLocationValid =
        _tipeLokasiController.text.isNotEmpty &&
        _latController.text.isNotEmpty &&
        _longController.text.isNotEmpty;

    if (!isSamplingValid || !isLocationValid) {
      ShadToaster.of(context).show(
        const ShadToast.destructive(
          title: Text('Data Belum Lengkap'),
          description: Text('Mohon lengkapi seluruh data sampling dan lokasi.'),
          alignment: Alignment.bottomCenter,
        ),
      );
      return;
    }

    ShadToaster.of(context).show(
      const ShadToast(
        title: Text('Data Berhasil Disimpan'),
        description: Text('Seluruh rangkaian data sampling telah tercatat.'),
        alignment: Alignment.bottomCenter,
        backgroundColor: Color(0xFF16A34A),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        if (context.canPop()) context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(theme),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                children: [
                  const SizedBox(height: 12),
                  _buildLogisticsSection(context),

                  const SizedBox(height: 32),

                  _buildSectionHeader(theme, "Informasi Umum"),
                  const SizedBox(height: 12),
                  _buildGeneralInfoSection(theme),

                  const SizedBox(height: 32),

                  _buildSectionHeader(theme, "Detail Sampling"),
                  const SizedBox(height: 12),
                  _buildSamplingDetailsSection(theme),

                  const SizedBox(height: 32),

                  _buildSectionHeader(theme, "Data Lokasi"),
                  const SizedBox(height: 12),
                  _buildLocationDataSection(theme),

                  const SizedBox(height: 40),
                ],
              ),
            ),
            _buildStickyBottomButton(theme),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ShadThemeData theme) {
    return AppBar(
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
            'EDIT DATA SAMPLING',
            style: theme.textTheme.h4.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'No. Ref: #SMP-2024-X12',
            style: theme.textTheme.muted.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ShadThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.h4.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: Colors.black87,
      ),
    );
  }

  // --- Section 1: General Info (Read Only) ---
  Widget _buildGeneralInfoSection(ShadThemeData theme) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(theme, "Jenis Pengajuan", "Air"),
          const Divider(height: 24),
          _buildInfoRow(theme, "Tipe Pengajuan", "Sampling Air Limbah"),
          const Divider(height: 24),
          _buildInfoRow(theme, "Output Hasil Uji", "Lampiran 2 + LD"),
          const Divider(height: 24),
          _buildInfoRow(theme, "Baku Mutu", "-"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(ShadThemeData theme, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: theme.textTheme.muted.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: theme.textTheme.small.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // --- Section 2: Sampling Details ---
  Widget _buildSamplingDetailsSection(ShadThemeData theme) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputLabel("Nama Contoh Uji"),
          ShadInput(
            controller: _namaContohUjiController,
            placeholder: const Text("Contoh: Air Inlet IPAL"),
          ),
          const SizedBox(height: 16),
          _buildInputLabel("Petugas Sampling"),
          ShadInput(
            controller: _petugasController,
            enabled: false,
            readOnly: true,
            decoration: ShadDecoration(
              border: ShadBorder.all(color: Colors.grey, width: 0.5),
            ),
            trailing: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(LucideIcons.user, size: 20, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          _buildInputLabel("Metode Sampling"),
          ShadInput(
            controller: _metodeSamplingController,
            placeholder: const Text("Contoh: SNI 6989.59:2008"),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel("Tanggal"),
                    ShadDatePicker(
                      selected: _selectedDate,
                      placeholder: const Text("Pilih Tgl"),
                      formatDate: (date) =>
                          DateFormat('dd/MM/yyyy').format(date),
                      onChanged: (date) => setState(() => _selectedDate = date),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel("Waktu"),
                    SizedBox(
                      width: double.infinity,
                      child: ShadTimePicker(
                        initialValue: _selectedTime != null
                            ? ShadTimeOfDay(
                                hour: _selectedTime!.hour,
                                minute: _selectedTime!.minute,
                                second: 0,
                              )
                            : null,
                        alignment: WrapAlignment.start,
                        onChanged: (time) {
                          if (time != null) {
                            setState(() {
                              _selectedTime = TimeOfDay(
                                hour: time.hour,
                                minute: time.minute,
                              );
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel("Volume Contoh"),
                    ShadInput(
                      controller: _volumeContohController,
                      placeholder: const Text("Contoh: 1 Liter"),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel("Wadah"),
                    ShadInput(
                      controller: _wadahController,
                      placeholder: const Text("Contoh: Botol Kaca"),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInputLabel("Pengawetan"),
          ShadInput(
            controller: _pengawetanController,
            placeholder: const Text("Contoh: H2SO4 sampai pH < 2"),
          ),
        ],
      ),
    );
  }

  // --- Section 3: Location Data ---
  Widget _buildLocationDataSection(ShadThemeData theme) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputLabel("Tipe Lokasi"),
          ShadInput(
            controller: _tipeLokasiController,
            placeholder: const Text("Contoh: Sungai, Outlet, Inlet"),
            trailing: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(LucideIcons.mapPin, size: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),

          _buildInputLabel("Badan Air Penerima"),
          ShadInput(
            controller: _badanAirController,
            placeholder: const Text("Contoh: Sungai Brantas"),
          ),
          const SizedBox(height: 16),

          _buildInputLabel("Nama Sungai / Drainase Jalan"),
          ShadInput(
            controller: _namaSungaiController,
            placeholder: const Text("Masukkan nama sungai/drainase"),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel("Latitude"),
                    ShadInput(
                      controller: _latController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      placeholder: const Text("-7.1234"),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel("Longitude"),
                    ShadInput(
                      controller: _longController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      placeholder: const Text("112.5678"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildLogisticsSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ShadButton.outline(
            onPressed: () => _showTodoToast("Data Alat"),
            foregroundColor: Colors.orange,
            decoration: ShadDecoration(
              border: ShadBorder.all(color: Colors.orange, width: 1),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.briefcase, size: 16),
                SizedBox(width: 8),
                Text("Data Alat"),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ShadButton.outline(
            onPressed: () => _showTodoToast("Data Kendaraan"),
            foregroundColor: Colors.blue,
            decoration: ShadDecoration(
              border: ShadBorder.all(color: Colors.blue, width: 1),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.carFront, size: 16),
                SizedBox(width: 8),
                Text("Kendaraan"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStickyBottomButton(ShadThemeData theme) {
    return Container(
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
          onPressed: _handleFinalSubmit,
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
                "Simpan & Selesai",
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
    );
  }
}
