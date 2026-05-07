import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const purpleDark = Color(0xFF4A148C);
  static const purpleMid = Color(0xFF7B1FA2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [purpleDark, purpleMid, Color(0xFF9C27B0)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar manual agar tetap konsisten
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Tentang Saya',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Foto + nama
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withOpacity(0.6),
                              width: 3),
                        ),
                        child: const CircleAvatar(
                          radius: 55,
                          backgroundImage:
                              AssetImage('assets/images/anacomel.jpg'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Ana Zumrotu Nailir Rif Ah",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Teknik Informatika • PENS",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Card konten
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: purpleDark.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle('👩‍💻 Tentang Saya'),
                            const SizedBox(height: 10),
                            const Text(
                              "Saya adalah mahasiswa Politeknik Elektronika Negeri Surabaya yang sedang mendalami pengembangan aplikasi mobile. "
                              "Fokus utama saya saat ini adalah mempelajari framework Flutter untuk menciptakan "
                              "pengalaman pengguna yang luar biasa dan efisien.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 14,
                                  height: 1.7,
                                  color: Color(0xFF444444)),
                            ),
                            const SizedBox(height: 24),

                            _sectionTitle('🎯 Minat & Keahlian'),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                'Flutter', 'Dart', 'Laravel',
                                'UI/UX Design', 'REST API', 'Mobile Dev'
                              ].map((skill) => _skillChip(skill)).toList(),
                            ),
                            const SizedBox(height: 24),

                            _sectionTitle('📍 Informasi'),
                            const SizedBox(height: 10),
                            _infoTile(Icons.school_outlined,
                                'Politeknik Elektronika Negeri Surabaya'),
                            const SizedBox(height: 8),
                            _infoTile(Icons.location_city_outlined,
                                'Surabaya, Jawa Timur'),
                            const SizedBox(height: 8),
                            _infoTile(
                                Icons.calendar_today_outlined, 'Angkatan 2024'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Footer
                      Text(
                        "© 2026 Teknik Informatika • PENS",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 12,
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
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: purpleDark,
      ),
    );
  }

  Widget _skillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: purpleMid.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: purpleDark,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: purpleMid, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF555555))),
        ),
      ],
    );
  }
}