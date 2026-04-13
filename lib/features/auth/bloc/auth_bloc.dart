import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/core/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthBlocState> {
  final AuthService _authService = AuthService();

  AuthBloc() : super(AuthInitialState()) {
    on<CheckSessionEvent>((event, emit) async {
      emit(AuthLoadingState());
      final session = _authService.currentSession;
      if (session != null) {
        emit(AuthAuthenticatedState(session.user));
      } else {
        emit(AuthUnauthenticatedState());
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final response = await _authService.signIn(event.email, event.password);
        emit(AuthAuthenticatedState(response.user!));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<SignupEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final response = await _authService.signUp(event.email, event.password);
        emit(AuthAuthenticatedState(response.user!));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoadingState());
      await _authService.signOut();
      emit(AuthUnauthenticatedState());
    });
  }
}
