import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onEvent(bloc, transition);
  }

  @override
  Future<void> onError(Cubit cubit, Object error, StackTrace stackTrace) async {
    print(error);
    super.onEvent(cubit, error);
  }
}
