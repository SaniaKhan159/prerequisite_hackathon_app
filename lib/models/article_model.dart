class ArticleModel {
  String title;
  String author;
  String description;
  String url;
  String urlToImage;
  DateTime publshedAt;
  String content;

  ArticleModel({
    required this.title,
    required this.description,
    required this.author,
    required this.content,
    required this.publshedAt,
    required this.url,
    required this.urlToImage,
  });
}
