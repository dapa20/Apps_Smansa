import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/back_button_overlay.dart';

class MateriScreen extends StatefulWidget {
  const MateriScreen({super.key});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  List<Map<String, dynamic>>? _daftarMapel;
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
      final data = await ApiRepository.instance.getMateriDaftarMapel();
      if (!mounted) return;
      setState(() {
        _daftarMapel = data;
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackLeadingButton(),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(AppConstants.appName, style: AppTextStyles.cardTitle),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const BlueHeader(
            title: 'Materi Pembelajaran',
            subtitle: 'Akses materi pelajaran dari guru Anda',
            height: 140,
          ),
          Expanded(child: _buildBody()),
        ],
      ),
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

    final mapelList = _daftarMapel ?? [];
    if (mapelList.isEmpty) {
      return const Center(child: Text('Belum ada materi untuk kelas Anda.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: mapelList.length,
      itemBuilder: (context, index) {
        final mapel = mapelList[index];
        return _buildMapelCard(mapel);
      },
    );
  }

  Widget _buildMapelCard(Map<String, dynamic> mapel) {
    return GestureDetector(
      onTap: () {
        final id = mapel['id'];
        if (id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MateriDetailScreen(mapelId: id as int),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          border: const Border(
            left: BorderSide(
              color: AppColors.primaryBlue,
              width: AppConstants.leftBorderWidth,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.chipBlueBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.menu_book,
                color: AppColors.primaryBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mapel['nama_mapel'] ?? '-',
                    style: AppTextStyles.cardTitle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mapel['nama_guru'] ?? '',
                    style: AppTextStyles.smallText,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.chipBlueBg,
                    borderRadius: BorderRadius.circular(
                      AppConstants.chipRadius,
                    ),
                  ),
                  child: Text(
                    '${mapel['jumlah_materi'] ?? 0} Materi',
                    style: AppTextStyles.chipText.copyWith(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MateriDetailScreen extends StatefulWidget {
  final int mapelId;

  const MateriDetailScreen({super.key, required this.mapelId});

  @override
  State<MateriDetailScreen> createState() => _MateriDetailScreenState();
}

class _MateriDetailScreenState extends State<MateriDetailScreen> {
  Map<String, dynamic>? _data;
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
      final data = await ApiRepository.instance.getMateriDetail(widget.mapelId);
      if (!mounted) return;
      setState(() {
        _data = data;
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
    final mapel = _data?['mapel'] as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackLeadingButton(),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          mapel?['nama_mapel'] ?? 'Materi',
          style: AppTextStyles.cardTitle,
        ),
      ),
      body: _buildBody(),
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

    final mapel = _data?['mapel'] as Map<String, dynamic>?;
    final sections = (_data?['sections'] as List?) ?? [];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.school, color: AppColors.primaryBlue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mapel?['nama_mapel'] ?? '-',
                      style: AppTextStyles.cardTitle,
                    ),
                    Text(
                      mapel?['nama_guru'] ?? '',
                      style: AppTextStyles.smallText,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (sections.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: Text('Belum ada materi pada mapel ini.')),
          )
        else
          ...sections.map((section) {
            final s = section as Map<String, dynamic>;
            final items = (s['items'] as List?) ?? [];
            return _buildSectionCard(s, items);
          }),
      ],
    );
  }

  Widget _buildSectionCard(Map<String, dynamic> section, List<dynamic> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.folder, color: AppColors.accentYellow),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    section['judul'] ?? 'Section',
                    style: AppTextStyles.cardTitle,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ...items.map((item) {
            final it = item as Map<String, dynamic>;
            return _buildItemRow(it);
          }),
        ],
      ),
    );
  }

  Widget _buildItemRow(Map<String, dynamic> item) {
    IconData icon;
    switch (item['tipe']) {
      case 'file':
        icon = Icons.insert_drive_file;
        break;
      case 'link':
        icon = Icons.link;
        break;
      case 'video':
        icon = Icons.play_circle;
        break;
      default:
        icon = Icons.description;
    }

    return InkWell(
      onTap: () {
        final url = item['url_file'] as String?;
        final link = item['url_link'] as String?;
        if (url != null && url.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Membuka: ${item['judul'] ?? 'file'}')),
          );
        } else if (link != null && link.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Membuka link: ${item['judul'] ?? 'materi'}'),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryBlue, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['judul'] ?? '-',
                    style: AppTextStyles.bodyText.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if ((item['deskripsi'] ?? '').toString().isNotEmpty)
                    Text(
                      item['deskripsi'].toString(),
                      style: AppTextStyles.smallText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
