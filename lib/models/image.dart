import 'dart:convert';

/// request images
///

class Picture {
  ///Image Url

  final String image;
  Picture({
    required this.image,
  });

  Picture copyWith({
    String? image,
  }) {
    return Picture(
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
    };
  }

  factory Picture.fromMap(Map<String, dynamic> map) {
    return Picture(
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Picture.fromJson(String source) =>
      Picture.fromMap(json.decode(source));

  @override
  String toString() => 'Picture(image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Picture && other.image == image;
  }

  @override
  int get hashCode => image.hashCode;
}
