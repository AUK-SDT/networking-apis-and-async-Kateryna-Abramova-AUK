import 'package:flutter/material.dart';
import 'joke_service.dart';
import 'joke_model.dart';

class JokeScreen extends StatefulWidget {
  @override
  _JokeScreenState createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen> {
  late Future<DadJoke> _jokeFuture;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dad Joke Generator')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: FutureBuilder<DadJoke>(
            future: _jokeFuture,
            builder: (context, snapshot) {
              // 1. LOADING STATE
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              // 2. ERROR STATE
              else if (snapshot.hasError) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 50),
                    Text('Error: ${snapshot.error}'),
                    ElevatedButton(
                      onPressed: _getNewJoke,
                      child: Text('Try Again'),
                    ),
                  ],
                );
              }
              // 3. LOADED STATE
              else if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.data!.joke,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _getNewJoke,
                      child: Text('Next Joke'),
                    ),
                  ],
                );
              }

              return Text('No jokes found...');
            },
          ),
        ),
      ),
    );
  }
}
