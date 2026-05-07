import 'package:flutter/material.dart';
import 'package:flutter_demo_app/utils/session_manager.dart';
import 'login.dart';
import 'about.dart';
import 'models/profile_model.dart';
import 'services/profile_service.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

// ─────────────────────────────────────────────
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ProfileService _profileService = ProfileService();
  final SessionManager _sessionManager = SessionManager();

  static const purpleDark = Color(0xFF4A148C);
  static const purpleMid = Color(0xFF7B1FA2);
  static const purpleLight = Color(0xFFF3E5F5);
  static const bgColor = Color(0xFFFAF5FF);

  // Data statis awal — sudah terisi, tidak bergantung API
  // _fields Menyimpan data profil secara lokal: NRP, Prodi, Email, HP, Lokasi
  final List<Map<String, dynamic>> _fields = [
    {
      'icon': Icons.badge_outlined,
      'label': 'NRP',
      'value': '3124521005',
      'key': 'nrp',
    },
    {
      'icon': Icons.school_outlined,
      'label': 'Program Studi',
      'value': 'Teknik Informatika',
      'key': 'program_studi',
    },
    {
      'icon': Icons.email_outlined,
      'label': 'Email',
      'value': 'ana@student.pens.ac.id',
      'key': 'email',
    },
    {
      'icon': Icons.phone_outlined,
      'label': 'No. HP / Phone',
      'value': '08123456789',
      'key': 'phone',
    },
    {
      'icon': Icons.location_on_outlined,
      'label': 'Location',
      'value': 'Surabaya, Jawa Timur',
      'key': 'location',
    },
  ];

  // Sinkron ke Laravel (opsional, tidak blokir UI)
  int? _laravelId;

  @override
  void initState() {
    super.initState();
    _syncFromLaravel(); // _syncFromLaravel() aat halaman dibuka, coba ambil data dari Laravel. Kalau gagal, data lokal tetap tampil
  }

  /// Coba ambil data dari Laravel. Kalau gagal, pakai data lokal di atas.
  Future<void> _syncFromLaravel() async {
    try {
      final list = await _profileService.getProfiles();
      if (list.isNotEmpty && mounted) {
        final p = list.first;
        setState(() {
          _laravelId = p.id;
          _fields[0]['value'] = p.nrp;
          _fields[1]['value'] = p.programStudi;
          _fields[2]['value'] = p.email;
          _fields[3]['value'] = p.phone;
          _fields[4]['value'] = p.location;
        });
      }
    } catch (_) {
      // Biarkan data lokal tetap tampil
    }
  }
//  _logout Hapus token lalu kembali ke LoginPage
  Future<void> _logout() async {
    await _sessionManager.removeAccessToken();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  // ── Dialog edit satu field ──────────────────
  //_showEditDialog ini Menampilkan popup form edit untuk satu field, lalu kirim update ke Laravel
  void _showEditDialog(int fieldIndex) {
    final field = _fields[fieldIndex];
    final ctrl = TextEditingController(text: field['value']);
    final formKey = GlobalKey<FormState>();
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Edit ${field['label']}',
            style: const TextStyle(
                color: purpleDark, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: ctrl,
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon:
                    Icon(field['icon'] as IconData, color: purpleMid, size: 20),
                labelText: field['label'] as String,
                filled: true,
                fillColor: purpleLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: purpleMid, width: 2),
                ),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? '${field['label']} tidak boleh kosong'
                  : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal',
                  style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;
                      setDialogState(() => isSaving = true);

                      // Update nilai lokal
                      setState(() {
                        _fields[fieldIndex]['value'] = ctrl.text.trim();
                      });

                      // Coba simpan ke Laravel
                      try {
                        final profile = ProfileModel(
                          id: _laravelId,
                          nrp: _fields[0]['value'] as String,
                          programStudi: _fields[1]['value'] as String,
                          email: _fields[2]['value'] as String,
                          phone: _fields[3]['value'] as String,
                          location: _fields[4]['value'] as String,
                        );
                        if (_laravelId == null) {
                          final created =
                              await _profileService.createProfile(profile);
                          setState(() => _laravelId = created.id);
                        } else {
                          await _profileService.updateProfile(
                              _laravelId!, profile);
                        }
                      } catch (_) {
                        // Tetap simpan lokal walaupun API gagal
                      }

                      if (ctx.mounted) Navigator.pop(ctx);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: purpleMid,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dialog hapus satu field (reset ke kosong) ─
  //_showDeleteDialog()Menampilkan konfirmasi hapus, lalu reset nilai field ke "-""
  void _showDeleteDialog(int fieldIndex) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Data',
            style: TextStyle(
                color: purpleDark, fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text(
            'Yakin ingin menghapus data "${_fields[fieldIndex]['label']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() {
                _fields[fieldIndex]['value'] = '-';
              });
              // Sinkron ke Laravel
              try {
                if (_laravelId != null) {
                  final profile = ProfileModel(
                    id: _laravelId,
                    nrp: _fields[0]['value'] as String,
                    programStudi: _fields[1]['value'] as String,
                    email: _fields[2]['value'] as String,
                    phone: _fields[3]['value'] as String,
                    location: _fields[4]['value'] as String,
                  );
                  await _profileService.updateProfile(_laravelId!, profile);
                }
              } catch (_) {}
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${_fields[fieldIndex]['label']} berhasil dihapus'),
                    backgroundColor: purpleMid,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Column(
          children: [
            // ── FOTO PROFIL ──────────────────────────
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: purpleMid, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: purpleMid.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                ],
              ),

              // CircleAvatar Untuk membuat foto profil menjadi bulat sempurna
              child: const CircleAvatar(
                radius: 58,
                backgroundImage: AssetImage('assets/images/anacomel.jpg'),
              ),
            ),
            const SizedBox(height: 18),

            // ── NAMA ─────────────────────────────────
            Text(
              "Ana Zumrotu Nailir Rif Ah",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: purpleDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              "Informatics Engineering Student",
              style: TextStyle(
                fontSize: 13,
                color: purpleMid.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 14),

            // ── TOMBOL ABOUT ─────────────────────────
            OutlinedButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AboutPage())),
              icon: const Icon(Icons.info_outline_rounded,
                  color: purpleMid, size: 18),
              label: const Text('Tentang Saya',
                  style: TextStyle(
                      color: purpleMid, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: purpleMid, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
              ),
            ),
            const SizedBox(height: 28),

            // ── KARTU PROFIL (CRUD per field) ─────────
           // Container fungsi yang menampung data NRP, Email, dll. 
           //berbentuk kotak dengan sudut melengkung (rounded)dengan properti BoxDecoration.
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: purpleDark.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                children: List.generate(_fields.length, (i) {
                  final isLast = i == _fields.length - 1;
                  return Column(
                    children: [
                      _buildFieldRow(i), // _buildFieldRow Membangun tampilan satu baris field (icon + label + nilai + tombol edit + hapus)
                      if (!isLast)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: purpleLight,
                          indent: 16,
                          endIndent: 16,
                        ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldRow(int index) {
    final field = _fields[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Icon lingkaran kecil
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: purpleLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(field['icon'] as IconData,
                color: purpleMid, size: 20),
          ),
          const SizedBox(width: 14),

          // Label + Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field['label'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  field['value'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
              ],
            ),
          ),

          // Tombol Edit
          _actionButton( 
            icon: Icons.edit_outlined,
            color: purpleMid,
            bgColor: purpleLight,
            onTap: () => _showEditDialog(index),
          ),
          const SizedBox(width: 6),

          // Tombol Hapus
          _actionButton(
            icon: Icons.delete_outline_rounded,
            color: Colors.redAccent,
            bgColor: Colors.red.shade50,
            onTap: () => _showDeleteDialog(index),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 17),
      ),
    );
  }
}