import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/calcular_valor_hora_usecase.dart';
import '../../data/repositories/usuario_config_repository.dart';
import 'perfil_state.dart';

class PerfilCubit extends Cubit<PerfilState> {
  final CalcularValorHoraUseCase _calcularUseCase;
  final UsuarioConfigRepository _repository;

  PerfilCubit(this._calcularUseCase, this._repository) : super(PerfilInitial());

  // Salva o salário e as horas chamando o cérebro do app (Domain)
  Future<void> salvarPerfil(double salario, int horas) async {
    emit(PerfilLoading());
    try {
      await _calcularUseCase.executar(salario: salario, horas: horas);
      emit(PerfilSucesso());
    } catch (e) {
      emit(PerfilErro("Erro ao salvar: ${e.toString()}"));
    }
  }
}
