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
import '../../widgets/status_chip.dart';
import '../../widgets/back_button_overlay.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: const BackLeadingButton(),
        title: Text(
          'SMANSA Mobile LMS',
          style: AppTextStyles.cardTitle.copyWith(
            color: AppColors.primaryBlue,
            fontSize: 16,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlueHeader(
                title: 'Kalender Akademik',
                subtitle: _subtitle,
                height: 140,
              ),
              Transform.translate(
                offset: const Offset(0, -30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.screenPadding,
                  ),
                  child: _buildCalendar(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.screenPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Agenda', style: AppTextStyles.sectionTitle),
                    TextButton.icon(
                      onPressed: _load,
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Muat Ulang'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildAgendaList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 14,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
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
          titleTextStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left_rounded,
            color: AppColors.textSecondary,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          weekendStyle: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        calendarStyle: CalendarStyle(
          cellMargin: const EdgeInsets.all(6.0),
          outsideDaysVisible: false,
          defaultDecoration: const BoxDecoration(shape: BoxShape.circle),
          weekendDecoration: const BoxDecoration(shape: BoxShape.circle),
          selectedDecoration: const BoxDecoration(
            color: AppColors.primaryBlue,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
          markerDecoration: const BoxDecoration(
            color: AppColors.primaryBlue,
            shape: BoxShape.circle,
          ),
          markerSize: 4.0,
          markersAlignment: Alignment.bottomCenter,
          markerMargin: const EdgeInsets.only(top: 2),
        ),
      ),
    );
  }

  Widget _buildAgendaList() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryBlue,
          ),
        ),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 32,
                color: AppColors.textSecondary,
              ),
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
      );
    }

    if (_events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            'Belum ada agenda pada tahun ini.',
            style: AppTextStyles.bodySecondary,
          ),
        ),
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

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.responsivePadding(MediaQuery.of(context).size.width),
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) => _buildEventCard(list[index]),
    );
  }

  Widget _buildEventCard(EventKalender event) {
    final formatterDay = DateFormat('dd');
    final formatterMonth = DateFormat('MMM');

    String dateStr = formatterDay.format(event.tanggalMulai);
    if (!isSameDay(event.tanggalMulai, event.tanggalSelesai)) {
      dateStr += '-${formatterDay.format(event.tanggalSelesai)}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.itemSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.primaryBlueTint,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dateStr,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  formatterMonth.format(event.tanggalMulai).toUpperCase(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          event.judul,
                          style: AppTextStyles.cardTitle,
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
                  const SizedBox(height: 8),
                  if (event.waktu != null) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(event.waktu!, style: AppTextStyles.smallText),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (event.lokasi != null) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event.lokasi!,
                            style: AppTextStyles.smallText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (event.deskripsi != null)
                    Text(
                      event.deskripsi!,
                      style: AppTextStyles.bodySecondary.copyWith(
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}