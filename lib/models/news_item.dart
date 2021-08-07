class NewsItem {
  NewsItem({
    this.id,
    this.category,
    this.headline,
    this.link,
    this.publisher,
    this.publishedAt,
  });

  String? id;
  String? category;
  String? headline;
  String? link;
  String? publisher;
  int? publishedAt;

  factory NewsItem.fromMap(Map<String, dynamic> json) => NewsItem(
        id: json["id"],
        category: json["category"],
        headline: json["headline"],
        link: json["link"],
        publisher: json["publisher"],
        publishedAt: json["publishedAt"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "category": category,
        "headline": headline,
        "link": link,
        "publisher": publisher,
        "publishedAt": publishedAt,
      };
}
