import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthBlocState {}

class AuthLoadingState extends AuthBlocState {}

class AuthAuthenticatedState extends AuthBlocState {
  final User user;
  AuthAuthenticatedState(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticatedState extends AuthBlocState {}

class AuthErrorState extends AuthBlocState {
  final String message;
  AuthErrorState(this.message);
  @override
  List<Object?> get props => [message];
}
