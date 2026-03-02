import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Kita tetap menggunakan tema bawaan dengan warna dasar Deep Purple
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Profil Mahasiswa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Menggunakan warna dari theme agar konsisten
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // --- FOTO PROFIL ---
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/anacomel.jpg'),
              ),
              const SizedBox(height: 25),

              // --- BIODATA UTAMA ---
              Text(
                "Ana Zumrotu Nailir Rif Ah",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 15),

              // Kartu Informasi NIM & Prodi
              Card(
                elevation: 0,
                color: Theme.of(
                  context,
                ).colorScheme.surfaceVariant.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.badge_outlined, "NRP", "3124521005"),
                      const Divider(height: 25),
                      _buildInfoRow(
                        Icons.school_outlined,
                        "Program Studi",
                        "Teknik Informatika",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // --- DESKRIPSI ---
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Tentang Saya",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Saya adalah mahasiswa Politeknik Elektronika Negeri Surabaya yang sedang mendalami pengembangan aplikasi mobile. "
                "Fokus utama saya saat ini adalah mempelajari framework Flutter untuk menciptakan "
                "pengalaman pengguna yang luar biasa dan efisien.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget agar kode tetap rapi
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
