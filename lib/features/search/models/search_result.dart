enum SearchResultType {
  bottle,
  event,
  user,
}

class SearchResult {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final SearchResultType type;
  final Map<String, dynamic> additionalData;

  const SearchResult({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.type,
    this.additionalData = const {},
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      type: SearchResultType.values.firstWhere(
        (e) => e.name == json['type'] as String,
        orElse: () => SearchResultType.bottle,
      ),
      additionalData: json['additional_data'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'type': type.name,
      'additional_data': additionalData,
    };
  }
} 