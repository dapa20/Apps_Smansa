import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/section_header.dart';
import '../../widgets/surface_card.dart';
import '../../widgets/state_views.dart';

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
      body: Column(
        children: [
          BlueHeader(
            eyebrow: 'Pusat Belajar',
            title: 'Materi Pembelajaran',
            subtitle: 'Akses materi pelajaran dari guru Anda.',
            height: 112,
            showBackButton: true,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.folder_copy_rounded,
                    color: AppColors.accentCyan,
                    size: 13,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _loading ? 'Memuat' : '${_daftarMapel?.length ?? 0} mapel',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const AppLoadingView(message: 'Memuat daftar mata pelajaran...');
    }

    if (_error != null) {
      return AppErrorView(message: _error!, onRetry: _load);
    }

    final mapelList = _daftarMapel ?? [];
    if (mapelList.isEmpty) {
      return const AppEmptyView(
        icon: Icons.folder_off_rounded,
        title: 'Belum ada materi',
        subtitle: 'Belum ada materi untuk kelas Anda.',
      );
    }

    final hPad = AppConstants.responsivePadding(
      MediaQuery.of(context).size.width,
    );

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.primaryBlue,
      backgroundColor: Colors.white,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 28),
        itemCount: mapelList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: SectionHeader(
                title: 'Mata Pelajaran',
                subtitle: 'Pilih mapel untuk melihat materi',
                count: mapelList.length,
              ),
            );
          }
          return _buildMapelCard(mapelList[index - 1], index - 1);
        },
      ),
    );
  }

  Widget _buildMapelCard(Map<String, dynamic> mapel, int index) {
    const accents = [
      AppColors.primaryBlue,
      AppColors.accentTeal,
      AppColors.accentPurple,
      AppColors.accentAmber,
      AppColors.accentPink,
    ];
    final accent = accents[index % accents.length];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(21),
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
          margin: const EdgeInsets.only(bottom: 10),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: AppColors.borderSubtle, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 16,
                offset: const Offset(0, 6),
                spreadRadius: -8,
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: accent),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                    child: Row(
                      children: [
                        AppIconTile(
                          icon: Icons.menu_book_rounded,
                          color: accent,
                          size: 44,
                          iconSize: 21,
                          radius: 13,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mapel['nama_mapel'] ?? '-',
                                style: AppTextStyles.cardTitle.copyWith(
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline_rounded,
                                    size: 12,
                                    color: AppColors.textTertiary,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      mapel['nama_guru'] ?? '-',
                                      style: AppTextStyles.smallText.copyWith(
                                        fontSize: 10.5,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${mapel['jumlah_materi'] ?? 0}',
                            style: AppTextStyles.chipText.copyWith(
                              color: accent,
                              fontSize: 9.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textTertiary,
                            size: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
      body: Column(
        children: [
          BlueHeader(
            eyebrow: 'Materi Pelajaran',
            title: mapel?['nama_mapel']?.toString() ?? 'Detail Materi',
            subtitle:
                mapel?['nama_guru']?.toString() ??
                'Materi pembelajaran dari guru.',
            height: 104,
            showBackButton: true,
            trailing: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              ),
              child: const Icon(
                Icons.folder_open_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const AppLoadingView(message: 'Memuat materi...');
    }

    if (_error != null) {
      return AppErrorView(message: _error!, onRetry: _load);
    }

    final mapel = _data?['mapel'] as Map<String, dynamic>?;
    final sections = (_data?['sections'] as List?) ?? [];

    if (sections.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.responsivePadding(
                MediaQuery.of(context).size.width,
              ),
            ),
            child: _buildMapelHero(mapel, 0),
          ),
          const Expanded(
            child: AppEmptyView(
              icon: Icons.folder_open_rounded,
              title: 'Belum ada materi pada mapel ini',
              subtitle: 'Materi akan muncul setelah guru mengunggahnya.',
            ),
          ),
        ],
      );
    }

    final hPad = AppConstants.responsivePadding(
      MediaQuery.of(context).size.width,
    );

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.primaryBlue,
      backgroundColor: Colors.white,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(hPad, 18, hPad, 28),
        children: [
          _buildMapelHero(mapel, sections.length),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Bagian Materi',
            subtitle: 'Susun materi sesuai urutan belajar',
            count: sections.length,
          ),
          const SizedBox(height: 12),
          ...sections.map((section) {
            final s = section as Map<String, dynamic>;
            final items = (s['items'] as List?) ?? [];
            return _buildSectionCard(s, items);
          }),
        ],
      ),
    );
  }

  Widget _buildMapelHero(Map<String, dynamic>? mapel, int sectionCount) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B1B45), Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.20),
            blurRadius: 24,
            offset: const Offset(0, 10),
            spreadRadius: -10,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentCyan.withValues(alpha: 0.10),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mapel?['nama_mapel']?.toString() ?? '-',
                      style: AppTextStyles.headerTitle.copyWith(
                        fontSize: 17,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mapel?['nama_guru']?.toString() ?? '-',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.62),
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '$sectionCount',
                      style: AppTextStyles.cardTitle.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'bagian',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 7.5,
                      ),
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

  Widget _buildSectionCard(Map<String, dynamic> section, List<dynamic> items) {
    return SurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
            child: Row(
              children: [
                const AppIconTile(
                  icon: Icons.folder_rounded,
                  color: AppColors.accentAmber,
                  size: 36,
                  iconSize: 18,
                  radius: 11,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    section['judul'] ?? 'Section',
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 13.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${items.length} item',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                'Belum ada item di bagian ini.',
                style: AppTextStyles.smallText.copyWith(fontSize: 11),
              ),
            )
          else
            ...items.map((item) {
              final it = item as Map<String, dynamic>;
              return _buildItemRow(it);
            }),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  Widget _buildItemRow(Map<String, dynamic> item) {
    IconData icon;
    Color accent;
    String typeLabel;

    switch (item['tipe']) {
      case 'file':
        icon = Icons.insert_drive_file_rounded;
        accent = AppColors.primaryBlue;
        typeLabel = 'FILE';
        break;
      case 'link':
        icon = Icons.link_rounded;
        accent = AppColors.accentPurple;
        typeLabel = 'LINK';
        break;
      case 'video':
        icon = Icons.play_circle_outline_rounded;
        accent = AppColors.dangerRed;
        typeLabel = 'VIDEO';
        break;
      default:
        icon = Icons.description_rounded;
        accent = AppColors.accentTeal;
        typeLabel = 'MATERI';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final url = item['url_file'] as String?;
          final link = item['url_link'] as String?;
          if (url != null && url.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Membuka: ${item['judul'] ?? 'file'}'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (link != null && link.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Membuka link: ${item['judul'] ?? 'materi'}'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 12, 14, 12),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: accent, size: 19),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['judul'] ?? '-',
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 12.5),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if ((item['deskripsi'] ?? '').toString().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        item['deskripsi'].toString(),
                        style: AppTextStyles.smallText.copyWith(fontSize: 10.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    typeLabel,
                    style: AppTextStyles.chipText.copyWith(
                      color: accent,
                      fontSize: 7.5,
                      letterSpacing: 0.7,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textTertiary,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
