import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/status_chip.dart';

class BeritaScreen extends StatefulWidget {
  const BeritaScreen({super.key});

  @override
  State<BeritaScreen> createState() => _BeritaScreenState();
}

class _BeritaScreenState extends State<BeritaScreen> {
  List<Map<String, dynamic>>? _pengumuman;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ApiRepository.instance.getPengumuman();
      if (!mounted) return;
      setState(() {
        _pengumuman = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BlueHeader(title: 'Berita & Pengumuman'),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off,
                size: 48,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _load, child: const Text('Coba Lagi')),
            ],
          ),
        ),
      );
    }

    final list = _pengumuman ?? [];
    if (list.isEmpty) {
      return const Center(child: Text('Belum ada pengumuman.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _buildBeritaCard(list[index]),
    );
  }

  Widget _buildBeritaCard(Map<String, dynamic> pengumuman) {
    final kategori = (pengumuman['kategori'] ?? 'info') as String;
    final createdAt = pengumuman['created_at'] != null
        ? DateTime.tryParse(pengumuman['created_at'] as String)
        : null;

    Color categoryColor;
    String statusType;

    switch (kategori.toLowerCase()) {
      case 'pengumuman':
      case 'penting':
        categoryColor = AppColors.accentYellow;
        statusType = 'menunggu';
        break;
      case 'prestasi':
        categoryColor = AppColors.chipGreenText;
        statusType = 'selesai';
        break;
      case 'kegiatan':
        categoryColor = AppColors.chipPurpleText;
        statusType = 'kegiatan';
        break;
      default:
        categoryColor = AppColors.primaryBlue;
        statusType = 'info';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: categoryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusChip(label: kategori.toUpperCase(), type: statusType),
                    if (createdAt != null)
                      Text(
                        DateFormat('dd MMM yyyy').format(createdAt),
                        style: AppTextStyles.smallText,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  pengumuman['judul'] ?? '-',
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: 8),
                Text(
                  pengumuman['isi'] ?? '',
                  style: AppTextStyles.bodySecondary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
