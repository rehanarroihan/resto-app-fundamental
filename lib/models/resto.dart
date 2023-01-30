class Resto {
  String? id;
  String? name;
  String? description;
  String? pictureId;
  String? city;
  double? rating;

  Resto({
    this.id,
    this.name,
    this.description,
    this.pictureId,
    this.city,
    this.rating
  });

  Resto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    pictureId = json['pictureId'];
    city = json['city'];
    rating = json['rating'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['pictureId'] = pictureId;
    data['city'] = city;
    data['rating'] = rating;
    return data;
  }
}