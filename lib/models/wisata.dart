class Wisata {
  String nama, deskripsi, gambar, vrImage;
  Koordinat koordinat;

  Wisata(
      {this.nama, this.koordinat, this.deskripsi, this.gambar, this.vrImage});

  factory Wisata.fromJson(Map<String, dynamic> json) {
    return Wisata(
      nama: json["nama"].toString(),
      koordinat: Koordinat.fromJson(json["koordinat"]),
      deskripsi: json["deskripsi"].toString(),
      gambar: json["gambar"].toString(),
      vrImage: json["vr_image"].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'nama': this.nama,
      'koordinat': this.koordinat.toJson(),
      'deskripsi': this.deskripsi,
      'gambar': this.gambar,
      'vr_image': this.vrImage,
    };
  }
}

class Koordinat {
  double latitude, longitude;

  Koordinat({this.latitude, this.longitude});

  factory Koordinat.fromJson(Map<String, dynamic> json) {
    return Koordinat(
      latitude: double.parse(json["latitude"].toString()),
      longitude: double.parse(json["longitude"].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'latitude': this.latitude,
      'longitude': this.longitude
    };
  }
}
