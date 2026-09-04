import 'package:flutter/material.dart';

class NilaiMapel {
  final String namaMapel;
  final String namaGuru;
  final int kkm;
  final double nilaiAkhir;
  final String hurufMutu;
  final Color ikonColor;
  final String ikonLabel;

  const NilaiMapel({
    required this.namaMapel,
    required this.namaGuru,
    required this.kkm,
    required this.nilaiAkhir,
    required this.hurufMutu,
    required this.ikonColor,
    required this.ikonLabel,
  });
}
