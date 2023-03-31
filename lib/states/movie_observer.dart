import 'package:bloc/bloc.dart';

class MovieObserver extends BlocObserver {
  MovieObserver();

  @override
  void onChange(BlocBase bloc, Change change) {    
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}