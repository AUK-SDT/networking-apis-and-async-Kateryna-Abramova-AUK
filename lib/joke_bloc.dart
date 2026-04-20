import 'package:flutter_bloc/flutter_bloc.dart';
import 'joke_service.dart';
import 'joke_model.dart';

abstract class JokeEvent {}

class LoadJokeEvent extends JokeEvent {}

abstract class JokeState {}

class JokeLoading extends JokeState {}

class JokeLoaded extends JokeState {
  final DadJoke joke;
  JokeLoaded(this.joke);
}

class JokeError extends JokeState {
  final String message;
  JokeError(this.message);
}

class JokeBloc extends Bloc<JokeEvent, JokeState> {
  final JokeService _jokeService;

  JokeBloc(this._jokeService) : super(JokeLoading()) {
    on<LoadJokeEvent>((event, emit) async {
      emit(JokeLoading());
      try {
        final joke = await _jokeService.fetchJoke();
        emit(JokeLoaded(joke));
      } catch (e) {
        emit(JokeError("ERROR: JOKE NOT FOUND"));
      }
    });
  }
}
