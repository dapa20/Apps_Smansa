import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/mock_data.dart';
import '../../models/portal_item.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_header.dart';
import '../../widgets/surface_card.dart';

class SmansagoScreen extends StatelessWidget {
  const SmansagoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hPad = AppConstants.responsivePadding(
      MediaQuery.of(context).size.width,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                BlueHeader(
                  eyebrow: 'Digital Hub',
                  title: 'SMANSAGo',
                  subtitle: 'Satu pintu untuk semua layanan digital sekolah.',
                  height: 128,
                  showBackButton: true,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.accentMint,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'ONLINE',
                          style: AppTextStyles.chipText.copyWith(
                            color: Colors.white,
                            fontSize: 8.5,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  bottom: -27,
                  left: 0,
                  right: 0,
                  child: SearchBarWidget(hint: 'Cari tautan atau portal...'),
                ),
              ],
            ),
            const SizedBox(height: 48),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: _buildMainPortalCard(),
            ),
            const SizedBox(height: 26),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: const SectionHeader(
                title: 'Jelajahi Layanan',
                subtitle: 'Portal resmi dan kegiatan sekolah',
                count: 4,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 560 ? 3 : 2;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 146,
                    ),
                    itemCount: MockSmansago.portals.length,
                    itemBuilder: (context, index) {
                      return _buildGridPortalCard(
                        MockSmansago.portals[index],
                        index,
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: const SectionHeader(
                title: 'Sosial Media Resmi',
                subtitle: 'Ikuti kabar terbaru dari sekolah',
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Row(
                children: MockSmansago.socialMedia.map((social) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildSocialCard(social),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildMainPortalCard() {
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
            color: AppColors.navy.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 11),
            spreadRadius: -10,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -46,
            right: -34,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentCyan.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -55,
            right: 20,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
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
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentAmber.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'UTAMA',
                        style: AppTextStyles.chipText.copyWith(
                          color: AppColors.accentAmber,
                          fontSize: 7.5,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Portal E-Learning',
                      style: AppTextStyles.headerTitle.copyWith(
                        fontSize: 17,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Akses materi, tugas, dan ujian online.',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.62),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.primaryBlue,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridPortalCard(PortalItem portal, int index) {
    const accents = [
      AppColors.primaryBlue,
      AppColors.accentTeal,
      AppColors.accentPurple,
      AppColors.accentAmber,
    ];
    final accent = accents[index % accents.length];

    IconData getIcon(String name) {
      switch (name) {
        case 'assignment':
          return Icons.assignment_rounded;
        case 'menu_book':
          return Icons.menu_book_rounded;
        case 'sports_basketball':
          return Icons.sports_basketball_rounded;
        case 'campaign':
          return Icons.campaign_rounded;
        default:
          return Icons.widgets_rounded;
      }
    }

    return SurfaceCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AppIconTile(
                    icon: getIcon(portal.ikonName),
                    color: accent,
                    size: 40,
                    iconSize: 19,
                    radius: 12,
                  ),
                  if (portal.hasNotification)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: AppColors.dangerRed,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.north_east_rounded,
                  color: AppColors.textTertiary,
                  size: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            portal.judul,
            style: AppTextStyles.cardTitle.copyWith(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            portal.deskripsi,
            style: AppTextStyles.smallText.copyWith(fontSize: 10.5),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialCard(Map<String, String> social) {
    IconData getIcon(String name) {
      switch (name) {
        case 'camera_alt':
          return Icons.camera_alt_outlined;
        case 'play_circle':
          return Icons.play_circle_outline_rounded;
        case 'language':
          return Icons.language_rounded;
        default:
          return Icons.link_rounded;
      }
    }

    Color getColor(String name) {
      switch (name) {
        case 'camera_alt':
          return AppColors.accentPink;
        case 'play_circle':
          return AppColors.dangerRed;
        case 'language':
          return AppColors.primaryBlue;
        default:
          return AppColors.textSecondary;
      }
    }

    final accent = getColor(social['icon']!);

    return SurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: accent.withValues(alpha: 0.12)),
            ),
            child: Icon(getIcon(social['icon']!), color: accent, size: 20),
          ),
          const SizedBox(height: 9),
          Text(
            social['nama']!,
            style: AppTextStyles.smallText.copyWith(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
