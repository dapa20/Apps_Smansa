import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/mock_data.dart';
import '../../models/portal_item.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_header.dart';
import '../../widgets/back_button_overlay.dart';

class SmansagoScreen extends StatelessWidget {
  const SmansagoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const BackLeadingButton(),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          AppConstants.appName,
          style: AppTextStyles.cardTitle.copyWith(
            color: AppColors.primaryBlue,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const BlueHeader(
                  title: 'SMANSAGO',
                  subtitle: 'Digital Hub SMAN 1',
                  height: 180,
                ),
                Positioned(
                  bottom: -24,
                  left: 0,
                  right: 0,
                  child: const SearchBarWidget(
                    hint: 'Cari tautan atau portal...',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildMainPortalCard(),
            ),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.1,
                ),
                itemCount: MockSmansago.portals.length,
                itemBuilder: (context, index) {
                  return _buildGridPortalCard(MockSmansago.portals[index]);
                },
              ),
            ),

            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(title: 'Sosial Media Resmi'),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMainPortalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryBlueTint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: AppColors.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Portal E-Learning', style: AppTextStyles.cardTitle),
                const SizedBox(height: 4),
                Text(
                  'Akses materi dan tugas online',
                  style: AppTextStyles.smallText,
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textSecondary,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridPortalCard(PortalItem portal) {
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  getIcon(portal.ikonName),
                  color: AppColors.primaryBlue,
                  size: 22,
                ),
              ),
              if (portal.hasNotification)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.dangerRed,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(portal.judul, style: AppTextStyles.cardTitle),
          const SizedBox(height: 4),
          Text(
            portal.deskripsi,
            style: AppTextStyles.smallText,
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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              shape: BoxShape.circle,
            ),
            child: Icon(
              getIcon(social['icon']!),
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(social['nama']!, style: AppTextStyles.smallText),
        ],
      ),
    );
  }
}