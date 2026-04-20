import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Added BLoC import
import 'joke_bloc.dart';
import 'joke_model.dart';

class JokeScreen extends StatefulWidget {
  const JokeScreen({super.key});

  @override
  State<JokeScreen> createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen> {
  // Favorites stay in the UI state as they are a local feature, not from the API
  final List<DadJoke> _favorites = [];

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
          borderRadius: BorderRadius.circular(4),
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
      backgroundColor: const Color(0xFF008080),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000080),
        title: const Text(
          'JOKE GENERATOR',
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
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFC0C0C0),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.black26, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      offset: const Offset(6, 6),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: BlocBuilder<JokeBloc, JokeState>(
                  builder: (context, state) {
                    if (state is JokeLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(
                          color: Color(0xFF000080),
                        ),
                      );
                    }

                    if (state is JokeLoaded) {
                      final joke = state.joke;
                      bool isSaved = _favorites.any((j) => j.id == joke.id);

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _retroButton(
                                  label: 'Next',
                                  onPressed: () => context.read<JokeBloc>().add(
                                    LoadJokeEvent(),
                                  ),
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

                    if (state is JokeError) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(state.message),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),

          // Favorites Section
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFC0C0C0),
              border: const Border(
                top: BorderSide(color: Colors.black26, width: 2),
              ),
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
                    "SAVED JOKES",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
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
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black26, width: 1),
                        ),
                        child: Text(
                          _favorites[index].joke,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
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
