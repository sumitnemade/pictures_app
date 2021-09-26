import 'package:cloud_firestore/cloud_firestore.dart';

class ImageModel {
  String? id;
  String? name;
  String? userId;
  Timestamp? uploadDate;
  String? url;
  String? userName;
  String? hashTag;

  ImageModel({
    this.id,
    this.name,
    this.userId,
    this.uploadDate,
    this.userName,
    this.hashTag,
    this.url,
  });

  ImageModel.map(dynamic obj) {
    id = obj['id'];
    name = obj['name'];
    userName = obj['userName'];
    userId = obj['userId'];
    uploadDate = obj['uploadDate'];
    hashTag = obj['hashTag'];
    url = obj['url'];
  }

  Map<String?, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['userId'] = userId;
    map['uploadDate'] = uploadDate;
    map['hashTag'] = hashTag;
    map['url'] = url;
    map['userName'] = userName;

    return map;
  }

  ImageModel.fromMap(Map<String?, dynamic> map) {
    id = map['id'];
    name = map['name'];
    userId = map['userId'];
    userName = map['userName'];
    uploadDate = map['uploadDate'];
    hashTag = map['hashTag'];
    url = map['url'];
  }
}
