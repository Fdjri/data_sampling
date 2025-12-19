import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_image_compress/flutter_image_compress.dart';

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

  // List untuk menyimpan foto-foto mentah yang dipilih (maks 4)
  List<File> _selectedRawImages = [];
  // File hasil kolase yang sudah dikompres
  File? _collageImage;
  bool _isProcessingImage = false;

  @override
  void dispose() {
    _kondisiController.dispose();
    _detailKondisiController.dispose();
    _cuacaController.dispose();
    super.dispose();
  }

  // --- Image Picker & Collage ---
  // Menu Pilihan Saat Preview Diklik
  void _showImageOptionsSheet() {
    showShadSheet(
      context: context,
      side: ShadSheetSide.bottom,
      builder: (context) => ShadSheet(
        title: const Text("Kelola Dokumentasi"),
        description: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Anda telah memilih ${_selectedRawImages.length}/4 foto."),
            const Text(
              "Tap foto untuk mengganti, tap silang (x) untuk menghapus.",
              style: TextStyle(fontSize: 12, color: Colors.orange),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Preview Thumbnail Horizontal Interactive
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedRawImages.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Thumbnail Image (Tap to Replace)
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            _showReplaceSourceDialog(index);
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _selectedRawImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        // Delete Button (X)
                        Positioned(
                          top: -6,
                          right: -6,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _removeImageAt(index);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                LucideIcons.x,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Opsi 1: Tambah Foto (Hanya jika < 4)
              if (_selectedRawImages.length < 4) ...[
                ShadButton(
                  width: double.infinity,
                  backgroundColor: const Color(0xFF16A34A),
                  hoverBackgroundColor: const Color(0xFF15803D),
                  onPressed: () {
                    Navigator.pop(context);
                    _showAddImageSourceDialog();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.plus, size: 16, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Tambah Foto Lagi",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Opsi 2: Ganti Semua (Reset)
              ShadButton.outline(
                width: double.infinity,
                onPressed: () {
                  Navigator.pop(context);
                  _removeCollage();
                  _handleImageSelection();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.refreshCw, size: 16),
                    SizedBox(width: 8),
                    Text("Reset / Ganti Semua"),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Opsi 3: Lihat Full Preview
              ShadButton.ghost(
                width: double.infinity,
                onPressed: () {
                  Navigator.pop(context);
                  _showCollageDetail();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.eye, size: 16),
                    SizedBox(width: 8),
                    Text("Lihat Preview Full"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog untuk memilih sumber foto tambahan (Kamera/Galeri)
  void _showAddImageSourceDialog() {
    showShadSheet(
      context: context,
      side: ShadSheetSide.bottom,
      builder: (context) => ShadSheet(
        title: const Text("Tambah Foto"),
        description: const Text("Pilih sumber foto yang akan ditambahkan"),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadButton.outline(
                onPressed: () {
                  Navigator.pop(context);
                  _pickMoreImageCamera();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.camera, size: 16),
                    SizedBox(width: 8),
                    Text("Kamera"),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                onPressed: () {
                  Navigator.pop(context);
                  _pickMoreImages();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.image, size: 16),
                    SizedBox(width: 8),
                    Text("Galeri"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog Kecil untuk memilih sumber foto saat mengganti 1 gambar
  void _showReplaceSourceDialog(int index) {
    showShadSheet(
      context: context,
      side: ShadSheetSide.bottom,
      builder: (context) => ShadSheet(
        title: const Text("Ganti Foto"),
        description: const Text("Pilih sumber foto pengganti"),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadButton.outline(
                onPressed: () {
                  Navigator.pop(context);
                  _replaceImageAt(index, ImageSource.camera);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.camera, size: 16),
                    SizedBox(width: 8),
                    Text("Kamera"),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                onPressed: () {
                  Navigator.pop(context);
                  _replaceImageAt(index, ImageSource.gallery);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.image, size: 16),
                    SizedBox(width: 8),
                    Text("Galeri"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Core Image Logic Update ---
  Future<void> _replaceImageAt(int index, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedRawImages[index] = File(pickedFile.path);
          _processCollage();
        });
      }
    } catch (e) {
      _showErrorToast(e.toString());
    }
  }

  void _removeImageAt(int index) {
    setState(() {
      _selectedRawImages.removeAt(index);
      if (_selectedRawImages.isEmpty) {
        _collageImage = null;
      } else {
        _processCollage();
      }
    });
  }

  Future<void> _handleImageSelection() async {
    showShadSheet(
      context: context,
      side: ShadSheetSide.bottom,
      builder: (context) => ShadSheet(
        title: const Text("Upload Dokumentasi"),
        description: const Text(
          "Pilih 1-4 foto untuk dijadikan kolase otomatis",
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadButton.outline(
                onPressed: () {
                  Navigator.pop(context);
                  _pickMultipleImages();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.images, size: 16),
                    SizedBox(width: 8),
                    Text("Pilih Foto (Galeri)"),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImageCamera();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.camera, size: 16),
                    SizedBox(width: 8),
                    Text("Ambil Foto (Kamera)"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> pickedFiles = await picker.pickMultiImage(
        imageQuality: 80,
      );

      if (pickedFiles.isNotEmpty) {
        final limitedFiles = pickedFiles.take(4).toList();
        setState(() {
          _selectedRawImages = limitedFiles.map((e) => File(e.path)).toList();
          _processCollage();
        });
      }
    } catch (e) {
      _showErrorToast(e.toString());
    }
  }

  // Fungsi Initial Pick dari Kamera (Reset list)
  Future<void> _pickImageCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedRawImages = [File(pickedFile.path)];
          _processCollage();
        });
      }
    } catch (e) {
      _showErrorToast(e.toString());
    }
  }

  Future<void> _pickMoreImages() async {
    final ImagePicker picker = ImagePicker();
    try {
      int remainingSlots = 4 - _selectedRawImages.length;
      if (remainingSlots <= 0) return;
      final List<XFile> pickedFiles = await picker.pickMultiImage(
        imageQuality: 80,
      );
      if (pickedFiles.isNotEmpty) {
        final newFiles = pickedFiles
            .take(remainingSlots)
            .map((e) => File(e.path))
            .toList();
        setState(() {
          _selectedRawImages.addAll(newFiles);
          _processCollage();
        });
      }
    } catch (e) {
      _showErrorToast(e.toString());
    }
  }

  // Fungsi Tambahan: Menambah foto dari KAMERA ke list yang sudah ada
  Future<void> _pickMoreImageCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      if (_selectedRawImages.length >= 4) return;

      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedRawImages.add(File(pickedFile.path));
          _processCollage();
        });
      }
    } catch (e) {
      _showErrorToast(e.toString());
    }
  }

  // --- IMPLEMENTASI KOLASE & KOMPRESI ---
  Future<void> _processCollage() async {
    if (_selectedRawImages.isEmpty) return;

    setState(() {
      _isProcessingImage = true;
    });

    try {
      // 1. Decode semua gambar
      List<img.Image> decodedImages = [];
      for (var file in _selectedRawImages) {
        final bytes = await file.readAsBytes();
        final image = img.decodeImage(bytes);
        if (image != null) {
          // Resize & Crop menjadi kotak (600x600)
          final cropped = img.copyResizeCropSquare(image, size: 600);
          decodedImages.add(cropped);
        }
      }

      if (decodedImages.isEmpty) {
        throw Exception("Gagal memproses gambar (decode error).");
      }

      // 2. Tentukan Grid Canvas (1 col atau 2 cols)
      int columns = decodedImages.length == 1 ? 1 : 2;
      int rows = (decodedImages.length / columns).ceil();
      int cellWidth = 600;
      int cellHeight = 600;
      int canvasWidth = columns * cellWidth;
      int canvasHeight = rows * cellHeight;
      img.Image collage = img.Image(width: canvasWidth, height: canvasHeight);
      img.fill(collage, color: img.ColorRgb8(255, 255, 255));

      // 3. Gabungkan Gambar ke Canvas
      for (int i = 0; i < decodedImages.length; i++) {
        int x = (i % columns) * cellWidth;
        int y = (i ~/ columns) * cellHeight;
        img.compositeImage(collage, decodedImages[i], dstX: x, dstY: y);
      }

      // 4. Simpan ke Temporary Directory
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final rawPath = '${tempDir.path}/raw_collage_$timestamp.jpg';
      final rawFile = File(rawPath);
      await rawFile.writeAsBytes(img.encodeJpg(collage, quality: 90));

      // 5. Kompresi Hasil Akhir (Target < 1MB)
      final targetPath = '${tempDir.path}/final_collage_$timestamp.jpg';
      var result = await FlutterImageCompress.compressAndGetFile(
        rawFile.absolute.path,
        targetPath,
        quality: 75, // Atur Quality
        minWidth: 1200, // Resize
        minHeight: 1200,
      );

      File finalFile = result != null ? File(result.path) : rawFile;
      int fileSize = await finalFile.length();

      setState(() {
        _collageImage = finalFile;
        _isProcessingImage = false;
      });

      if (mounted) {
        String sizeKb = (fileSize / 1024).toStringAsFixed(0);
        debugPrint("Collage created: $sizeKb KB");
      }
    } catch (e) {
      debugPrint("Error making collage: $e");
      setState(() {
        _isProcessingImage = false;
      });
      _showErrorToast("Gagal memproses gambar: $e");
    }
  }

  void _removeCollage() {
    setState(() {
      _selectedRawImages.clear();
      _collageImage = null;
    });
  }

  // --- Show Detail Collage ---
  void _showCollageDetail() {
    if (_collageImage == null && _selectedRawImages.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Dialog
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Preview Kolase",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(LucideIcons.x, size: 24),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Image Preview
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_collageImage!, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ShadButton(
                  width: double.infinity,
                  backgroundColor: const Color(0xFF16A34A),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tutup"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorToast(String message) {
    if (mounted) {
      ShadToaster.of(context).show(
        ShadToast.destructive(
          title: const Text('Gagal Memproses'),
          description: Text(message),
          alignment: Alignment.bottomCenter,
        ),
      );
    }
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
              'DETAIL DATA SAMPLING',
              style: theme.textTheme.h4.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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

                  // --- Foto Titik Sampling Section ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Foto Titik Sampling",
                        style: theme.textTheme.small.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_selectedRawImages.isNotEmpty)
                        ShadBadge.secondary(
                          child: Text(
                            "${_selectedRawImages.length} Foto Dipilih",
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Widget Upload/Preview
                  GestureDetector(
                    // Logic: Jika sudah ada gambar, tap membuka options sheet
                    // Jika belum ada, buka image picker
                    onTap: _isProcessingImage
                        ? null
                        : (_collageImage != null
                              ? _showImageOptionsSheet
                              : _handleImageSelection),
                    child: _isProcessingImage
                        ? _buildProcessingIndicator() // Loading State
                        : (_collageImage != null
                              ? _buildCollagePreview(theme) // Result State
                              : _buildUploadPlaceholder(
                                  theme,
                                )), // Initial State
                  ),
                  if (_collageImage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "*Foto otomatis digabung & dikompres (< 1MB). Tap gambar untuk opsi lainnya.",
                        style: theme.textTheme.muted.copyWith(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
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
                    // Logic simpan data termasuk foto
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

  // --- Widget Helper: Processing Indicator ---
  Widget _buildProcessingIndicator() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(strokeWidth: 3),
          SizedBox(height: 16),
          Text(
            "Memproses Kolase...",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            "Menggabungkan & Mengompres gambar",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // --- Widget Helper: Upload Placeholder ---
  Widget _buildUploadPlaceholder(ShadThemeData theme) {
    return Container(
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
            "Upload Foto (Max 4)",
            style: theme.textTheme.small.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            "Otomatis dibuat kolase & dikompres",
            style: theme.textTheme.muted.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }

  // --- Widget Helper: Collage Preview (Thumbnail hasil jadi) ---
  Widget _buildCollagePreview(ShadThemeData theme) {
    return Container(
      height: 250,
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
      child: Stack(
        children: [
          // Gambar Hasil Kolase (file asli)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              _collageImage!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
            ),
          ),

          // Tombol Reset/Hapus (Pojok Kanan Atas)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                _removeCollage();
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.9),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  LucideIcons.trash2,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Label Info Kolase (Pojok Kiri Bawah) - Diupdate teksnya
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.settings2, size: 12, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    "Kelola Foto",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
