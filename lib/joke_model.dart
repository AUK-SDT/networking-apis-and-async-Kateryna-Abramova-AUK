class DadJoke {
  final String id;
  final String joke;

  DadJoke({required this.id, required this.joke});

  factory DadJoke.fromJson(Map<String, dynamic> json) {
    return DadJoke(id: json['id'], joke: json['joke']);
  }
}
