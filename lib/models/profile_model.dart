class ProfileModel {
  final int? id;
  final String nrp;
  final String programStudi;
  final String email;
  final String phone;
  final String location;

  ProfileModel({
    this.id,
    required this.nrp,
    required this.programStudi,
    required this.email,
    required this.phone,
    required this.location,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      nrp: json['nrp'] ?? '',
      programStudi: json['program_studi'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'nrp': nrp,
        'program_studi': programStudi,
        'email': email,
        'phone': phone,
        'location': location,
      };
}