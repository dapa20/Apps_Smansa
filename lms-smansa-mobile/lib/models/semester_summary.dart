class SemesterSummary {
  final int semesterKe;
  final String tahunAjaran;
  final String periode; // 'Ganjil' | 'Genap'
  final double ips;
  final double target;

  const SemesterSummary({
    required this.semesterKe,
    required this.tahunAjaran,
    required this.periode,
    required this.ips,
    required this.target,
  });
}
