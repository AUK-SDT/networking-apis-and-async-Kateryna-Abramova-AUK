class DadJoke {
  final String id;
  final String joke;

  bool isFavorite;

  DadJoke({required this.id, required this.joke, this.isFavorite = false});

  factory DadJoke.fromJson(Map<String, dynamic> json) {
    return DadJoke(id: json['id'], joke: json['joke']);
  }
}
