class AppUser {
  String? id;
  String? email;
  String? fullName;
  String? status;
  String? profileImage;

  AppUser({
    this.id,
    this.email,
    this.fullName,
    this.status,
    this.profileImage,
  });

  AppUser.map(dynamic obj) {
    id = obj['id'];
    email = obj['email'];
    fullName = obj['fullName'];
    status = obj['status'];
    profileImage = obj['profileImage'];
  }

  Map<String?, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['email'] = email;
    map['fullName'] = fullName;
    map['status'] = status;
    map['profileImage'] = profileImage;

    return map;
  }

  AppUser.fromMap(Map<String?, dynamic> map) {
    id = map['id'];
    email = map['email'];
    fullName = map['fullName'];
    status = map['status'];
    profileImage = map['profileImage'];
  }
}
