import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/states/movie_cubit.dart';
import 'package:movies/states/movie_state.dart';

class StateLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieCubit(76600),
      child: _Loader(),
          // Opacity(
          //   opacity: 0.5,
          //   child: ModalBarrier(
          //     color: Colors.black,
          //   ),
          // ),
          // LoadingAnimationWidget.fourRotatingDots(
          //   color: Colors.white, 
          //   size: 50
          // ),
    );
  }
}

class _Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<MovieCubit, MovieState>(
          builder: (context, state) {
            return context.read<MovieCubit>().isLoading ? Text('Loading...') : Text(state.model!.title);
          }
        ),
      ]
    );
  }

}