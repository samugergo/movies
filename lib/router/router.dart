import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies/pages/movie/movie_page.dart';
import 'package:movies/pages/show/show_page.dart';

import '../main.dart';

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context, 
  required GoRouterState state, 
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => 
      FadeTransition(opacity: animation, child: child),
  );
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        state: state,
        context: context,
        child: MainContainer()
      ),
      routes: [
        GoRoute(
          path: 'movie',
          pageBuilder: (context, state) {
            final id = state.queryParameters['id'];
            print(id);
            if(id != null) {
              return buildPageWithDefaultTransition(
                state: state,
                context: context,
                child: MoviePage(id: int.parse(id), color: Colors.black),
              );
            }
            return buildPageWithDefaultTransition(
              state: state,
              context: context,
              child: MainContainer()
            );
          },
        ),
        GoRoute(
          path: 'tv',
          pageBuilder: (context, state) {
            final id = state.queryParameters['id'];
            print(id);
            if(id != null) {
              return buildPageWithDefaultTransition(
                state: state,
                context: context,
                child: ShowPage(id: int.parse(id), color: Colors.black),
              );
            }
            return buildPageWithDefaultTransition(
              state: state,
              context: context,
              child: MainContainer()
            );
          },
        ),
      ]
    ),    
  ]
);