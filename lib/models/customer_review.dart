class CustomerReview {
  String? name;
  String? review;
  String? date;

  CustomerReview({this.name, this.review, this.date});

  CustomerReview.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    review = json['review'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['review'] = review;
    data['date'] = date;
    return data;
  }
}