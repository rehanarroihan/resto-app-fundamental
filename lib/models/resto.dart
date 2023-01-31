class Resto {
  String? id;
  String? name;
  String? description;
  String? pictureId;
  String? city;
  double? rating;
  bool? isFavorite;

  Resto({
    this.id,
    this.name,
    this.description,
    this.pictureId,
    this.city,
    this.rating,
    this.isFavorite = false
  });

  Resto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    pictureId = json['pictureId'];
    city = json['city'];
    rating = json['rating'].toDouble();
    isFavorite = json['isFavorite'] == 1 ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['pictureId'] = pictureId;
    data['city'] = city;
    data['rating'] = rating;
    data['isFavorite'] = isFavorite == true ? 1 : 0;
    return data;
  }
}