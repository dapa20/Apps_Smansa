import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi locale Indonesia untuk DateFormat('...', 'id_ID')
  // agar mencegah LocaleDataException di semua screen.
  initializeDateFormatting('id_ID', null).then((_) {
    runApp(const LmsSmansaApp());
  });
}
