import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    // Simulación de espera asíncrona de 1.5 segundos
    await Future.delayed(const Duration(milliseconds: 1500));

    if (email == 'correo@ejemplo.com' && password == 'Segur1dad2024*') {
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        email: email,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Credenciales inválidas. Verifique su correo y contraseña.',
      );
      return false;
    }
  }

  void logout() {
    state = const AuthState();
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});