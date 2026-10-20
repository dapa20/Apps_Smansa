import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/surface_card.dart';
import '../../widgets/state_views.dart';
import '../../models/event_kalender.dart';

class KalenderScreen extends StatefulWidget {
  const KalenderScreen({super.key});

  @override
  State<KalenderScreen> createState() => _KalenderScreenState();
}

class _KalenderScreenState extends State<KalenderScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  List<EventKalender> _events = [];
  bool _loading = true;
  String? _error;
  String _subtitle = 'Tahun Ajaran Aktif';

  // Rentang kalender dinamis mengikuti tahun berjalan
  late final DateTime _firstDay;
  late final DateTime _lastDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDay = now;
    _selectedDay = now;
    _firstDay = DateTime(now.year, 1, 1);
    _lastDay = DateTime(now.year, 12, 31);
    initializeDateFormatting('id_ID', null).then((_) {
      if (mounted) setState(() {});
    });
    _load();
  }

  /// Ambil event kalender dari backend (realtime).
  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ApiRepository.instance.getKalender();
      final rawEvents = (data['events'] as List? ?? [])
          .cast<Map<String, dynamic>>();
      final subtitle =
          'Tahun Ajaran ${data['tahun_ajaran'] ?? ''} '
          '- Semester ${data['semester'] ?? 'Ganjil'}'
          ' — ${data['nama_kelas'] ?? ''}';

      if (!mounted) return;
      setState(() {
        _events = rawEvents.map(_parseEvent).toList();
        _subtitle = subtitle.trim();
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

  EventKalender _parseEvent(Map<String, dynamic> json) {
    DateTime parseTgl(String? s) {
      final d = DateTime.tryParse(s ?? '');
      return d ?? _focusedDay;
    }

    return EventKalender(
      tanggalMulai: parseTgl(json['tanggal_mulai'] as String?),
      tanggalSelesai: parseTgl(json['tanggal_selesai'] as String?),
      judul: (json['judul'] ?? '-') as String,
      kategori: (json['kategori'] ?? 'kegiatan') as String,
      waktu: json['waktu'] as String?,
      lokasi: json['lokasi'] as String?,
      deskripsi: json['deskripsi'] as String?,
    );
  }

  List<EventKalender> _getEventsForDay(DateTime day) {
    return _events.where((event) {
      final start = DateTime(
        event.tanggalMulai.year,
        event.tanggalMulai.month,
        event.tanggalMulai.day,
      );
      final end = DateTime(
        event.tanggalSelesai.year,
        event.tanggalSelesai.month,
        event.tanggalSelesai.day,
      );
      final check = DateTime(day.year, day.month, day.day);
      return check.isAtSameMomentAs(start) ||
          check.isAtSameMomentAs(end) ||
          (check.isAfter(start) && check.isBefore(end));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _load,
        color: AppColors.primaryBlue,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlueHeader(
                eyebrow: 'Rencana Akademik',
                title: 'Kalender Akademik',
                subtitle: _subtitle,
                height: 118,
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
                      const Icon(
                        Icons.event_available_rounded,
                        color: AppColors.accentCyan,
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _loading ? 'Memuat' : '${_events.length} agenda',
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
              const SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.responsivePadding(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                child: _buildCalendar(),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.responsivePadding(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                child: SectionHeader(
                  title: 'Agenda Mendatang',
                  subtitle: 'Jadwal penting yang perlu kamu tahu',
                  actionLabel: 'Muat Ulang',
                  onActionTap: _load,
                ),
              ),
              const SizedBox(height: 12),
              _buildAgendaList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
      child: TableCalendar<EventKalender>(
        firstDay: _firstDay,
        lastDay: _lastDay,
        focusedDay: _focusedDay,
        locale: 'id_ID',
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        eventLoader: _getEventsForDay,
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          headerPadding: const EdgeInsets.symmetric(vertical: 8),
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
          leftChevronIcon: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: AppColors.textSecondary,
              size: 19,
            ),
          ),
          rightChevronIcon: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 19,
            ),
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w700,
            fontSize: 10.5,
          ),
          weekendStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w700,
            fontSize: 10.5,
          ),
        ),
        calendarStyle: CalendarStyle(
          cellMargin: const EdgeInsets.all(5.0),
          outsideDaysVisible: false,
          defaultDecoration: const BoxDecoration(shape: BoxShape.circle),
          weekendDecoration: const BoxDecoration(shape: BoxShape.circle),
          defaultTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          weekendTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          selectedDecoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.primaryGradient,
            ),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 12.5,
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          todayTextStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w800,
            fontSize: 12.5,
          ),
          markerDecoration: const BoxDecoration(
            color: AppColors.primaryBlue,
            shape: BoxShape.circle,
          ),
          markerSize: 4.0,
          markersAlignment: Alignment.bottomCenter,
          markerMargin: const EdgeInsets.only(top: 2),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            if (events.isEmpty) return null;
            final visible = events.take(3).toList();
            return Positioned(
              bottom: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: visible
                    .map(
                      (event) => Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: _categoryColor(event.kategori),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAgendaList() {
    if (_loading) {
      return const AppLoadingView(
        message: 'Memuat agenda akademik...',
        compact: true,
      );
    }

    if (_error != null) {
      return AppErrorView(message: _error!, onRetry: _load);
    }

    if (_events.isEmpty) {
      return const AppEmptyView(
        icon: Icons.event_note_rounded,
        title: 'Belum ada agenda',
        subtitle: 'Belum ada agenda pada tahun ini.',
      );
    }

    final today = DateTime.now();
    // Tampilkan agenda dari hari ini & mendatang saja
    final upcoming = _events.where((e) {
      return !e.tanggalSelesai.isBefore(
        DateTime(today.year, today.month, today.day),
      );
    }).toList();
    final list = upcoming.isEmpty ? _events : upcoming;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.responsivePadding(
          MediaQuery.of(context).size.width,
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < list.length; i++) ...[
            _buildEventCard(list[i]),
            if (i != list.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _buildEventCard(EventKalender event) {
    final formatterDay = DateFormat('dd');
    final formatterMonth = DateFormat('MMM');

    String dateStr = formatterDay.format(event.tanggalMulai);
    if (!isSameDay(event.tanggalMulai, event.tanggalSelesai)) {
      dateStr += '-${formatterDay.format(event.tanggalSelesai)}';
    }

    final accent = _categoryColor(event.kategori);

    return SurfaceCard(
      padding: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 66,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(21),
                bottomLeft: Radius.circular(21),
              ),
              border: Border(
                right: BorderSide(color: accent.withValues(alpha: 0.12)),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dateStr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: accent,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  formatterMonth.format(event.tanggalMulai).toUpperCase(),
                  style: AppTextStyles.caption.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w800,
                    fontSize: 8.5,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          event.judul,
                          style: AppTextStyles.cardTitle.copyWith(
                            fontSize: 13.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusChip(
                        label: event.kategori.toUpperCase(),
                        type: event.kategori,
                      ),
                    ],
                  ),
                  if (event.waktu != null) ...[
                    const SizedBox(height: 8),
                    _buildMeta(Icons.access_time_rounded, event.waktu!, accent),
                  ],
                  if (event.lokasi != null) ...[
                    const SizedBox(height: 5),
                    _buildMeta(
                      Icons.location_on_outlined,
                      event.lokasi!,
                      accent,
                    ),
                  ],
                  if (event.deskripsi != null &&
                      event.deskripsi!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      event.deskripsi!,
                      style: AppTextStyles.smallText.copyWith(
                        fontSize: 10.5,
                        height: 1.45,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeta(IconData icon, String text, Color accent) {
    return Row(
      children: [
        Icon(icon, size: 12, color: accent.withValues(alpha: 0.8)),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              fontSize: 9.5,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _categoryColor(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'akademik':
        return AppColors.primaryBlue;
      case 'libur':
        return AppColors.dangerRed;
      case 'kegiatan':
        return AppColors.accentPurple;
      case 'penting':
        return AppColors.accentAmber;
      default:
        return AppColors.accentTeal;
    }
  }
}
