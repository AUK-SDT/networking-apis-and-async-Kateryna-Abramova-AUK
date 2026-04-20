import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'joke_bloc.dart';
import 'joke_service.dart';
import 'joke_screen.dart';

void main() {
  runApp(
    RepositoryProvider(
      create: (context) => JokeService(),
      child: BlocProvider(
        create: (context) =>
            JokeBloc(RepositoryProvider.of<JokeService>(context))
              ..add(LoadJokeEvent()),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JokeScreen(),
    );
  }
}
