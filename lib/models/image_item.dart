import 'dart:convert';

class ImageItem {
  final String url;
  final String path;
  final String author;
  final String description;

  ImageItem({
    required this.url,
    required this.path,
    required this.author,
    required this.description,
  });

  @override
  bool operator ==(covariant ImageItem other) =>
      url == other.url &&
      path == other.path &&
      description == other.description &&
      author == other.author;

  @override
  int get hashCode =>
      url.hashCode + path.hashCode + author.hashCode + description.hashCode;
}
