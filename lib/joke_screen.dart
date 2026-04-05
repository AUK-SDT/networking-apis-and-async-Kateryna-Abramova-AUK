import 'package:flutter/material.dart';
import 'joke_service.dart';
import 'joke_model.dart';

class JokeScreen extends StatefulWidget {
  const JokeScreen({super.key});

  @override
  State<JokeScreen> createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen> {
  late Future<DadJoke> _jokeFuture;
  final List<DadJoke> _favorites = [];

  @override
  void initState() {
    super.initState();
    _jokeFuture = JokeService().fetchJoke();
  }

  void _getNewJoke() {
    setState(() {
      _jokeFuture = JokeService().fetchJoke();
    });
  }

  void _toggleFavorite(DadJoke joke) {
    setState(() {
      if (_favorites.any((item) => item.id == joke.id)) {
        _favorites.removeWhere((item) => item.id == joke.id);
        joke.isFavorite = false;
      } else {
        _favorites.add(joke);
        joke.isFavorite = true;
      }
    });
  }

  // Retro Button: 90s Bevel + Modern Rounded Corners (4px)
  Widget _retroButton({
    required String label,
    required VoidCallback onPressed,
    Color color = const Color(0xFFC0C0C0),
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4), // Modern hint
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'monospace',
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF008080), // Classic Win95 Teal
      appBar: AppBar(
        backgroundColor: const Color(0xFF000080), // Classic Win95 Navy
        title: const Text(
          'JOKE_GEN.EXE',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'monospace',
            fontSize: 16,
          ),
        ),
        elevation: 6,
      ),
      body: Column(
        children: [
          // MAIN JOKE AREA
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFC0C0C0),
                  borderRadius: BorderRadius.circular(4), // Modern hint
                  border: Border.all(color: Colors.black26, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      offset: const Offset(6, 6),
                      blurRadius: 0, // Sharp 90s shadow
                    ),
                  ],
                ),
                child: FutureBuilder<DadJoke>(
                  future: _jokeFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(
                          color: Color(0xFF000080),
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      final joke = snapshot.data!;
                      bool isSaved = _favorites.any((j) => j.id == joke.id);

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Joke Text Box
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(25),
                            color: Colors.white,
                            child: Text(
                              joke.joke,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontFamily: 'monospace',
                                height: 1.4,
                              ),
                            ),
                          ),
                          // Control Area
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _retroButton(
                                  label: 'Next',
                                  onPressed: _getNewJoke,
                                ),
                                const SizedBox(width: 15),
                                _retroButton(
                                  label: isSaved ? 'Saved' : 'Save',
                                  onPressed: () => _toggleFavorite(joke),
                                  color: isSaved
                                      ? Colors.yellow
                                      : const Color(0xFFC0C0C0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("FATAL ERROR: JOKE NOT FOUND"),
                    );
                  },
                ),
              ),
            ),
          ),

          // SAVED JOKES LOG (Favorites)
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFC0C0C0),
              border: const Border(
                top: BorderSide(color: Colors.black26, width: 2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -5), // Modern soft upward shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  color: const Color(0xFF000080),
                  child: const Text(
                    "SAVED_JOKES.LOG",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4), // Modern hint
                          border: Border.all(color: Colors.black26, width: 1),
                        ),
                        child: Text(
                          _favorites[index].joke,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
