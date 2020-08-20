import 'package:bloc/bloc.dart';
import 'package:immutable_model/value_types.dart';

import 'user_cubit.dart';
import '../models/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserCubit userCubit;

  AuthCubit(this.userCubit) : super(AuthInitial());

  void signIn(ModelEmail email, ModelPassword password) {
    emit(AuthLoading());
    userCubit.updateEmailPassword(email, password);
    emit(AuthSignedIn());
  }
}
