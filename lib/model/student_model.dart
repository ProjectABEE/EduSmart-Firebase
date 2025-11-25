class StudentModel {
  final String? id;
  final String? name;
  final String? email;
  final String? className;
  final int? age;
  final String? noTelp;
  final String? alamat;
  final String? tanggalLahir;
  final String? namaOrtu;
  final String? kontakOrtu;
  final String? role;

  StudentModel({
    this.id,
    this.name,
    this.email,
    this.className,
    this.age,
    this.noTelp,
    this.alamat,
    this.tanggalLahir,
    this.namaOrtu,
    this.kontakOrtu,
    this.role,
  });

  StudentModel copyWith({
    String? id,
    String? name,
    String? email,
    String? className,
    int? age,
    String? noTelp,
    String? alamat,
    String? tanggalLahir,
    String? namaOrtu,
    String? kontakOrtu,
    String? role,
  }) {
    return StudentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      className: className ?? this.className,
      age: age ?? this.age,
      noTelp: noTelp ?? this.noTelp,
      alamat: alamat ?? this.alamat,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      namaOrtu: namaOrtu ?? this.namaOrtu,
      kontakOrtu: kontakOrtu ?? this.kontakOrtu,
      role: role ?? this.role,
    );
  }

  /// 🔥 Untuk Firestore (pakai camelCase)
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "className": className,
      "age": age,
      "noTelp": noTelp,
      "alamat": alamat,
      "tanggalLahir": tanggalLahir,
      "namaOrtu": namaOrtu,
      "kontakOrtu": kontakOrtu,
      "role": role,
    };
  }

  /// 🔥 Baca data dari Firestore
  factory StudentModel.fromMap(Map<String, dynamic> json) {
    return StudentModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      className: json["className"] ?? json["class"] ?? json["class_name"],
      age: json["age"],
      noTelp: json["noTelp"] ?? json["no_telp"],
      alamat: json["alamat"],
      tanggalLahir: json["tanggalLahir"] ?? json["tanggal_lahir"],
      namaOrtu: json["namaOrtu"] ?? json["nama_ortu"],
      kontakOrtu: json["kontakOrtu"] ?? json["kontak_ortu"],
      role: json["role"] ?? "siswa",
    );
  }
}
