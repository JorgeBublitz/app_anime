class Image {
  final String imageUrl;
  final String? smallImageUrl;
  final String? largeImageUrl;

  Image({required this.imageUrl, this.smallImageUrl, this.largeImageUrl});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      imageUrl: json['image_url'] ?? '',
      smallImageUrl: json['small_image_url'],
      largeImageUrl: json['large_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_url': imageUrl,
      if (smallImageUrl != null) 'small_image_url': smallImageUrl,
      if (largeImageUrl != null) 'large_image_url': largeImageUrl,
    };
  }
}

class Images {
  final Image jpg;
  final Image? webp;

  Images({required this.jpg, this.webp});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      jpg: Image.fromJson(json['jpg'] ?? {}),
      webp: json['webp'] != null ? Image.fromJson(json['webp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'jpg': jpg.toJson(), if (webp != null) 'webp': webp!.toJson()};
  }
}
